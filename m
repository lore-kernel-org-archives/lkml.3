Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIPHAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:00:47 -0400
Received: from chicago.guarana.org ([198.144.183.183]:44856 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaIPHAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:00:46 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 03:00:46 EDT
Date: Tue, 16 Sep 2014 17:50:07 +1000
From: Kevin Easton <kevin@guarana.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Message-ID: <20140916075007.GA22076@chicago.guarana.org>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:46:48PM +0800, Qiaowei Ren wrote:

> +static __user void *task_get_bounds_dir(struct task_struct *tsk)
> +{
> +	struct xsave_struct *xsave_buf;
> +
> +	fpu_xsave(&tsk->thread.fpu);
> +	xsave_buf = &(tsk->thread.fpu.state->xsave);
> +	if (!(xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ENABLE_FLAG))
> +		return NULL;
> +
> +	return (void __user *)(unsigned long)(xsave_buf->bndcsr.cfg_reg_u &
> +			MPX_BNDCFG_ADDR_MASK);
> +}

This only makes sense if called with 'current', so is there any need
for the function argument?

> +
> +int mpx_register(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +
> +	if (!cpu_has_mpx)
> +		return -EINVAL;
> +
> +	/*
> +	 * runtime in the userspace will be responsible for allocation of
> +	 * the bounds directory. Then, it will save the base of the bounds
> +	 * directory into XSAVE/XRSTOR Save Area and enable MPX through
> +	 * XRSTOR instruction.
> +	 *
> +	 * fpu_xsave() is expected to be very expensive. In order to do
> +	 * performance optimization, here we get the base of the bounds
> +	 * directory and then save it into mm_struct to be used in future.
> +	 */
> +	mm->bd_addr = task_get_bounds_dir(tsk);
> +	if (!mm->bd_addr)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int mpx_unregister(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = current->mm;
> +
> +	if (!cpu_has_mpx)
> +		return -EINVAL;
> +
> +	mm->bd_addr = NULL;
> +	return 0;
> +}

If that's changed, then mpx_register() and mpx_unregister() don't need
a task_struct, just an mm_struct.

Probably these functions should be locking mmap_sem.

Would it be prudent to use an error code other than EINVAL for the 
"hardware doesn't support it" case?

> @@ -2011,6 +2017,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			me->mm->def_flags &= ~VM_NOHUGEPAGE;
>  		up_write(&me->mm->mmap_sem);
>  		break;
> +	case PR_MPX_REGISTER:
> +		error = MPX_REGISTER(me);
> +		break;
> +	case PR_MPX_UNREGISTER:
> +		error = MPX_UNREGISTER(me);
> +		break;

If you pass me->mm from prctl, that makes it clear that it's per-process
not per-thread, just like PR_SET_DUMPABLE / PR_GET_DUMPABLE.

This code should also enforce nulls in arg2 / arg3 / arg4,/ arg5 if it's
not using them, otherwise you'll be sunk if you ever want to use them later.

It seems like it only makes sense for all threads using the mm to have the
same bounds directory set.  If the interface was changed to directly pass
the address, then could the kernel take care of setting it for *all* of
the threads in the process? This seems like something that would be easier
for the kernel to do than userspace.

    - Kevin
