Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3KYKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:43:05 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41432 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <1385374617.2354.22.camel@dabdike>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
	<1385374617.2354.22.camel@dabdike>
Date: Mon, 25 Nov 2013 11:43:01 +0100
X-Google-Sender-Auth: 9gY6gywclV4KXsP8f8wenofxUYo
Message-ID: <CAMuHMdXoy5DaKqGWrZxeof2UuoZK01=oxmQmy8kEvNS8CJLaTg@mail.gmail.com>
Subject: Re: [PATCH 0024] asm-generic: Rename int-ll64.h to types.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:16 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2013-11-25 at 09:55 +0100, Geert Uytterhoeven wrote:
>> This patchset aims to rename <asm-generic/int-ll64.h> to
>> <asm-generic/types.h> in kernelspace, as suggested by Arnd.
>>
>> While userspace still has both include/uapi/asm-generic/int-l64.h and
>> include/uapi/asm-generic/int-ll64.h (int-l64.h may still be used on legacy
>> 64-bit systems), kernelspace always uses "(unsigned) long long" for 64-bit
>> integer values ("u64" and "s64").  Hence there's no longer a need to
>> distinguish between int-l64 and int-ll64 in kernelspace, and int-ll64.h can
>> just be called types.h
>
> Is this a good idea?  I thought some versions of gcc used long long for
> 128 bit integers, in which case int-ll64.h will give the wrong types for
> u64 and s64.  I think gcc is changing to use the __int128 type, so this
> may be historical, but someone would need to validate that we have no
> architectures with the old long long behaviour.

I'm sorry, "(unsigned) long long" is always 64 bit in kernelspace.

<asm-generic/int-l64.h> is included in uapi files only, and all of these
inclusions are protected by #ifndef __KERNEL__:

$ git grep -C 2 "include.*int-l64.h" -- "*.h"
arch/alpha/include/uapi/asm/types.h-
arch/alpha/include/uapi/asm/types.h-#ifndef __KERNEL__
arch/alpha/include/uapi/asm/types.h:#include <asm-generic/int-l64.h>
arch/alpha/include/uapi/asm/types.h-#endif
arch/alpha/include/uapi/asm/types.h-
--
arch/ia64/include/uapi/asm/types.h-
arch/ia64/include/uapi/asm/types.h-#ifndef __KERNEL__
arch/ia64/include/uapi/asm/types.h:#include <asm-generic/int-l64.h>
arch/ia64/include/uapi/asm/types.h-#endif
arch/ia64/include/uapi/asm/types.h-
--
arch/mips/include/uapi/asm/types.h-#ifndef __KERNEL__
arch/mips/include/uapi/asm/types.h-# if _MIPS_SZLONG == 64
arch/mips/include/uapi/asm/types.h:#  include <asm-generic/int-l64.h>
arch/mips/include/uapi/asm/types.h-# else
arch/mips/include/uapi/asm/types.h-#  include <asm-generic/int-ll64.h>
--
arch/powerpc/include/uapi/asm/types.h- */
arch/powerpc/include/uapi/asm/types.h-#if
!defined(__SANE_USERSPACE_TYPES__) && defined(__powerpc64__) &&
!defined(__KERNEL__)
arch/powerpc/include/uapi/asm/types.h:# include <asm-generic/int-l64.h>
arch/powerpc/include/uapi/asm/types.h-#else
arch/powerpc/include/uapi/asm/types.h-# include <asm-generic/int-ll64.h>
--
include/asm-generic/int-l64.h-#define _ASM_GENERIC_INT_L64_H
include/asm-generic/int-l64.h-
include/asm-generic/int-l64.h:#include <uapi/asm-generic/int-l64.h>
include/asm-generic/int-l64.h-
include/asm-generic/int-l64.h-
$

(non-UAPI include/asm-generic/int-l64.h is unused, its removal is pending).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
