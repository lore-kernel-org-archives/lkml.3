Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaBDNyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:54:18 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61394 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:54:15 -0500
Message-ID: <52F0F0ED.5090005@gmail.com>
Date: Tue, 04 Feb 2014 21:53:49 +0800
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
Subject: Re: [PATCH] kernel: kprobe: move all *kretprobe* generic implementation
 to CONFIG_KRETPROBES enabled area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com> <52F0D7F3.7000901@gmail.com> <52F0EB30.2070401@hitachi.com>
In-Reply-To: <52F0EB30.2070401@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 09:29 PM, Masami Hiramatsu wrote:
> (2014/02/04 21:07), Chen Gang wrote:
>> On 02/04/2014 03:17 PM, Masami Hiramatsu wrote:
>>> (2014/02/04 14:16), Chen Gang wrote:
>>>> When CONFIG_KRETPROBES disabled, all *kretprobe* generic implementation
>>>> are useless, so need move them to CONFIG_KPROBES enabled area.
>>>>
>>>> Now, *kretprobe* generic implementation are all implemented in 2 files:
>>>>
>>>>  - in "include/linux/kprobes.h":
>>>>
>>>>      move inline kretprobe*() to CONFIG_KPROBES area and dummy outside.
>>>>      move some *kprobe() declarations which kretprobe*() call, to front.
>>>>      not touch kretprobe_blacklist[] which is architecture's variable.
>>>>
>>>>  - in "kernel/kprobes.c":
>>>>
>>>>      move all kretprobe* to CONFIG_KPROBES area and dummy outside.
>>>>      define kretprobe_flush_task() to let kprobe_flush_task() call.
>>>>      define init_kretprobes() to let init_kprobes() call.
>>>>
>>>> The patch passes compiling (get "kernel/kprobes.o" and "kernel/built-
>>>> in.o") under avr32 and x86_64 allmodconfig, and passes building (get
>>>> bzImage and Modpost modules) under x86_64 defconfig.
>>>
>>> Thanks for the fix! and I have some comments below.
>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>> ---
>>>>  include/linux/kprobes.h |  58 +++++----
>>>>  kernel/kprobes.c        | 328 +++++++++++++++++++++++++++---------------------
>>>>  2 files changed, 222 insertions(+), 164 deletions(-)
>>>>
>>>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>>>> index 925eaf2..c0d1212 100644
>>>> --- a/include/linux/kprobes.h
>>>> +++ b/include/linux/kprobes.h
>>>> @@ -223,10 +223,36 @@ static inline int kprobes_built_in(void)
>>>>   return 1;
>>>>  }
>>>>  
>>>> +int disable_kprobe(struct kprobe *kp);
>>>> +int enable_kprobe(struct kprobe *kp);
>>>> +
>>>> +void dump_kprobe(struct kprobe *kp);
>>>> +
>>>> +extern struct kretprobe_blackpoint kretprobe_blacklist[];
>>>> +
>>>>  #ifdef CONFIG_KRETPROBES
>>>>  extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
>>>>     struct pt_regs *regs);
>>>>  extern int arch_trampoline_kprobe(struct kprobe *p);
>>>> +static inline void kretprobe_assert(struct kretprobe_instance *ri,
>>>> + unsigned long orig_ret_address, unsigned long trampoline_address)
>>>> +{
>>>> + if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>>>> + printk(KERN_ERR
>>>> + "kretprobe BUG!: Processing kretprobe %p @ %p\n",
>>>> + ri->rp, ri->rp->kp.addr);
>>>> + BUG();
>>>> + }
>>>> +}
>>>> +static inline int disable_kretprobe(struct kretprobe *rp)
>>>> +{
>>>> + return disable_kprobe(&rp->kp);
>>>> +}
>>>> +static inline int enable_kretprobe(struct kretprobe *rp)
>>>> +{
>>>> + return enable_kprobe(&rp->kp);
>>>> +}
>>>> +
>>>>  #else /* CONFIG_KRETPROBES */
>>>>  static inline void arch_prepare_kretprobe(struct kretprobe *rp,
>>>>   struct pt_regs *regs)
>>>> @@ -236,19 +262,20 @@ static inline int arch_trampoline_kprobe(struct kprobe *p)
>>>>  {
>>>>   return 0;
>>>>  }
>>>> -#endif /* CONFIG_KRETPROBES */
>>>> -
>>>> -extern struct kretprobe_blackpoint kretprobe_blacklist[];
>>>> -
>>>>  static inline void kretprobe_assert(struct kretprobe_instance *ri,
>>>>   unsigned long orig_ret_address, unsigned long trampoline_address)
>>>>  {
>>>> - if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>>>> - printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
>>>> - ri->rp, ri->rp->kp.addr);
>>>> - BUG();
>>>> - }
>>>>  }
>>>> +static inline int disable_kretprobe(struct kretprobe *rp)
>>>> +{
>>>> + return 0;
>>>> +}
>>>> +static inline int enable_kretprobe(struct kretprobe *rp)
>>>> +{
>>>> + return 0;
>>>> +}
>>>
>>> No, these should returns -EINVAL or -ENOSYS, since these are user API.
>>
>> OK, thanks, it sounds reasonable to me.
>>
>>> Anyway, I don't think those inlined functions to be changed, because
>>> most of them are internal functions. If CONFIG_KRETPROBES=n, it just
>>> be ignored.
>>>
>>
>> In original implementation, if CONFIG_KRETPROBES=n, kretprobe_assert(),
>> disable_kretprobe(), and enable_kretprobe() are not ignored.
> 
> Really? where are they called? I mean, those functions do not have
> any instance unless your module uses it (but that is not what the kernel
> itself should help).
> 

If what you said correct (I guess so), for me, we still need let them in
CONFIG_KRETPROBES area, and without any dummy outside, just like another
*kprobe* static inline functions have done in "include/linux/kprobes.h".


>>
>>> So, I think you don't need to change kprobes.h.
>>>
>>
>> So "kprobes.h" still need be changed.
> 
> Is there any concrete problem you have?
> 

No, I just read the code, no additional really issues.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
