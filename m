Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaBEDIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 22:08:09 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39183 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaBEDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 22:08:08 -0500
Message-ID: <52F1AB18.5040208@gmail.com>
Date: Wed, 05 Feb 2014 11:08:08 +0800
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
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com> <52F0D7F3.7000901@gmail.com> <52F0EB30.2070401@hitachi.com> <52F0F0ED.5090005@gmail.com> <52F109AF.8040800@hitachi.com> <52F18367.2060803@gmail.com> <52F19223.5010506@hitachi.com>
In-Reply-To: <52F19223.5010506@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 09:21 AM, Masami Hiramatsu wrote:
> (2014/02/05 9:18), Chen Gang wrote:
>> On 02/04/2014 11:39 PM, Masami Hiramatsu wrote:
>>> (2014/02/04 22:53), Chen Gang wrote:
>>>> On 02/04/2014 09:29 PM, Masami Hiramatsu wrote:
>>>>> (2014/02/04 21:07), Chen Gang wrote:
>>>>>> On 02/04/2014 03:17 PM, Masami Hiramatsu wrote:
>>>>>>> (2014/02/04 14:16), Chen Gang wrote:
>>>>>>>> When CONFIG_KRETPROBES disabled, all *kretprobe* generic implementation
>>>>>>>> are useless, so need move them to CONFIG_KPROBES enabled area.
>>>>>>>>
>>>>>>>> Now, *kretprobe* generic implementation are all implemented in 2 files:
>>>>>>>>
>>>>>>>>  - in "include/linux/kprobes.h":
>>>>>>>>
>>>>>>>>      move inline kretprobe*() to CONFIG_KPROBES area and dummy outside.
>>>>>>>>      move some *kprobe() declarations which kretprobe*() call, to front.
>>>>>>>>      not touch kretprobe_blacklist[] which is architecture's variable.
>>>>>>>>
>>>>>>>>  - in "kernel/kprobes.c":
>>>>>>>>
>>>>>>>>      move all kretprobe* to CONFIG_KPROBES area and dummy outside.
>>>>>>>>      define kretprobe_flush_task() to let kprobe_flush_task() call.
>>>>>>>>      define init_kretprobes() to let init_kprobes() call.
>>>>>>>>
>>>>>>>> The patch passes compiling (get "kernel/kprobes.o" and "kernel/built-
>>>>>>>> in.o") under avr32 and x86_64 allmodconfig, and passes building (get
>>>>>>>> bzImage and Modpost modules) under x86_64 defconfig.
>>>>>>>
>>>>>>> Thanks for the fix! and I have some comments below.
>>>>>>>
>>>>>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>>>>>> ---
>>>>>>>>  include/linux/kprobes.h |  58 +++++----
>>>>>>>>  kernel/kprobes.c        | 328 +++++++++++++++++++++++++++---------------------
>>>>>>>>  2 files changed, 222 insertions(+), 164 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>>>>>>>> index 925eaf2..c0d1212 100644
>>>>>>>> --- a/include/linux/kprobes.h
>>>>>>>> +++ b/include/linux/kprobes.h
>>>>>>>> @@ -223,10 +223,36 @@ static inline int kprobes_built_in(void)
>>>>>>>>   return 1;
>>>>>>>>  }
>>>>>>>>  
>>>>>>>> +int disable_kprobe(struct kprobe *kp);
>>>>>>>> +int enable_kprobe(struct kprobe *kp);
>>>>>>>> +
>>>>>>>> +void dump_kprobe(struct kprobe *kp);
>>>>>>>> +
>>>>>>>> +extern struct kretprobe_blackpoint kretprobe_blacklist[];
>>>>>>>> +
>>>>>>>>  #ifdef CONFIG_KRETPROBES
>>>>>>>>  extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
>>>>>>>>     struct pt_regs *regs);
>>>>>>>>  extern int arch_trampoline_kprobe(struct kprobe *p);
>>>>>>>> +static inline void kretprobe_assert(struct kretprobe_instance *ri,
>>>>>>>> + unsigned long orig_ret_address, unsigned long trampoline_address)
>>>>>>>> +{
>>>>>>>> + if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>>>>>>>> + printk(KERN_ERR
>>>>>>>> + "kretprobe BUG!: Processing kretprobe %p @ %p\n",
>>>>>>>> + ri->rp, ri->rp->kp.addr);
>>>>>>>> + BUG();
>>>>>>>> + }
>>>>>>>> +}
>>>>>>>> +static inline int disable_kretprobe(struct kretprobe *rp)
>>>>>>>> +{
>>>>>>>> + return disable_kprobe(&rp->kp);
>>>>>>>> +}
>>>>>>>> +static inline int enable_kretprobe(struct kretprobe *rp)
>>>>>>>> +{
>>>>>>>> + return enable_kprobe(&rp->kp);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>  #else /* CONFIG_KRETPROBES */
>>>>>>>>  static inline void arch_prepare_kretprobe(struct kretprobe *rp,
>>>>>>>>   struct pt_regs *regs)
>>>>>>>> @@ -236,19 +262,20 @@ static inline int arch_trampoline_kprobe(struct kprobe *p)
>>>>>>>>  {
>>>>>>>>   return 0;
>>>>>>>>  }
>>>>>>>> -#endif /* CONFIG_KRETPROBES */
>>>>>>>> -
>>>>>>>> -extern struct kretprobe_blackpoint kretprobe_blacklist[];
>>>>>>>> -
>>>>>>>>  static inline void kretprobe_assert(struct kretprobe_instance *ri,
>>>>>>>>   unsigned long orig_ret_address, unsigned long trampoline_address)
>>>>>>>>  {
>>>>>>>> - if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
>>>>>>>> - printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
>>>>>>>> - ri->rp, ri->rp->kp.addr);
>>>>>>>> - BUG();
>>>>>>>> - }
>>>>>>>>  }
>>>>>>>> +static inline int disable_kretprobe(struct kretprobe *rp)
>>>>>>>> +{
>>>>>>>> + return 0;
>>>>>>>> +}
>>>>>>>> +static inline int enable_kretprobe(struct kretprobe *rp)
>>>>>>>> +{
>>>>>>>> + return 0;
>>>>>>>> +}
>>>>>>>
>>>>>>> No, these should returns -EINVAL or -ENOSYS, since these are user API.
>>>>>>
>>>>>> OK, thanks, it sounds reasonable to me.
>>>>>>
>>>>>>> Anyway, I don't think those inlined functions to be changed, because
>>>>>>> most of them are internal functions. If CONFIG_KRETPROBES=n, it just
>>>>>>> be ignored.
>>>>>>>
>>>>>>
>>>>>> In original implementation, if CONFIG_KRETPROBES=n, kretprobe_assert(),
>>>>>> disable_kretprobe(), and enable_kretprobe() are not ignored.
>>>>>
>>>>> Really? where are they called? I mean, those functions do not have
>>>>> any instance unless your module uses it (but that is not what the kernel
>>>>> itself should help).
>>>>>
>>>>
>>>> If what you said correct (I guess so), for me, we still need let them in
>>>> CONFIG_KRETPROBES area, and without any dummy outside, just like another
>>>> *kprobe* static inline functions have done in "include/linux/kprobes.h".
>>>
>>> kretprobe_assert() is only for the internal check. So we don't need to care
>>> about, and disable/enable_kretprobe() are anyway returns -EINVAL because
>>> kretprobe can not be registered. And all of them are inlined functions.
>>> In that case, we don't need to care about it.
>>
>> Hmm... it is related with code 'consistency':
>>
>>  - these static inline functions are kretprobe generic implementation,
>>    and we are trying to let all kretprobe generic implementation within
>>    CONFIG_KRETPROBES area.
> 
> No, actually, kretprobe is just built on the kprobe. enable/disable_kretprobe
> just wrapped the kprobe methods. And kretprobe_assert() is just for kretprobe
> internal use. that is not an API. Moving only the kretprobe_assert() into the
> CONFIG_KRETPROBE area is not bad, but since it is just a static inline function,
> if there is no caller, it just be ignored, no side effect.
> 

