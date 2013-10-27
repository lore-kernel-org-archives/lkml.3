Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3J0H2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:28:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52621 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3J0H2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:28:52 -0400
Message-ID: <526CC0AD.8090208@synopsys.com>
Date: Sun, 27 Oct 2013 12:58:45 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Portable assmbler code - newline
References: <523FD9E7.3050303@asianux.com>	<523FDBD7.4040602@asianux.com>	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>	<523FE578.5060801@asianux.com>	<52672DAC.1030307@asianux.com>	<CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>	<52673E41.6040606@asianux.com>	<5267AF98.1010800@asianux.com>	<5268B0B1.9050009@asianux.com>	<CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>	<526958D8.6030102@synopsys.com> <CAMuHMdURxpuWPYYDTU2Sa4eF8WZTb=0ALQ+irtGk9ERtSKz09Q@mail.gmail.com> <5269FD53.6040903@synopsys.com> <526BC5D4.9070809@asianux.com>
In-Reply-To: <526BC5D4.9070809@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 07:08 PM, Chen Gang wrote:
> On 10/25/2013 01:10 PM, Vineet Gupta wrote:
>> On 10/25/2013 01:11 AM, Geert Uytterhoeven wrote:
>>> On Thu, Oct 24, 2013 at 7:28 PM, Vineet Gupta <vineetg76@gmail.com> wrote:
>>>>> +CC linux-arch
>>>>>
>>>>> On 10/24/2013 11:33 AM, Richard Weinberger wrote:
>>>>>>> On Thu, Oct 24, 2013 at 7:31 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>>>>>>> For some architectures, tool chain is not smart enough to recognize the
>>>>>>>>>>> macro with multiple lines (e.g. arc tool chain), and for common ".S"
>>>>>>>>>>> file, this kind of macro is also rarely used.
>>>>>>> Does not "not smart enough" mean than the said toolchain is broken/buggy
>>>>>>> or is the kernel using an unsupported notation?
>>>>>>>
>>>>>
>>>>> IMHO this is not broken - rather the code is not fully portable - given that gas
>>>>> ports of arches have differnet notions of what to treat as comment and what newline.
>>>>>
>>>>> Looking as binutils/gas/config, I can see that avr, cris,...are likely broken in
>>>>> the same way as ARC is.
>>>>>
>>>>> Historically ARC has had ';' as comment char, which Joern relatively recently
>>>>> augmented to have '#' as well. However there's legacy codebase which relies on ';'
>>>>> being a comment and we can't change that fact.
>>>>>
>>>>> So can we introduce an ARCH over-ridable newline annotation in linkage.h and other
>>>>> places after auditing. Since asm/linkage.h preempts linux/linkage.h by way of
>>>>> #include it shd be pretty strightforward.
>>>>>
>>>>> Something like below. I can send the formal patch if people think the approach is OK.
>>> By what are you gonna override __ARCH_NL on ARC?
>>> I'm afraid cpp will still turn it into a single line.
>>>
>>
>> Eh ! My untested patch was broken but not because of what you mentioned.
>>
>> For ARC, the ; negating the newline annotation. So the following works (backquote
>> is new line for ARC)
>>
>> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
>> index 0283e9e44e0d..b3eea2999322 100644
>> --- a/arch/arc/include/asm/linkage.h
>> +++ b/arch/arc/include/asm/linkage.h
>> @@ -9,6 +9,8 @@
>>  #ifndef __ASM_LINKAGE_H
>>  #define __ASM_LINKAGE_H
>>
>> +#define __ARCH_NL      `
>> +
>>  #ifdef __ASSEMBLY__
>>
>>
>> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
>> index d3e8ad23a8e0..969e70ad231a 100644
>> --- a/include/linux/linkage.h
>> +++ b/include/linux/linkage.h
>> @@ -6,6 +6,10 @@
>>  #include <linux/export.h>
>>  #include <asm/linkage.h>
>>
>> +#ifndef __ARCH_NL
>> +#define __ARCH_NL      ;
>> +#endif
>> +
>>  #ifdef __cplusplus
>>  #define CPP_ASMLINKAGE extern "C"
>>  #else
>> @@ -75,7 +79,7 @@
>>
>>  #ifndef ENTRY
>>  #define ENTRY(name) \
>> -  .globl name; \
>> +  .globl name __ARCH_NL \
>>    ALIGN; \
> 
> Do we also need consider about "ALIGN;"?

Right - as I said already, above was not a formal patch but a RFC whether we are
on right track. The proper fix will have to audit all such places.


>>    name:
>>  #endif
>>
> 
> For next-20130927 tree, do we also need consider about WEAK, ENDPROC?

Indeed.


> I am not quite sure about it, but I will try. 

So you volunteer to send out a patch base don __ARCH_NL I proposed above ?


> Now, I am just analyzing
> another issue -- maybe the last issue for allmodconfig under arc, which
> may be related with this patch, the errors are:
> 
>       1   Building modules, stage 2.
>       2   MODPOST 2994 modules
>       3 ERROR: "__st_r13_to_r20" [sound/usb/snd-usbmidi-lib.ko] undefined!

Yes we know about this already. This is to do with libgcc linkage. The fix is non
trivial - I'll get back to you on this. For now disable CONFIG_CC_OPTIMIZE_FOR_SIZE.

-Vineet
