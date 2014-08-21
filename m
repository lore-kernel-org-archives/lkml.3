Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaHUL2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:28:21 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:60735 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbaHUL2T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:28:19 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 07:28:18 EDT
From: Shachar Raindel <raindel@mellanox.com>
To: Shawn Bohrer <shawn.bohrer@gmail.com>, Roland Dreier <roland@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Sean Hefty <sean.hefty@intel.com>,
        "Hal Rosenstock" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomk@rgmadvisors.com" <tomk@rgmadvisors.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: RE: [PATCH] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Thread-Topic: [PATCH] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Thread-Index: AQHPtkqmMFbPq/FWKEyiW/HW85VFmJvZ/EQAgADzgOA=
Date: Thu, 21 Aug 2014 11:20:34 +0000
Deferred-Delivery: Thu, 21 Aug 2014 11:20:00 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B010E235B4A@MTLDAG02.mtl.com>
References: <1407860855-6564-1-git-send-email-shawn.bohrer@gmail.com>
 <20140820232212.GA5487@sbohrermbp13-local.rgmadvisors.com>
In-Reply-To: <20140820232212.GA5487@sbohrermbp13-local.rgmadvisors.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.13.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm afraid this patch, in its current form, will not work.
See below for additional comments.

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Shawn Bohrer
> Sent: Thursday, August 21, 2014 2:23 AM
> To: Roland Dreier
> Cc: Christoph Lameter; Sean Hefty; Hal Rosenstock; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org;
> tomk@rgmadvisors.com; Shawn Bohrer
> Subject: Re: [PATCH] ib_umem_release should decrement mm->pinned_vm
> from ib_umem_get
> 
> On Tue, Aug 12, 2014 at 11:27:35AM -0500, Shawn Bohrer wrote:
> > From: Shawn Bohrer <sbohrer@rgmadvisors.com>
> >
> > In debugging an application that receives -ENOMEM from ib_reg_mr() I
> > found that ib_umem_get() can fail because the pinned_vm count has
> > wrapped causing it to always be larger than the lock limit even with
> > RLIMIT_MEMLOCK set to RLIM_INFINITY.
> >
> > The wrapping of pinned_vm occurs because the process that calls
> > ib_reg_mr() will have its mm->pinned_vm count incremented.  Later a
> > different process with a different mm_struct than the one that allocated
> > the ib_umem struct ends up releasing it which results in decrementing
> > the new processes mm->pinned_vm count past zero and wrapping.
> >
> > I'm not entirely sure what circumstances cause a different process to
> > release the ib_umem than the one that allocated it but the kernel stack
> > trace of the freeing process from my situation looks like the following:
> >
> > Call Trace:
> >  [<ffffffff814d64b1>] dump_stack+0x19/0x1b
> >  [<ffffffffa0b522a5>] ib_umem_release+0x1f5/0x200 [ib_core]
> >  [<ffffffffa0b90681>] mlx4_ib_destroy_qp+0x241/0x440 [mlx4_ib]
> >  [<ffffffffa0b4d93c>] ib_destroy_qp+0x12c/0x170 [ib_core]
> >  [<ffffffffa0cc7129>] ib_uverbs_close+0x259/0x4e0 [ib_uverbs]
> >  [<ffffffff81141cba>] __fput+0xba/0x240
> >  [<ffffffff81141e4e>] ____fput+0xe/0x10
> >  [<ffffffff81060894>] task_work_run+0xc4/0xe0
> >  [<ffffffff810029e5>] do_notify_resume+0x95/0xa0
> >  [<ffffffff814e3dd0>] int_signal+0x12/0x17
> >

Can you provide the details of this issue - kernel version, reproduction steps, etc.?
It seems like the kernel code flow which triggers this is delaying the FD release done at http://lxr.free-electrons.com/source/fs/file_table.c#L279 .
 The code there seems to have changed (starting at kernel 3.6) to avoid releasing a file in interrupt context or from a kernel thread.
 How are we ending up with releasing the uverbs device file from an interrupt context or a kernel thread?

> > The following patch fixes the issue by storing the mm_struct of the

