Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaIOP2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:28:14 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34550 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaIOP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:28:09 -0400
Date: Mon, 15 Sep 2014 10:28:00 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomk@rgmadvisors.com, Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Christoph Lameter <cl@linux.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH v3] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Message-ID: <20140915152800.GA8941@sbohrermbp13-local.rgmadvisors.com>
References: <6B2A6E60C06CCC42AE31809BF572352B010E240634@MTLDAG02.mtl.com>
 <1409764437-29699-1-git-send-email-shawn.bohrer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409764437-29699-1-git-send-email-shawn.bohrer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 12:13:57PM -0500, Shawn Bohrer wrote:
> From: Shawn Bohrer <sbohrer@rgmadvisors.com>
> 
> In debugging an application that receives -ENOMEM from ib_reg_mr() I
> found that ib_umem_get() can fail because the pinned_vm count has
> wrapped causing it to always be larger than the lock limit even with
> RLIMIT_MEMLOCK set to RLIM_INFINITY.
> 
> The wrapping of pinned_vm occurs because the process that calls
> ib_reg_mr() will have its mm->pinned_vm count incremented.  Later a
> different process with a different mm_struct than the one that allocated
> the ib_umem struct ends up releasing it which results in decrementing
> the new processes mm->pinned_vm count past zero and wrapping.
> 
> I'm not entirely sure what circumstances cause a different process to
> release the ib_umem than the one that allocated it but the kernel stack
> trace of the freeing process from my situation looks like the following:
> 
> Call Trace:
>  [<ffffffff814d64b1>] dump_stack+0x19/0x1b
>  [<ffffffffa0b522a5>] ib_umem_release+0x1f5/0x200 [ib_core]
>  [<ffffffffa0b90681>] mlx4_ib_destroy_qp+0x241/0x440 [mlx4_ib]
>  [<ffffffffa0b4d93c>] ib_destroy_qp+0x12c/0x170 [ib_core]
>  [<ffffffffa0cc7129>] ib_uverbs_close+0x259/0x4e0 [ib_uverbs]
>  [<ffffffff81141cba>] __fput+0xba/0x240
>  [<ffffffff81141e4e>] ____fput+0xe/0x10
>  [<ffffffff81060894>] task_work_run+0xc4/0xe0
>  [<ffffffff810029e5>] do_notify_resume+0x95/0xa0
>  [<ffffffff814e3dd0>] int_signal+0x12/0x17
> 
> The following patch fixes the issue by storing the pid struct of the
> process that calls ib_umem_get() so that ib_umem_release and/or
> ib_umem_account() can properly decrement the pinned_vm count of the
> correct mm_struct.
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> ---
> v3 changes:
> * Fix resource leak with put_task_struct()
> v2 changes:
> * Updated to use get_task_pid to avoid keeping a reference to the mm
> 
>  drivers/infiniband/core/umem.c |   19 +++++++++++++------
>  include/rdma/ib_umem.h         |    1 +
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a3a2e9c..df0c4f6 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -105,6 +105,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  	umem->length    = size;
>  	umem->offset    = addr & ~PAGE_MASK;
>  	umem->page_size = PAGE_SIZE;
> +	umem->pid       = get_task_pid(current, PIDTYPE_PID);
>  	/*
>  	 * We ask for writable memory if any access flags other than
>  	 * "remote read" are set.  "Local write" and "remote write"
> @@ -198,6 +199,7 @@ out:
>  	if (ret < 0) {
>  		if (need_release)
>  			__ib_umem_release(context->device, umem, 0);
> +		put_pid(umem->pid);
>  		kfree(umem);
>  	} else
>  		current->mm->pinned_vm = locked;
> @@ -230,15 +232,19 @@ void ib_umem_release(struct ib_umem *umem)
>  {
>  	struct ib_ucontext *context = umem->context;
>  	struct mm_struct *mm;
> +	struct task_struct *task;
>  	unsigned long diff;
>  
>  	__ib_umem_release(umem->context->device, umem, 1);
>  
> -	mm = get_task_mm(current);
> -	if (!mm) {
> -		kfree(umem);
> -		return;
> -	}
> +	task = get_pid_task(umem->pid, PIDTYPE_PID);
> +	put_pid(umem->pid);
> +	if (!task)
> +		goto out;
> +	mm = get_task_mm(task);
> +	put_task_struct(task);
> +	if (!mm)
> +		goto out;
>  
>  	diff = PAGE_ALIGN(umem->length + umem->offset) >> PAGE_SHIFT;
>  
> @@ -262,9 +268,10 @@ void ib_umem_release(struct ib_umem *umem)
>  	} else
>  		down_write(&mm->mmap_sem);
>  
> -	current->mm->pinned_vm -= diff;
> +	mm->pinned_vm -= diff;
>  	up_write(&mm->mmap_sem);
>  	mmput(mm);
> +out:
>  	kfree(umem);
>  }
>  EXPORT_SYMBOL(ib_umem_release);
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index 1ea0b65..a2bf41e 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -47,6 +47,7 @@ struct ib_umem {
>  	int                     writable;
>  	int                     hugetlb;
>  	struct work_struct	work;
> +	struct pid             *pid;
>  	struct mm_struct       *mm;
>  	unsigned long		diff;
>  	struct sg_table sg_head;
> -- 
> 1.7.7.6

Hi Roland,

I haven't seen any additional review feedback, and it doesn't appear
that this patch has made its way into any of your infiniband trees
yet.  Is there anything holding this up?

We've been running this patch on top of 3.10 since I originally sent
this and have not encountered any issues so far.

--
Shawn
 
