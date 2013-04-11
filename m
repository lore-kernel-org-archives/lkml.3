Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001Ab3DKS2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:28:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3DKS2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:28:00 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qg6WopMdFb4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=9DDkZBuB8TwA:10 a=Aqycn9Up6EIUtTcCaKAA:9 a=QEXdDO2ut3YA:10 a=nCxrGPzW89uE90o2:21 a=iCgUIoPbPN6lm6_K:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365704877.9609.56.camel@gandalf.local.home>
Subject: Re: [PATCH RT] x86/mce: Defer mce wakeups to threads for PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 11 Apr 2013 14:27:57 -0400
In-Reply-To: <1365704626.9609.55.camel@gandalf.local.home>
References: <1365704626.9609.55.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 14:23 -0400, Steven Rostedt wrote:

> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index e8d8ad0..060e473 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -18,6 +18,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/kobject.h>
>  #include <linux/uaccess.h>
> +#include <linux/kthread.h>
>  #include <linux/kdebug.h>
>  #include <linux/kernel.h>
>  #include <linux/percpu.h>
> @@ -1308,6 +1309,61 @@ static void mce_do_trigger(struct work_struct *work)
>  
>  static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
>  
> +static void __mce_notify_work(void)
> +{
> +	/* Not more than two messages every minute */
> +	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
> +
> +	/* wake processes polling /dev/mcelog */
> +	wake_up_interruptible(&mce_chrdev_wait);
> +
> +	/*
> +	 * There is no risk of missing notifications because
> +	 * work_pending is always cleared before the function is
> +	 * executed.
> +	 */
> +	if (mce_helper[0] && !work_pending(&mce_trigger_work))
> +		schedule_work(&mce_trigger_work);
> +
> +	if (__ratelimit(&ratelimit))
> +		pr_info(HW_ERR "Machine check events logged\n");
> +}
> +
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +struct task_struct *mce_notify_helper;
> +
> +static int mce_notify_helper_thread(void *unused)
> +{
> +	while (!kthread_should_stop()) {
> +		__mce_notify_work();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule();
> +	}
> +	return 0;
> +}
> +
> +static int mce_notify_work_init(void)
> +{
> +	mce_notify_helper = kthread_create(mce_notify_helper_thread, NULL,
> +					   "mce-notify");
> +	if (!mce_notify_helper)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static void mce_notify_work()
> +{
> +	wake_up_process(mce_notify_helper);
> +}
> +#else
> +static void mce_notify_work(void)
> +{
> +	__mce_notify_work();
> +}
> +static inline int mce_notify_work_init(void) { return 0; }
> +#endif
> +
>  /*
>   * Notify the user(s) about new machine check events.
>   * Can be called from interrupt context, but not from machine check/NMI
> @@ -1315,24 +1371,8 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
>   */
>  int mce_notify_irq(void)
>  {
> -	/* Not more than two messages every minute */
> -	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
> -
>  	if (test_and_clear_bit(0, &mce_need_notify)) {
> -		/* wake processes polling /dev/mcelog */
> -		wake_up_interruptible(&mce_chrdev_wait);
> -
> -		/*
> -		 * There is no risk of missing notifications because
> -		 * work_pending is always cleared before the function is
> -		 * executed.
> -		 */
> -		if (mce_helper[0] && !work_pending(&mce_trigger_work))
> -			schedule_work(&mce_trigger_work);
> -
> -		if (__ratelimit(&ratelimit))
> -			pr_info(HW_ERR "Machine check events logged\n");
> -
> +		mce_notify_work();
>  		return 1;
>  	}
>  	return 0;
> @@ -2375,6 +2415,8 @@ static __init int mcheck_init_device(void)
>  	/* register character device /dev/mcelog */
>  	misc_register(&mce_chrdev_device);
>  
> +	err = mce_notify_work_init();
> +
>  	return err;
>  }


Ignore the below, I didn't realize I had other changes when I did my git
diff to make this patch :-/

-- Steve

>  device_initcall_sync(mcheck_init_device);
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 33e5d14..120c790 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -198,34 +198,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
>  }
>  EXPORT_SYMBOL_GPL(start_thread);
>  
> -#ifdef CONFIG_PREEMPT_RT_FULL
> -static void switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p)
> -{
> -	int i;
> -
> -	/*
> -	 * Clear @prev's kmap_atomic mappings
> -	 */
> -	for (i = 0; i < prev_p->kmap_idx; i++) {
> -		int idx = i + KM_TYPE_NR * smp_processor_id();
> -		pte_t *ptep = kmap_pte - idx;
> -
> -		kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
> -	}
> -	/*
> -	 * Restore @next_p's kmap_atomic mappings
> -	 */
> -	for (i = 0; i < next_p->kmap_idx; i++) {
> -		int idx = i + KM_TYPE_NR * smp_processor_id();
> -
> -		set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
> -	}
> -}
> -#else
> -static inline void
> -switch_kmaps(struct task_struct *prev_p, struct task_struct *next_p) { }
> -#endif
> -
>  
>  /*
>   *	switch_to(x,y) should switch tasks from x to y.
> @@ -305,7 +277,40 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
>  		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
>  		__switch_to_xtra(prev_p, next_p, tss);
>  
> -	switch_kmaps(prev_p, next_p);
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +	/*
> +	 * Save @prev's kmap_atomic stack
> +	 */
> +	prev_p->kmap_idx = __this_cpu_read(__kmap_atomic_idx);
> +	if (unlikely(prev_p->kmap_idx)) {
> +		int i;
> +
> +		for (i = 0; i < prev_p->kmap_idx; i++) {
> +			int idx = i + KM_TYPE_NR * smp_processor_id();
> +
> +			pte_t *ptep = kmap_pte - idx;
> +			prev_p->kmap_pte[i] = *ptep;
> +			kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
> +		}
> +
> +		__this_cpu_write(__kmap_atomic_idx, 0);
> +	}
> +
> +	/*
> +	 * Restore @next_p's kmap_atomic stack
> +	 */
> +	if (unlikely(next_p->kmap_idx)) {
> +		int i;
> +
> +		__this_cpu_write(__kmap_atomic_idx, next_p->kmap_idx);
> +
> +		for (i = 0; i < next_p->kmap_idx; i++) {
> +			int idx = i + KM_TYPE_NR * smp_processor_id();
> +
> +			set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
> +		}
> +	}
> +#endif
>  
>  	/*
>  	 * Leave lazy mode, flushing any hypercalls made here.
> 


