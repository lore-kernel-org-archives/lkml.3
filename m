Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbbAMBBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:01:15 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36634 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbAMBBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <54B3FC53.7080702@landley.net>
References: <54AC72AF.5090609@landley.net>
	<20150106155024.5efa209d575fff4868758482@linux-foundation.org>
	<54B3FC53.7080702@landley.net>
Date: Mon, 12 Jan 2015 17:01:10 -0800
X-Google-Sender-Auth: -Y_E1LAc5GKs-A5thCiZ0q3nl8s
Message-ID: <CAGXu5j+z4NUq4YHeZW5ZN9Wi5ss2RJE_HzC0k-8nDnZxtnavgg@mail.gmail.com>
Subject: Re: [PATCHv2] remove recently added perl build requirement
From: Kees Cook <keescook@chromium.org>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Junjie Mao <eternal.n08@gmail.com>, "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 8:54 AM, Rob Landley <rob@landley.net> wrote:
> From: Rob Landley <rob@landley.net>
>
> Commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
> added perl back to the kernel build dependencies in -rc6.

Ah, yeah, good call on Perl as a build dep.

> Replace those 39 lines of perl with 4 lines of shell script.
>
> Signed-off-by: Rob Landley <rob@landley.net>
> Acked-by: Anca Emanuel <anca.emanuel@gmail.com>
> ---
>
>  arch/x86/boot/compressed/Makefile |    6 ++--
>  arch/x86/tools/calc_run_size.pl   |   39 ----------------------------
>  2 files changed, 4 insertions(+), 41 deletions(-)
>
> Note: checkpatch.pl isn't a build dependency, it's a development dependency
> (like bloat-o-meter being written in python or "make xconfig" needing QT).
> Those aren't things you need to add to your cross compile environment
> to produce a binary. Different category of dependency.
>
> For more history on the issue, see https://lkml.org/lkml/2013/2/27/18
>
> --- linux/arch/x86/boot/compressed/Makefile
> +++ linux/arch/x86/boot/compressed/Makefile
> @@ -89,8 +76,10 @@
>  suffix-$(CONFIG_KERNEL_LZO)    := lzo
>  suffix-$(CONFIG_KERNEL_LZ4)    := lz4
>
> -RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
> -            perl $(srctree)/arch/x86/tools/calc_run_size.pl)
> +RUN_SIZE = $(shell NUM='\([0-9a-fA-F]*[ \t]*\)'; $(OBJDUMP) -h vmlinux | \
> +sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$$NUM$$NUM$$NUM$$NUM"'.*/\1\4/p' | \
> +xargs | while read a b c d; do [ "$$b" != "$$d" ] && exit 1; \
> +expr $$(printf "%d + %d + %d" 0x$$a 0x$$b 0x$$c); done)
>  quiet_cmd_mkpiggy = MKPIGGY $@
>        cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )

I'd much prefer a full shell script as this is hard to read. It loses
all the comments and variable names, etc. Also, this reverts commit
70b61e362187 ("x86, kaslr: Handle Gold linker for finding bss/brk").

-Kees

>
> --- linux/arch/x86/tools/calc_run_size.pl
> +++ /dev/null
> @@ -1,39 +0,0 @@
> -#!/usr/bin/perl
> -#
> -# Calculate the amount of space needed to run the kernel, including room for
> -# the .bss and .brk sections.
> -#
> -# Usage:
> -# objdump -h a.out | perl calc_run_size.pl
> -use strict;
> -
> -my $mem_size = 0;
> -my $file_offset = 0;
> -
> -my $sections=" *[0-9]+ \.(?:bss|brk) +";
> -while (<>) {
> -       if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
> -               my $size = hex($1);
> -               my $offset = hex($2);
> -               $mem_size += $size;
> -               if ($file_offset == 0) {
> -                       $file_offset = $offset;
> -               } elsif ($file_offset != $offset) {
> -                       # BFD linker shows the same file offset in ELF.
> -                       # Gold linker shows them as consecutive.
> -                       next if ($file_offset + $mem_size == $offset + $size);
> -
> -                       printf STDERR "file_offset: 0x%lx\n", $file_offset;
> -                       printf STDERR "mem_size: 0x%lx\n", $mem_size;
> -                       printf STDERR "offset: 0x%lx\n", $offset;
> -                       printf STDERR "size: 0x%lx\n", $size;
> -
> -                       die ".bss and .brk are non-contiguous\n";
> -               }
> -       }
> -}
> -
> -if ($file_offset == 0) {
> -       die "Never found .bss or .brk file offset\n";
> -}
> -printf("%d\n", $mem_size + $file_offset);



-- 
Kees Cook
Chrome OS Security