You are doing more than just storing the mm_struct - you are taking a reference to the process' mm.
This can lead to a massive resource leakage. The reason is bit complex:
The destruction flow for IB uverbs is based upon releasing the file handle for it. Once the file handle is released, all MRs, QPs, CQs, PDs, etc. that the process allocated are released.
For the kernel to release the file handle, the kernel reference count to it needs to reach zero.
Most IB implementations expose some hardware registers to the application by allowing it to mmap the uverbs device file.
This mmap takes a reference to uverbs device file handle that the application opened. This reference is dropped when the process mm is released during the process destruction.
Your code takes a reference to the mm that will only be released when the parent MR/QP is released.

Now, we have a deadlock - the mm is waiting for the MR to be destroyed, the MR is waiting for the file handle to be destroyed, and the file handle is waiting for the mm to be destroyed.

The proper solution is to keep a reference to the task_pid (using get_task_pid), and use this pid to get the task_struct and from it the mm_struct during the destruction flow.


> > process that calls ib_umem_get() so that ib_umem_release and/or
> > ib_umem_account() can properly decrement the pinned_vm count of the
> > correct mm_struct.
> >
> > Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> > ---
> >  drivers/infiniband/core/umem.c |   17 ++++++++---------
> >  1 files changed, 8 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/umem.c
> b/drivers/infiniband/core/umem.c
> > index a3a2e9c..32699024 100644
> > --- a/drivers/infiniband/core/umem.c
> > +++ b/drivers/infiniband/core/umem.c
> > @@ -105,6 +105,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext
> *context, unsigned long addr,
> >  	umem->length    = size;
> >  	umem->offset    = addr & ~PAGE_MASK;
> >  	umem->page_size = PAGE_SIZE;
> > +	umem->mm        = get_task_mm(current);

This takes a reference to the current task mm. This will break the freeing up flows.

> >  	/*
> >  	 * We ask for writable memory if any access flags other than
> >  	 * "remote read" are set.  "Local write" and "remote write"
> > @@ -198,6 +199,7 @@ out:
> >  	if (ret < 0) {
> >  		if (need_release)
> >  			__ib_umem_release(context->device, umem, 0);
> > +		mmput(umem->mm);
> >  		kfree(umem);
> >  	} else
> >  		current->mm->pinned_vm = locked;
> > @@ -229,13 +231,11 @@ static void ib_umem_account(struct work_struct
> *work)
> >  void ib_umem_release(struct ib_umem *umem)
> >  {
> >  	struct ib_ucontext *context = umem->context;
> > -	struct mm_struct *mm;
> >  	unsigned long diff;
> >
> >  	__ib_umem_release(umem->context->device, umem, 1);
> >
> > -	mm = get_task_mm(current);
> > -	if (!mm) {
> > +	if (!umem->mm) {

How can this happen in your flow?

> >  		kfree(umem);
> >  		return;
> >  	}
> > @@ -251,20 +251,19 @@ void ib_umem_release(struct ib_umem *umem)
> >  	 * we defer the vm_locked accounting to the system workqueue.
> >  	 */
> >  	if (context->closing) {
> > -		if (!down_write_trylock(&mm->mmap_sem)) {
> > +		if (!down_write_trylock(&umem->mm->mmap_sem)) {
> >  			INIT_WORK(&umem->work, ib_umem_account);
> > -			umem->mm   = mm;
> >  			umem->diff = diff;
> >
> >  			queue_work(ib_wq, &umem->work);
> >  			return;
> >  		}
> >  	} else
> > -		down_write(&mm->mmap_sem);
> > +		down_write(&umem->mm->mmap_sem);
> >
> > -	current->mm->pinned_vm -= diff;
> > -	up_write(&mm->mmap_sem);
> > -	mmput(mm);
> > +	umem->mm->pinned_vm -= diff;
> > +	up_write(&umem->mm->mmap_sem);
> > +	mmput(umem->mm);
> >  	kfree(umem);
> >  }
> >  EXPORT_SYMBOL(ib_umem_release);
> 
> It doesn't look like this has been applied yet.  Does anyone have any
> feedback?

See above for comments. 
