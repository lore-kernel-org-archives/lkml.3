Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaHaLZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:25:31 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:57317 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaHaLZ2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:25:28 -0400
From: Shachar Raindel <raindel@mellanox.com>
To: Shawn Bohrer <shawn.bohrer@gmail.com>, Roland Dreier <roland@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Sean Hefty <sean.hefty@intel.com>,
        "Hal Rosenstock" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomk@rgmadvisors.com" <tomk@rgmadvisors.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: RE: [PATCH v2] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Thread-Topic: [PATCH v2] ib_umem_release should decrement mm->pinned_vm from
 ib_umem_get
Thread-Index: AQHPwwixwMyDMmKmRUWO6KR3TGdSFpvqlcZQ
Date: Sun, 31 Aug 2014 11:25:09 +0000
Deferred-Delivery: Sun, 31 Aug 2014 11:25:00 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B010E240634@MTLDAG02.mtl.com>
References: <1409261991-11533-1-git-send-email-shawn.bohrer@gmail.com>
In-Reply-To: <1409261991-11533-1-git-send-email-shawn.bohrer@gmail.com>
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

Generally speaking, code now looks better.

However, I think you have a resource leak in your code. See below.

Thanks,
--Shachar

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Shawn Bohrer
> Sent: Friday, August 29, 2014 12:41 AM
> To: Roland Dreier
> Cc: Christoph Lameter; Sean Hefty; Hal Rosenstock; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org;
> tomk@rgmadvisors.com; Yishai Hadas; Or Gerlitz; Haggai Eran; Shawn Bohrer
> Subject: [PATCH v2] ib_umem_release should decrement mm->pinned_vm
> from ib_umem_get
> 
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
> 
> v2 changes:
> * Updated to use get_task_pid to avoid keeping a reference to the mm
> 
> I've run this patch on our test pool for general testing for a few days
> and today verified that it solves the reported issue above on our
> production machines.
> 
> 
>  drivers/infiniband/core/umem.c |   18 ++++++++++++------
>  include/rdma/ib_umem.h         |    1 +
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c
> b/drivers/infiniband/core/umem.c
> index a3a2e9c..01750d6 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -105,6 +105,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext
> *context, unsigned long addr,
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
> @@ -230,15 +232,18 @@ void ib_umem_release(struct ib_umem *umem)
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
> +	if (!mm)
> +		goto out;
> 

I think you are leaking task structs here. You need a put_task (task) once you got an mm (or failed to get one)

>  	diff = PAGE_ALIGN(umem->length + umem->offset) >>
> PAGE_SHIFT;
> 
> @@ -262,9 +267,10 @@ void ib_umem_release(struct ib_umem *umem)
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
