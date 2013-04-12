Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3DLTrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:47:51 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:42422 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3DLTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXJWo=R28rexHJZGof==CgEa0gbC3yr18iPs-tAkv2FZQ@mail.gmail.com>
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
	<51653C5D.4060408@suse.cz>
	<CAMuHMdXEvLMz5rRjQrhENxJ6UHRnPCtzyNg=hqitspuY88G7sA@mail.gmail.com>
	<20130410122611.GB17541@sepie.suse.cz>
	<CAMuHMdUHiiBEZm7eFYtL3PqCXF6PjscbFKjiJ33BEwQ+YLKOXQ@mail.gmail.com>
	<20130410152229.GC17541@sepie.suse.cz>
	<CAMuHMdXJWo=R28rexHJZGof==CgEa0gbC3yr18iPs-tAkv2FZQ@mail.gmail.com>
Date: Fri, 12 Apr 2013 21:47:46 +0200
X-Google-Sender-Auth: cubha91V8Ty3QeTCp5dxaOA-0N4
Message-ID: <CAMuHMdXTKTVb_QLUn3xuA0tMThxC1mR331jU4O11dG4rNyWzRw@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 8:04 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Apr 10, 2013 at 5:22 PM, Michal Marek <mmarek@suse.cz> wrote:
>> Subject: [PATCH] m68k: Remove inline strlen() implementation
>>
>> GCC can replace a strncat() call with constant second argument into a
>> strlen + store, which results in a link error:
>>
>> ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!
>>
>> The inline function is a simple for loop in C. Other architectures
>> either use an asm optimized variant, or use the generic function from
>> lib/string.c.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>
> Thanks, this one works. Let me do some measurements...

No visible impact on size for a typical build; the increase in .text
is offset by
the decrease in .data:

-      .text : 0x00001000 - 0x002aab64   (2727 KiB)
-      .data : 0x002ad938 - 0x00392148   ( 915 KiB)
+      .text : 0x00001000 - 0x002aac74   (2728 KiB)
+      .data : 0x002ada48 - 0x00392148   ( 914 KiB)

On Wed, Apr 10, 2013 at 5:22 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Apr 10, 2013 at 04:19:14PM +0200, Geert Uytterhoeven wrote:
>> Thanks for the patch, but modpost still fails with
>>
>> ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!
>
> OK OK, I am convinced. Then how about this? If you prefer speed over
> size, the the other option is to add
>
> size_t strlen(const char *s)
> {
>        return __kernel_strlen(s);
> }
> EXPORT_SYMBOL(strlen);
>
> to arch/m68k/lib/string.c.

Interestingly, this also doesn't work. It turns out none of the
symbols defined in
this file (currently strcpy and strcat) end up in vmlinux.

As we've been stripping code from string.c, we've been left with just
a few symbols
that are typically never referenced, so the whole string.o in
arch/m68k/lib/lib.a
is not included in the final vmlinux.

So more stringectomy to do...

> On a related note, arch/m68k/lib/string.c is
> built only in the CONFIG_MMU case, whereas asm/string.h is shared.

So due to the above, this difference is mostly moot ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
