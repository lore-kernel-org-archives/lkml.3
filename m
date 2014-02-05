Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBELMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:12:10 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53002 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaBELMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:12:07 -0500
Message-ID: <52F21C8A.1040405@gmail.com>
Date: Wed, 05 Feb 2014 19:12:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        =?UTF-8?B?SMOldmFy?= =?UTF-8?B?ZCBTa2lubmVtb2Vu?= 
	<hskinnemoen@gmail.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] include/linux/kprobes.h: move all functions to their
 matched area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com> <52F0D7F3.7000901@gmail.com> <52F0EB30.2070401@hitachi.com> <52F0F0ED.5090005@gmail.com> <52F109AF.8040800@hitachi.com> <52F18367.2060803@gmail.com> <52F19223.5010506@hitachi.com> <52F1AB18.5040208@gmail.com> <52F1B1CE.2040204@gmail.com> <52F1C579.1080907@hitachi.com> <52F1CBAB.2070106@gmail.com> <52F1ED6D.6060503@hitachi.com>
In-Reply-To: <52F1ED6D.6060503@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 03:51 PM, Masami Hiramatsu wrote:
> (2014/02/05 14:27), Chen Gang wrote:
>> For dummy functions, it is not a good idea to still use the input
>> parameters (not a good idea to assume they are still effect).
>>
>>  - let kprobe* static inline functions in CONFIG_KPROBES, dummy outside.
>>
>>  - let (en/dis)able_jprobe() in CONFIG_KPROBES, dummy outside.
>>
>>  - for kretprobe:
>>
>>    - let kretprobe_assert() only in CONFIG_KRETPROBES (internal use).
>>
>>    - remove kretprobe_inst_table_head() (cannot grep it in kernel wide).
>>
>>    - for (en/dis)able_kretprobe():
>>
>>        if CONFIG_KRETPROBES enabled, they use (en/dis)able_kprobe().
>>        else if CONFIG_KPROBES enabled, return -EINVAL (not registered).
>>        else, return -ENOSYS, just like (en/dis)able_kprobe() have done.
> 
> NAK. I don't increase complexity in this header file anymore,
> unless we have any actual issue with sane usage.
> 
> Thank you,
> 

OK, I can understand, thanks. :-)


