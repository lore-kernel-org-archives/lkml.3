Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3JZNjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:39:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32617 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3JZNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:39:33 -0400
X-Spam-Score: -100.8
Message-ID: <526BC5D4.9070809@asianux.com>
Date: Sat, 26 Oct 2013 21:38:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
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
Subject: Re: Portable assmbler code - newline (was Re: [PATCH] kernel/modsign_certificate.S:
 use real contents instead of macro GLOBAL())
References: <523FD9E7.3050303@asianux.com>	<523FDBD7.4040602@asianux.com>	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>	<523FE578.5060801@asianux.com>	<52672DAC.1030307@asianux.com>	<CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>	<52673E41.6040606@asianux.com>	<5267AF98.1010800@asianux.com>	<5268B0B1.9050009@asianux.com>	<CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>	<526958D8.6030102@synopsys.com> <CAMuHMdURxpuWPYYDTU2Sa4eF8WZTb=0ALQ+irtGk9ERtSKz09Q@mail.gmail.com> <5269FD53.6040903@synopsys.com>
In-Reply-To: <5269FD53.6040903@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 01:10 PM, Vineet Gupta wrote:
> On 10/25/2013 01:11 AM, Geert Uytterhoeven wrote:
>> On Thu, Oct 24, 2013 at 7:28 PM, Vineet Gupta <vineetg76@gmail.com> wrote:
>>>> +CC linux-arch
>>>>
>>>> On 10/24/2013 11:33 AM, Richard Weinberger wrote:
>>>>>> On Thu, Oct 24, 2013 at 7:31 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>>>>>> For some architectures, tool chain is not smart enough to recognize the
>>>>>>>>>> macro with multiple lines (e.g. arc tool chain), and for common ".S"
>>>>>>>>>> file, this kind of macro is also rarely used.
>>>>>> Does not "not smart enough" mean than the said toolchain is broken/buggy
>>>>>> or is the kernel using an unsupported notation?
>>>>>>
>>>>
>>>> IMHO this is not broken - rather the code is not fully portable - given that gas
>>>> ports of arches have differnet notions of what to treat as comment and what newline.
>>>>
>>>> Looking as binutils/gas/config, I can see that avr, cris,...are likely broken in
>>>> the same way as ARC is.
>>>>
>>>> Historically ARC has had ';' as comment char, which Joern relatively recently
>>>> augmented to have '#' as well. However there's legacy codebase which relies on ';'
>>>> being a comment and we can't change that fact.
>>>>
>>>> So can we introduce an ARCH over-ridable newline annotation in linkage.h and other
>>>> places after auditing. Since asm/linkage.h preempts linux/linkage.h by way of
>>>> #include it shd be pretty strightforward.
>>>>
>>>> Something like below. I can send the formal patch if people think the approach is OK.
>> By what are you gonna override __ARCH_NL on ARC?
>> I'm afraid cpp will still turn it into a single line.
>>
> 
> Eh ! My untested patch was broken but not because of what you mentioned.
> 
> For ARC, the ; negating the newline annotation. So the following works (backquote
> is new line for ARC)
> 
> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
> index 0283e9e44e0d..b3eea2999322 100644
> --- a/arch/arc/include/asm/linkage.h
> +++ b/arch/arc/include/asm/linkage.h
> @@ -9,6 +9,8 @@
>  #ifndef __ASM_LINKAGE_H
>  #define __ASM_LINKAGE_H
> 
> +#define __ARCH_NL      `
> +
>  #ifdef __ASSEMBLY__
> 
> 
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index d3e8ad23a8e0..969e70ad231a 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -6,6 +6,10 @@
>  #include <linux/export.h>
>  #include <asm/linkage.h>
> 
> +#ifndef __ARCH_NL
> +#define __ARCH_NL      ;
> +#endif
> +
>  #ifdef __cplusplus
>  #define CPP_ASMLINKAGE extern "C"
>  #else
> @@ -75,7 +79,7 @@
> 
>  #ifndef ENTRY
>  #define ENTRY(name) \
> -  .globl name; \
> +  .globl name __ARCH_NL \
>    ALIGN; \

Do we also need consider about "ALIGN;"?

>    name:
>  #endif
> 

For next-20130927 tree, do we also need consider about WEAK, ENDPROC?


I am not quite sure about it, but I will try. Now, I am just analyzing
another issue -- maybe the last issue for allmodconfig under arc, which
may be related with this patch, the errors are:

      1   Building modules, stage 2.
      2   MODPOST 2994 modules
      3 ERROR: "__st_r13_to_r20" [sound/usb/snd-usbmidi-lib.ko] undefined!
      4 ERROR: "__ld_r13_to_r15" [sound/usb/snd-usbmidi-lib.ko] undefined!
      5 ERROR: "__st_r13_to_r18" [sound/usb/snd-usbmidi-lib.ko] undefined!
      6 ERROR: "__ld_r13_to_r14_ret" [sound/usb/snd-usbmidi-lib.ko] undefined!
      7 ERROR: "__ld_r13_to_r22" [sound/usb/snd-usbmidi-lib.ko] undefined!
      8 ERROR: "__ld_r13_to_r15_ret" [sound/usb/snd-usbmidi-lib.ko] undefined!
      9 ERROR: "__ld_r13_to_r16" [sound/usb/snd-usbmidi-lib.ko] undefined!
     10 ERROR: "__ld_r13_to_r18_ret" [sound/usb/snd-usbmidi-lib.ko] undefined!
     11 ERROR: "__ld_r13_to_r24_ret" [sound/usb/snd-usbmidi-lib.ko] undefined!
     ...
     ...
  
  28095 ERROR: "__st_r13_to_r17" [arch/arc/oprofile/oprofile.ko] undefined!
  28096 ERROR: "__st_r13_to_r22" [arch/arc/oprofile/oprofile.ko] undefined!
  28097 ERROR: "__ld_r13_to_r19_ret" [Documentation/filesystems/configfs/configfs_example_macros.ko] undefined!
  28098 ERROR: "__st_r13_to_r19" [Documentation/filesystems/configfs/configfs_example_macros.ko] undefined!
  28099 ERROR: "__ld_r13_to_r14_ret" [Documentation/filesystems/configfs/configfs_example_macros.ko] undefined!
  28100 ERROR: "__ld_r13_to_r19_ret" [Documentation/filesystems/configfs/configfs_example_explicit.ko] undefined!
  28101 ERROR: "__st_r13_to_r19" [Documentation/filesystems/configfs/configfs_example_explicit.ko] undefined!
  28102 ERROR: "__ld_r13_to_r14_ret" [Documentation/filesystems/configfs/configfs_example_explicit.ko] undefined!
  28103 ERROR: "__ld_r13_to_r14_ret" [Documentation/connector/cn_test.ko] undefined!
  28104 make[1]: *** [__modpost] Error 1
  28105 make: *** [modules] Error 2


Thanks.
-- 
Chen Gang
