Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaJXMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:50:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:47647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaJXMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:50:05 -0400
Date: Fri, 24 Oct 2014 14:49:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH v9 10/12] x86, mpx: add prctl commands PR_MPX_ENABLE_MANAGEMENT,
 PR_MPX_DISABLE_MANAGEMENT
In-Reply-To: <1413088915-13428-11-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.11.1410241436560.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-11-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014, Qiaowei Ren wrote:
> +int mpx_enable_management(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +	void __user *bd_base = MPX_INVALID_BOUNDS_DIR;

What's the point of initializing bd_base here. I had to look twice to
figure out that it gets overwritten by task_get_bounds_dir()

> @@ -285,6 +285,7 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
>  	struct xsave_struct *xsave_buf;
>  	struct task_struct *tsk = current;
>  	siginfo_t info;
> +	int ret = 0;
>  
>  	prev_state = exception_enter();
>  	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
> @@ -312,8 +313,35 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
>  	 */
>  	switch (status & MPX_BNDSTA_ERROR_CODE) {
>  	case 2: /* Bound directory has invalid entry. */
> -		if (do_mpx_bt_fault(xsave_buf))
> +		down_write(&current->mm->mmap_sem);

The handling of mm->mmap_sem here is horrible. The only reason why you
want to hold mmap_sem write locked in the first place is that you want
to cover the allocation and the mm->bd_addr check.

I think it's wrong to tie this to mmap_sem in the first place. If MPX
is enabled then you should have mm->bd_addr and an explicit mutex to
protect it.

So the logic would look like this:

   mutex_lock(&mm->bd_mutex);
   if (!kernel_managed(mm))
      do_trap();
   else if (do_mpx_bt_fault())
      force_sig();
   mutex_unlock(&mm->bd_mutex);
   
No tricks with mmap_sem, no special return value handling. Straight
forward code instead of a convoluted and error prone mess.

Hmm?

Thanks,

	tglx