>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  include/linux/kprobes.h | 136 ++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 92 insertions(+), 44 deletions(-)
>>
>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>> index 925eaf2..860313d 100644
>> --- a/include/linux/kprobes.h
>> +++ b/include/linux/kprobes.h
>> @@ -129,30 +129,6 @@ struct kprobe {
>>  				   */
>>  #define KPROBE_FLAG_FTRACE	8 /* probe is using ftrace */
>>  
>> -/* Has this kprobe gone ? */
>> -static inline int kprobe_gone(struct kprobe *p)
>> -{
>> -	return p->flags & KPROBE_FLAG_GONE;
>> -}
>> -
>> -/* Is this kprobe disabled ? */
>> -static inline int kprobe_disabled(struct kprobe *p)
>> -{
>> -	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
>> -}
>> -
>> -/* Is this kprobe really running optimized path ? */
>> -static inline int kprobe_optimized(struct kprobe *p)
>> -{
>> -	return p->flags & KPROBE_FLAG_OPTIMIZED;
>> -}
>> -
>> -/* Is this kprobe uses ftrace ? */
>> -static inline int kprobe_ftrace(struct kprobe *p)
>> -{
>> -	return p->flags & KPROBE_FLAG_FTRACE;
>> -}
>> -
>>  /*
>>   * Special probe type that uses setjmp-longjmp type tricks to resume
>>   * execution at a specified entry with a matching prototype corresponding
>> @@ -223,7 +199,42 @@ static inline int kprobes_built_in(void)
>>  	return 1;
>>  }
>>  
>> +/* Has this kprobe gone ? */
>> +static inline int kprobe_gone(struct kprobe *p)
>> +{
>> +	return p->flags & KPROBE_FLAG_GONE;
>> +}
>> +
>> +/* Is this kprobe disabled ? */
>> +static inline int kprobe_disabled(struct kprobe *p)
>> +{
>> +	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
>> +}
>> +
>> +/* Is this kprobe really running optimized path ? */
>> +static inline int kprobe_optimized(struct kprobe *p)
>> +{
>> +	return p->flags & KPROBE_FLAG_OPTIMIZED;
>> +}
>> +
>> +/* Is this kprobe uses ftrace ? */
>> +static inline int kprobe_ftrace(struct kprobe *p)
>> +{
>> +	return p->flags & KPROBE_FLAG_FTRACE;
>> +}
>> +
>>  #ifdef CONFIG_KRETPROBES
>> +static inline void kretprobe_assert(struct kretprobe_instance *ri,
>> +	unsigned long orig_ret_address, unsigned long trampoline_address)
>> +{
>> +	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>> +		printk(KERN_ERR
>> +			"kretprobe BUG!: Processing kretprobe %p @ %p\n",
>> +			ri->rp, ri->rp->kp.addr);
>> +		BUG();
>> +	}
>> +}
>> +
>>  extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
>>  				   struct pt_regs *regs);
>>  extern int arch_trampoline_kprobe(struct kprobe *p);
>> @@ -240,16 +251,6 @@ static inline int arch_trampoline_kprobe(struct kprobe *p)
>>  
>>  extern struct kretprobe_blackpoint kretprobe_blacklist[];
>>  
>> -static inline void kretprobe_assert(struct kretprobe_instance *ri,
>> -	unsigned long orig_ret_address, unsigned long trampoline_address)
>> -{
>> -	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>> -		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
>> -				ri->rp, ri->rp->kp.addr);
>> -		BUG();
>> -	}
>> -}
>> -
>>  #ifdef CONFIG_KPROBES_SANITY_TEST
>>  extern int init_test_probes(void);
>>  #else
>> @@ -340,7 +341,6 @@ struct kprobe *get_kprobe(void *addr);
>>  void kretprobe_hash_lock(struct task_struct *tsk,
>>  			 struct hlist_head **head, unsigned long *flags);
>>  void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags);
>> -struct hlist_head * kretprobe_inst_table_head(struct task_struct *tsk);
>>  
>>  /* kprobe_running() will just return the current_kprobe on this CPU */
>>  static inline struct kprobe *kprobe_running(void)
>> @@ -384,12 +384,60 @@ int enable_kprobe(struct kprobe *kp);
>>  
>>  void dump_kprobe(struct kprobe *kp);
>>  
>> +static inline int disable_jprobe(struct jprobe *jp)
>> +{
>> +	return disable_kprobe(&jp->kp);
>> +}
>> +
>> +static inline int enable_jprobe(struct jprobe *jp)
>> +{
>> +	return enable_kprobe(&jp->kp);
>> +}
>> +
>> +#ifdef CONFIG_KRETPROBES
>> +static inline int disable_kretprobe(struct kretprobe *rp)
>> +{
>> +	return disable_kprobe(&rp->kp);
>> +}
>> +
>> +static inline int enable_kretprobe(struct kretprobe *rp)
>> +{
>> +	return enable_kprobe(&rp->kp);
>> +}
>> +
>> +#else /* CONFIG_KRETPROBES */
>> +static inline int disable_kretprobe(struct kretprobe *rp)
>> +{
>> +	return -EINVAL;
>> +}
>> +static inline int enable_kretprobe(struct kretprobe *rp)
>> +{
>> +	return -EINVAL;
>> +}
>> +#endif /* CONFIG_KRETPROBES */
>> +
>>  #else /* !CONFIG_KPROBES: */
>>  
>>  static inline int kprobes_built_in(void)
>>  {
>>  	return 0;
>>  }
>> +static inline int kprobe_gone(struct kprobe *p)
>> +{
>> +	return 1;
>> +}
>> +static inline int kprobe_disabled(struct kprobe *p)
>> +{
>> +	return 1;
>> +}
>> +static inline int kprobe_optimized(struct kprobe *p)
>> +{
>> +	return 0;
>> +}
>> +static inline int kprobe_ftrace(struct kprobe *p)
>> +{
>> +	return 0;
>> +}
>>  static inline int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
>>  {
>>  	return 0;
>> @@ -458,22 +506,22 @@ static inline int enable_kprobe(struct kprobe *kp)
>>  {
>>  	return -ENOSYS;
>>  }
>> -#endif /* CONFIG_KPROBES */
>> -static inline int disable_kretprobe(struct kretprobe *rp)
>> +static inline int disable_jprobe(struct jprobe *jp)
>>  {
>> -	return disable_kprobe(&rp->kp);
>> +	return -ENOSYS;
>>  }
>> -static inline int enable_kretprobe(struct kretprobe *rp)
>> +static inline int enable_jprobe(struct jprobe *jp)
>>  {
>> -	return enable_kprobe(&rp->kp);
>> +	return -ENOSYS;
>>  }
>> -static inline int disable_jprobe(struct jprobe *jp)
>> +static inline int disable_kretprobe(struct kretprobe *rp)
>>  {
>> -	return disable_kprobe(&jp->kp);
>> +	return -ENOSYS;
>>  }
>> -static inline int enable_jprobe(struct jprobe *jp)
>> +static inline int enable_kretprobe(struct kretprobe *rp)
>>  {
>> -	return enable_kprobe(&jp->kp);
>> +	return -ENOSYS;
>>  }
>> +#endif /* CONFIG_KPROBES */
>>  
>>  #endif /* _LINUX_KPROBES_H */
>>
> 
> 


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
