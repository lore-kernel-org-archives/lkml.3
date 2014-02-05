Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaBEE5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:57:53 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55304 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaBEE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:57:52 -0500
Message-ID: <52F1C4C3.2070404@hitachi.com>
Date: Wed, 05 Feb 2014 13:57:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        =?UTF-8?B?SMOldmFy?= =?UTF-8?B?ZCBTa2lubmVtb2Vu?= 
	<hskinnemoen@gmail.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kernel: kprobe: move all *kretprobe* generic implementation
 to CONFIG_KRETPROBES enabled area
References: <52ECE5D8.6090209@gmail.com> <52EDB022.5070101@hitachi.com> <52EF8222.6030709@gmail.com> <52EFB8F4.6010207@hitachi.com> <52F04FA8.8040008@gmail.com> <52F077A1.3020701@gmail.com> <52F09404.3060502@hitachi.com> <52F0D7F3.7000901@gmail.com> <52F0EB30.2070401@hitachi.com> <52F0F0ED.5090005@gmail.com> <52F109AF.8040800@hitachi.com> <52F18367.2060803@gmail.com> <52F19223.5010506@hitachi.com> <52F1AB18.5040208@gmail.com>
In-Reply-To: <52F1AB18.5040208@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/05 12:08), Chen Gang wrote:
>>>>>>>> Anyway, I don't think those inlined functions to be changed, because
>>>>>>>> most of them are internal functions. If CONFIG_KRETPROBES=n, it just
>>>>>>>> be ignored.
>>>>>>>>
>>>>>>>
>>>>>>> In original implementation, if CONFIG_KRETPROBES=n, kretprobe_assert(),
>>>>>>> disable_kretprobe(), and enable_kretprobe() are not ignored.
>>>>>>
>>>>>> Really? where are they called? I mean, those functions do not have
>>>>>> any instance unless your module uses it (but that is not what the kernel
>>>>>> itself should help).
>>>>>>
>>>>>
>>>>> If what you said correct (I guess so), for me, we still need let them in
>>>>> CONFIG_KRETPROBES area, and without any dummy outside, just like another
>>>>> *kprobe* static inline functions have done in "include/linux/kprobes.h".
>>>>
>>>> kretprobe_assert() is only for the internal check. So we don't need to care
>>>> about, and disable/enable_kretprobe() are anyway returns -EINVAL because
>>>> kretprobe can not be registered. And all of them are inlined functions.
>>>> In that case, we don't need to care about it.
>>>
>>> Hmm... it is related with code 'consistency':
>>>
>>>  - these static inline functions are kretprobe generic implementation,
>>>    and we are trying to let all kretprobe generic implementation within
>>>    CONFIG_KRETPROBES area.
>>
>> No, actually, kretprobe is just built on the kprobe. enable/disable_kretprobe
>> just wrapped the kprobe methods. And kretprobe_assert() is just for kretprobe
>> internal use. that is not an API. Moving only the kretprobe_assert() into the
>> CONFIG_KRETPROBE area is not bad, but since it is just a static inline function,
>> if there is no caller, it just be ignored, no side effect.
>>
> 
> OK, I can understand.
> 
> And do you mean enable/disable_kretprobe() are API? if so, we have to
> implement them whether CONFIG_KRETPROBES enabled or disabled.
> 
> And when CONFIG_KRETPROBES=n, just like what you originally said: we
> need returns -EINVAL directly (either, I am not quite sure whether the
> input parameter will be NULL, in this case).

Both are API, and when implementing it I had also considered that, but
I decided to stay it in inline-function wrapper. The reason why is,
that enable/disable_k*probe require the registered k*probes. If the
kernel hacker uses those functions, they must ensure registering his
k*probes, otherwise it does not work correctly. If the CONFIG_KRETPROBES=n,
register_kretprobe() always fails, this means that the code has
no chance to call those functions (it must be).

>>>  - And original kprobe static inline functions have done like that,
>>>    in same header file, if no obvious reasons, we can try to follow.
>>
>> It is no reasons to follow that too. Please keep your patch simple as much
>> as possible.
>>
> 
> "keep our patch simple as much as posssible" sounds reasonable to me.
> After skip "include/linux/kprobe.h", our patch's subject (include
> comments) also need be changed (I will/should change it).
> 
> For me, "include/linux/kprobe.h" can also be improved, but it can be
> another patch for it (not only for kretprobe, but also for jpobe).

if that "improvement" means "simplify", it is acceptable. Now I don't like
ifdefs of CONFIG_KPROBES and dummy functions, since if CONFIG_KPROBES=n,
other kernel modules can also check the kconfig and decide what they do
(or don't).
Perhaps, what we've really needed is "just enough able to compile",
not the fully covered dummy APIs.

>>>> I just concerned that it is a waste of memory if there are useless kretprobe
>>>> related instances are built when CONFIG_KRETPROBES=n.
>>>>
>>>
>>> Yeah, that is also one of reason (3rd reason).
>>>
>>>
>>> And if necessary, please help check what we have done whether already
>>> "let all kretprobe generic implementation within CONFIG_KRETPROBES area"
>>> (exclude declaration, struct/union definition, and architecture
>>> implementation).
>>
>> As I commented, your changes in kernel/kprobes.c are good to me except
>> two functions. That's all what we need to fix :)
>>
> 
> I will send a patch for it (since subject changed, we need not mark
> "patch v2"), thanks.  :-)

OK, I'll review that.

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


