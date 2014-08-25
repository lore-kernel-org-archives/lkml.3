Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaHYVHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:07:12 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42021 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:07:09 -0400
Date: Mon, 25 Aug 2014 16:07:00 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Shachar Raindel <raindel@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>, Christoph Lameter <cl@linux.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomk@rgmadvisors.com" <tomk@rgmadvisors.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Message-ID: <20140825210700.GA5759@sbohrermbp13-local.rgmadvisors.com>
References: <1407860855-6564-1-git-send-email-shawn.bohrer@gmail.com>
 <20140820232212.GA5487@sbohrermbp13-local.rgmadvisors.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E235B4A@MTLDAG02.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B010E235B4A@MTLDAG02.mtl.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:20:34AM +0000, Shachar Raindel wrote:
> Hi,
> 
> I'm afraid this patch, in its current form, will not work.
> See below for additional comments.

Thanks for the input Shachar.  I've tried to answer your questions
below.
 
> > > In debugging an application that receives -ENOMEM from ib_reg_mr() I
> > > found that ib_umem_get() can fail because the pinned_vm count has
> > > wrapped causing it to always be larger than the lock limit even with
> > > RLIMIT_MEMLOCK set to RLIM_INFINITY.
> > >
> > > The wrapping of pinned_vm occurs because the process that calls
> > > ib_reg_mr() will have its mm->pinned_vm count incremented.  Later a
> > > different process with a different mm_struct than the one that allocated
> > > the ib_umem struct ends up releasing it which results in decrementing
> > > the new processes mm->pinned_vm count past zero and wrapping.
> > >
> > > I'm not entirely sure what circumstances cause a different process to
> > > release the ib_umem than the one that allocated it but the kernel stack
> > > trace of the freeing process from my situation looks like the following:
> > >
> > > Call Trace:
> > >  [<ffffffff814d64b1>] dump_stack+0x19/0x1b
> > >  [<ffffffffa0b522a5>] ib_umem_release+0x1f5/0x200 [ib_core]
> > >  [<ffffffffa0b90681>] mlx4_ib_destroy_qp+0x241/0x440 [mlx4_ib]
> > >  [<ffffffffa0b4d93c>] ib_destroy_qp+0x12c/0x170 [ib_core]
> > >  [<ffffffffa0cc7129>] ib_uverbs_close+0x259/0x4e0 [ib_uverbs]
> > >  [<ffffffff81141cba>] __fput+0xba/0x240
> > >  [<ffffffff81141e4e>] ____fput+0xe/0x10
> > >  [<ffffffff81060894>] task_work_run+0xc4/0xe0
> > >  [<ffffffff810029e5>] do_notify_resume+0x95/0xa0
> > >  [<ffffffff814e3dd0>] int_signal+0x12/0x17
> > >
> 
> Can you provide the details of this issue - kernel version,
> reproduction steps, etc.?  It seems like the kernel code flow which
> triggers this is delaying the FD release done at
> http://lxr.free-electrons.com/source/fs/file_table.c#L279 .  The
> code there seems to have changed (starting at kernel 3.6) to avoid
> releasing a file in interrupt context or from a kernel thread.  How
> are we ending up with releasing the uverbs device file from an
> interrupt context or a kernel thread?

We are seeing this on 3.10.* kernels.  Unfortunately I'm not quite
sure what the reproducing steps are, because we can't reliably
reproduce it.  Or rather we have been able to reliably reproduce the
issue in certain production situations, but can't seem to reproduce it
outside of production so it seems we are missing something.

What I do know is that the issue often occurs when we try to replace a
set of processes with a new set of processes.  Both process sets will
be using RC and UD QPs.  When I finally discovered what the issue was,
I clearly saw an ib_umem struct allocated in one of the processes that
was going away get released in the context of one of the newly started
processes.

> > > The following patch fixes the issue by storing the mm_struct of the
> 
> You are doing more than just storing the mm_struct - you are taking
> a reference to the process' mm.  This can lead to a massive resource
> leakage. The reason is bit complex: The destruction flow for IB
> uverbs is based upon releasing the file handle for it. Once the file
> handle is released, all MRs, QPs, CQs, PDs, etc. that the process
> allocated are released.  For the kernel to release the file handle,
> the kernel reference count to it needs to reach zero.  Most IB
> implementations expose some hardware registers to the application by
> allowing it to mmap the uverbs device file.  This mmap takes a
> reference to uverbs device file handle that the application opened.
> This reference is dropped when the process mm is released during the
> process destruction.  Your code takes a reference to the mm that
> will only be released when the parent MR/QP is released.
> 
> Now, we have a deadlock - the mm is waiting for the MR to be
> destroyed, the MR is waiting for the file handle to be destroyed,
> and the file handle is waiting for the mm to be destroyed.
> 
> The proper solution is to keep a reference to the task_pid (using
> get_task_pid), and use this pid to get the task_struct and from it
> the mm_struct during the destruction flow.
 
