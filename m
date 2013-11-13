Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3KMODH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:03:07 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33269 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3KMOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <5283814C.6040904@monstr.eu>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
	<1384285347-13506-16-git-send-email-geert@linux-m68k.org>
	<5283524F.8030902@monstr.eu>
	<5283814C.6040904@monstr.eu>
Date: Wed, 13 Nov 2013 15:02:49 +0100
X-Google-Sender-Auth: 0NnyNJGYR8kts9apFvo4dDvrXMA
Message-ID: <CAMuHMdWOCdEcDMpJgQ5tOMJ=ygqapvjy2NzGkc9Esk5gZZ57fw@mail.gmail.com>
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 2:40 PM, Michal Simek <monstr@monstr.eu> wrote:
>>> QUESTION: The padding of the DTB is gone, is this OK?
>>
>> Removing this kernel padding should be fine. I can't remember
>> why it was there from the beginning.
>
> I know why is this here. The reason is process how dtb is passed
> to the kernel via command line. head.S code just copy that dtb to
> the same location where compiled-in dts is expected and kernel
> doesn't need to care about position of dtb because this copy is
> done without MMU. And the full kernel is covered by 2 tlbs and
> we don't need to use another TLB for dtb mapping.
>
> It means pad matters a lot. Because u-boot ITS format doesn't use
> simpleImage target but the kernel need to have a space for copying
> dtb to this kernel location.
>
> Let me think about if there is an easy way to handle dtbs
> which are passed from bootloader.

You can add to asm-generic/sections.h:

#ifndef ARCH_DTB_PADDING
#define ARCH_DTB_PADDING
#endif

and change KERNEL_DTB() to:

#define KERNEL_DTB()                                                    \
       STRUCT_ALIGN();                                                 \
       VMLINUX_SYMBOL(__dtb_start) = .;                                \
       *(.dtb.init.rodata)                                             \
       ARCH_DTB_PADDING                                \
       VMLINUX_SYMBOL(__dtb_end) = .;

Then microblaze can predefine ARCH_DTB_PADDING in its
<asm/sections.h>.

Still, it will crash badly if the external DTB is larger than
ARCH_DTB_PADDING.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