OK, I can understand.

And do you mean enable/disable_kretprobe() are API? if so, we have to
implement them whether CONFIG_KRETPROBES enabled or disabled.

And when CONFIG_KRETPROBES=n, just like what you originally said: we
need returns -EINVAL directly (either, I am not quite sure whether the
input parameter will be NULL, in this case).

>>
>>  - And original kprobe static inline functions have done like that,
>>    in same header file, if no obvious reasons, we can try to follow.
> 
> It is no reasons to follow that too. Please keep your patch simple as much
> as possible.
> 

"keep our patch simple as much as posssible" sounds reasonable to me.
After skip "include/linux/kprobe.h", our patch's subject (include
comments) also need be changed (I will/should change it).

For me, "include/linux/kprobe.h" can also be improved, but it can be
another patch for it (not only for kretprobe, but also for jpobe).


>>> I just concerned that it is a waste of memory if there are useless kretprobe
>>> related instances are built when CONFIG_KRETPROBES=n.
>>>
>>
>> Yeah, that is also one of reason (3rd reason).
>>
>>
>> And if necessary, please help check what we have done whether already
>> "let all kretprobe generic implementation within CONFIG_KRETPROBES area"
>> (exclude declaration, struct/union definition, and architecture
>> implementation).
> 
> As I commented, your changes in kernel/kprobes.c are good to me except
> two functions. That's all what we need to fix :)
> 

I will send a patch for it (since subject changed, we need not mark
"patch v2"), thanks.  :-)

> Thank you!
> 

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