I'll put together a patch using get_task_pid() and see if I can
test/reproduce the issue.  This may take a couple of days since we
have to test this in production at the moment.
 
> > > process that calls ib_umem_get() so that ib_umem_release and/or
> > > ib_umem_account() can properly decrement the pinned_vm count of the
> > > correct mm_struct.
> > >
> > > Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> > > ---
> > >  drivers/infiniband/core/umem.c |   17 ++++++++---------
> > >  1 files changed, 8 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/umem.c
> > b/drivers/infiniband/core/umem.c
> > > index a3a2e9c..32699024 100644
> > > --- a/drivers/infiniband/core/umem.c
> > > +++ b/drivers/infiniband/core/umem.c
> > > @@ -105,6 +105,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext
> > *context, unsigned long addr,
> > >  	umem->length    = size;
> > >  	umem->offset    = addr & ~PAGE_MASK;
> > >  	umem->page_size = PAGE_SIZE;
> > > +	umem->mm        = get_task_mm(current);
> 
> This takes a reference to the current task mm. This will break the freeing up flows.
> 
> > >  	/*
> > >  	 * We ask for writable memory if any access flags other than
> > >  	 * "remote read" are set.  "Local write" and "remote write"
> > > @@ -198,6 +199,7 @@ out:
> > >  	if (ret < 0) {
> > >  		if (need_release)
> > >  			__ib_umem_release(context->device, umem, 0);
> > > +		mmput(umem->mm);
> > >  		kfree(umem);
> > >  	} else
> > >  		current->mm->pinned_vm = locked;
> > > @@ -229,13 +231,11 @@ static void ib_umem_account(struct work_struct
> > *work)
> > >  void ib_umem_release(struct ib_umem *umem)
> > >  {
> > >  	struct ib_ucontext *context = umem->context;
> > > -	struct mm_struct *mm;
> > >  	unsigned long diff;
> > >
> > >  	__ib_umem_release(umem->context->device, umem, 1);
> > >
> > > -	mm = get_task_mm(current);
> > > -	if (!mm) {
> > > +	if (!umem->mm) {
> 
> How can this happen in your flow?

I assume you are asking how could umem->mm be NULL in the context of
this patch?  It is possible for get_task_mm() to return NULL if
PF_KTHREAD is set.  However, I have no idea if that will ever be true
in ib_umem_get().  If it could ever happen this patch is still broken
because I probably shouldn't call mmput(umem->mm) with a NULL mm in
the error case of ib_umem_get().  The current->mm->pinned_vm count
would also be messed up in that case.

Thanks for pointing this out.

> 
> > >  		kfree(umem); return; } @@ -251,20 +251,19 @@ void
> > >  		ib_umem_release(struct ib_umem *umem) * we defer the
> > >  		vm_locked accounting to the system workqueue.  */ if
> > >  		(context->closing) { -		if
> > >  		(!down_write_trylock(&mm->mmap_sem)) { +		if
> > >  		(!down_write_trylock(&umem->mm->mmap_sem)) {
> > >  		INIT_WORK(&umem->work, ib_umem_account); -			umem->mm   =
> > >  		mm; umem->diff = diff;
> > >
> > >  			queue_work(ib_wq, &umem->work); return; } } else -
> > >  			down_write(&mm->mmap_sem); +
> > >  			down_write(&umem->mm->mmap_sem);
> > >
> > > -	current->mm->pinned_vm -= diff; -	up_write(&mm->mmap_sem); -
> > > mmput(mm); +	umem->mm->pinned_vm -= diff; +
> > > up_write(&umem->mm->mmap_sem); +	mmput(umem->mm); kfree(umem);
> > > } EXPORT_SYMBOL(ib_umem_release);
> > 
> > It doesn't look like this has been applied yet.  Does anyone have
> > any feedback?
> 
> See above for comments. 

--
Shawn
