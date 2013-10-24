Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3JXTmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:42:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38745 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3JXTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <526958D8.6030102@synopsys.com>
References: <523FD9E7.3050303@asianux.com>
	<523FDBD7.4040602@asianux.com>
	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
	<523FE578.5060801@asianux.com>
	<52672DAC.1030307@asianux.com>
	<CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>
	<52673E41.6040606@asianux.com>
	<5267AF98.1010800@asianux.com>
	<5268B0B1.9050009@asianux.com>
	<CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com>
	<526958D8.6030102@synopsys.com>
Date: Thu, 24 Oct 2013 21:41:58 +0200
X-Google-Sender-Auth: Mta8XZXL8agD7V7Cwv_OFkmnJGk
Message-ID: <CAMuHMdURxpuWPYYDTU2Sa4eF8WZTb=0ALQ+irtGk9ERtSKz09Q@mail.gmail.com>
Subject: Re: Portable assmbler code - newline (was Re: [PATCH]
 kernel/modsign_certificate.S: use real contents instead of macro GLOBAL())
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vineet Gupta <vineetg76@gmail.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Chen Gang <gang.chen@asianux.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 7:28 PM, Vineet Gupta <vineetg76@gmail.com> wrote:
> +CC linux-arch
>
> On 10/24/2013 11:33 AM, Richard Weinberger wrote:
>> On Thu, Oct 24, 2013 at 7:31 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> > For some architectures, tool chain is not smart enough to recognize the
>>> > macro with multiple lines (e.g. arc tool chain), and for common ".S"
>>> > file, this kind of macro is also rarely used.
>> Does not "not smart enough" mean than the said toolchain is broken/buggy
>> or is the kernel using an unsupported notation?
>>
>
> IMHO this is not broken - rather the code is not fully portable - given that gas
> ports of arches have differnet notions of what to treat as comment and what newline.
>
> Looking as binutils/gas/config, I can see that avr, cris,...are likely broken in
> the same way as ARC is.
>
> Historically ARC has had ';' as comment char, which Joern relatively recently
> augmented to have '#' as well. However there's legacy codebase which relies on ';'
> being a comment and we can't change that fact.
>
> So can we introduce an ARCH over-ridable newline annotation in linkage.h and other
> places after auditing. Since asm/linkage.h preempts linux/linkage.h by way of
> #include it shd be pretty strightforward.
>
> Something like below. I can send the formal patch if people think the approach is OK.

By what are you gonna override __ARCH_NL on ARC?
I'm afraid cpp will still turn it into a single line.

> ----------------->
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index d3e8ad23a8e0..4188c632f2b8 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -6,6 +6,10 @@
>  #include <linux/export.h>
>  #include <asm/linkage.h>
>
> +#ifndef __ARCH_NL
> +#define __ARCH_NL
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
> +  .globl name; __ARCH_NL \
>    ALIGN; \
>    name:
>  #endif
> @@ -83,7 +87,7 @@
>
>  #ifndef WEAK
>  #define WEAK(name)        \
> -       .weak name;        \
> +       .weak name; __ARCH_NL \
>         name:
>  #endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
