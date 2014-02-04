Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaBDMHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:07:16 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52428 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:07:14 -0500
Message-ID: <52F0D7F3.7000901@gmail.com>
Date: Tue, 04 Feb 2014 20:07:15 +0800
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
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] kernel: kprobe: move all *kretprobe* generic implementation
 to CONFIG_KRETPROBES enabled area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com>
In-Reply-To: <52F09404.3060502@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 03:17 PM, Masami Hiramatsu wrote:
> (2014/02/04 14:16), Chen Gang wrote:
>> When CONFIG_KRETPROBES disabled, all *kretprobe* generic implementation
>> are useless, so need move them to CONFIG_KPROBES enabled area.
>>
>> Now, *kretprobe* generic implementation are all implemented in 2 files:
>>
>>  - in "include/linux/kprobes.h":
>>
>>      move inline kretprobe*() to CONFIG_KPROBES area and dummy outside.
>>      move some *kprobe() declarations which kretprobe*() call, to front.
>>      not touch kretprobe_blacklist[] which is architecture's variable.
>>
>>  - in "kernel/kprobes.c":
>>
>>      move all kretprobe* to CONFIG_KPROBES area and dummy outside.
>>      define kretprobe_flush_task() to let kprobe_flush_task() call.
>>      define init_kretprobes() to let init_kprobes() call.
>>
>> The patch passes compiling (get "kernel/kprobes.o" and "kernel/built-
>> in.o") under avr32 and x86_64 allmodconfig, and passes building (get
>> bzImage and Modpost modules) under x86_64 defconfig.
>
> Thanks for the fix! and I have some comments below.
>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  include/linux/kprobes.h |  58 +++++----
>>  kernel/kprobes.c        | 328 +++++++++++++++++++++++++++---------------------
>>  2 files changed, 222 insertions(+), 164 deletions(-)
>>
>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>> index 925eaf2..c0d1212 100644
>> --- a/include/linux/kprobes.h
>> +++ b/include/linux/kprobes.h
>> @@ -223,10 +223,36 @@ static inline int kprobes_built_in(void)
>>   return 1;
>>  }
>>  
>> +int disable_kprobe(struct kprobe *kp);
>> +int enable_kprobe(struct kprobe *kp);
>> +
>> +void dump_kprobe(struct kprobe *kp);
>> +
>> +extern struct kretprobe_blackpoint kretprobe_blacklist[];
>> +
>>  #ifdef CONFIG_KRETPROBES
>>  extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
>>     struct pt_regs *regs);
>>  extern int arch_trampoline_kprobe(struct kprobe *p);
>> +static inline void kretprobe_assert(struct kretprobe_instance *ri,
>> + unsigned long orig_ret_address, unsigned long trampoline_address)
>> +{
>> + if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>> + printk(KERN_ERR
>> + "kretprobe BUG!: Processing kretprobe %p @ %p\n",
>> + ri->rp, ri->rp->kp.addr);
>> + BUG();
>> + }
>> +}
>> +static inline int disable_kretprobe(struct kretprobe *rp)
>> +{
>> + return disable_kprobe(&rp->kp);
>> +}
>> +static inline int enable_kretprobe(struct kretprobe *rp)
>> +{
>> + return enable_kprobe(&rp->kp);
>> +}
>> +
>>  #else /* CONFIG_KRETPROBES */
>>  static inline void arch_prepare_kretprobe(struct kretprobe *rp,
>>   struct pt_regs *regs)
>> @@ -236,19 +262,20 @@ static inline int arch_trampoline_kprobe(struct kprobe *p)
>>  {
>>   return 0;
>>  }
>> -#endif /* CONFIG_KRETPROBES */
>> -
>> -extern struct kretprobe_blackpoint kretprobe_blacklist[];
>> -
>>  static inline void kretprobe_assert(struct kretprobe_instance *ri,
>>   unsigned long orig_ret_address, unsigned long trampoline_address)
>>  {
>> - if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>> - printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
>> - ri->rp, ri->rp->kp.addr);
>> - BUG();
>> - }
>>  }
>> +static inline int disable_kretprobe(struct kretprobe *rp)
>> +{
>> + return 0;
>> +}
>> +static inline int enable_kretprobe(struct kretprobe *rp)
>> +{
>> + return 0;
>> +}
>
> No, these should returns -EINVAL or -ENOSYS, since these are user API.

OK, thanks, it sounds reasonable to me.

> Anyway, I don't think those inlined functions to be changed, because
> most of them are internal functions. If CONFIG_KRETPROBES=n, it just
> be ignored.
>

In original implementation, if CONFIG_KRETPROBES=n, kretprobe_assert(),
disable_kretprobe(), and enable_kretprobe() are not ignored.

> So, I think you don't need to change kprobes.h.
>

So "kprobes.h" still need be changed.

>> +
>> +#endif /* CONFIG_KRETPROBES */
>>  
>>  #ifdef CONFIG_KPROBES_SANITY_TEST
>>  extern int init_test_probes(void);
>> @@ -379,11 +406,6 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
>>  void kprobe_flush_task(struct task_struct *tk);
>>  void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>>  
>> -int disable_kprobe(struct kprobe *kp);
>> -int enable_kprobe(struct kprobe *kp);
>> -
>> -void dump_kprobe(struct kprobe *kp);
>> -
>>  #else /* !CONFIG_KPROBES: */
>>  
>>  static inline int kprobes_built_in(void)
>> @@ -459,14 +481,6 @@ static inline int enable_kprobe(struct kprobe *kp)
>>   return -ENOSYS;
>>  }
>>  #endif /* CONFIG_KPROBES */
>> -static inline int disable_kretprobe(struct kretprobe *rp)
>> -{
>> - return disable_kprobe(&rp->kp);
>> -}
>> -static inline int enable_kretprobe(struct kretprobe *rp)
>> -{
>> - return enable_kprobe(&rp->kp);
>> -}
>>  static inline int disable_jprobe(struct jprobe *jp)
>>  {
>>   return disable_kprobe(&jp->kp);
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index ceeadfc..e305a81 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
> [...]
>> @@ -1936,8 +1955,44 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
>>   return 0;
>>  }
>>  
>> +void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
>> + struct hlist_head *head)
>> +{
>> +}
>> +
>> +void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
>> + struct hlist_head **head, unsigned long *flags)
>> +__acquires(hlist_lock)
>> +{
>> +}
>> +
>> +void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
>> + unsigned long *flags)
>> +__releases(hlist_lock)
>> +{
>> +}
>> +
>
>> +static void __kprobes kretprobe_flush_task(struct task_struct *tk)
>> +{
>> +}
>> +
>> +static void __init init_kretprobes(void)
>> +{
>> +}
>
> These should be macros, as I did for optprobe functions
> with !CONFIG_OPTPROBES.
>

OK, thanks, it sounds reasonable to me.

 - For new added static functions: kretprobe_flush_task(), and
   init_kretprobes() need be changed to macros

 - For extern functions: recycle_rp_inst(), kretprobe_hash_lock(), and
   kretprobe_has_unlock(), need use dummy functions.

 - For original static function: pre_handler_kretprobe(), need still
   use dummy function (for function pointer comparing).


> Other parts looks good to me!;)
>
> Thank you!
>
>

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
