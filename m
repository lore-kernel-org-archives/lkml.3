Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaKRCRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:17:24 -0500
Received: from mail-ig0-f201.google.com ([209.85.213.201]:41852 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKRCRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:17:22 -0500
References: <1414762838-13067-1-git-send-email-eternal.n08@gmail.com>
From: Greg Thelen <gthelen@google.com>
To: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86, kaslr: Prevent .bss from overlaping initrd
In-reply-to: <1414762838-13067-1-git-send-email-eternal.n08@gmail.com>
Date: Mon, 17 Nov 2014 18:17:20 -0800
Message-ID: <xr9361ed9rrj.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31 2014, Junjie Mao wrote:

> When choosing a random address, the current implementation does not take into
> account the reversed space for .bss and .brk sections. Thus the relocated kernel
> may overlap other components in memory. Here is an example of the overlap from a
> x86_64 kernel in qemu (the ranges of physical addresses are presented):
>
>  Physical Address
>
>     0x0fe00000                  --+--------------------+  <-- randomized base
>                                /  |  relocated kernel  |
>                    vmlinux.bin    | (from vmlinux.bin) |
>     0x1336d000    (an ELF file)   +--------------------+--
>                                \  |                    |  \
>     0x1376d870                  --+--------------------+   |
>                                   |    relocs table    |   |
>     0x13c1c2a8                    +--------------------+   .bss and .brk
>                                   |                    |   |
>     0x13ce6000                    +--------------------+   |
>                                   |                    |  /
>     0x13f77000                    |       initrd       |--
>                                   |                    |
>     0x13fef374                    +--------------------+
>
> The initrd image will then be overwritten by the memset during early
> initialization:
>
> [    1.655204] Unpacking initramfs...
> [    1.662831] Initramfs unpacking failed: junk in compressed archive
>
> This patch prevents the above situation by requiring a larger space when looking
> for a random kernel base, so that existing logic can effectively avoids the
> overlap.
>
> Fixes: 82fa9637a2 ("x86, kaslr: Select random position from e820 maps")
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Junjie Mao <eternal.n08@gmail.com>
> [kees: switched to perl to avoid hex translation pain in mawk vs gawk]
> [kees: calculated overlap without relocs table]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
> This version updates the commit log only.
>
> Kees, please help review the documentation. Thanks!
>
> Best Regards
> Junjie Mao
[...]
> diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
> new file mode 100644
> index 000000000000..0b0b124d3ece
> --- /dev/null
> +++ b/arch/x86/tools/calc_run_size.pl
> @@ -0,0 +1,30 @@
> +#!/usr/bin/perl
> +#
> +# Calculate the amount of space needed to run the kernel, including room for
> +# the .bss and .brk sections.
> +#
> +# Usage:
> +# objdump -h a.out | perl calc_run_size.pl
> +use strict;
> +
> +my $mem_size = 0;
> +my $file_offset = 0;
> +
> +my $sections=" *[0-9]+ \.(?:bss|brk) +";
> +while (<>) {
> + if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
> + my $size = hex($1);
> + my $offset = hex($2);
> + $mem_size += $size;
> + if ($file_offset == 0) {
> + $file_offset = $offset;
> + } elsif ($file_offset != $offset) {
> + die ".bss and .brk lack common file offset\n";
> + }
> + }
> +}
> +
> +if ($file_offset == 0) {
> + die "Never found .bss or .brk file offset\n";
> +}
> +printf("%d\n", $mem_size + $file_offset);

Given that bss and brk are nobits (i.e. only ALLOC) sections, does
file_offset make sense as a load address.  This fails with gold:

$ git checkout v3.18-rc5
$ make  # with gold
[...]
..bss and .brk lack common file offset
..bss and .brk lack common file offset
..bss and .brk lack common file offset
..bss and .brk lack common file offset
  MKPIGGY arch/x86/boot/compressed/piggy.S
Usage: arch/x86/boot/compressed/mkpiggy compressed_file run_size
make[2]: *** [arch/x86/boot/compressed/piggy.S] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make: *** [bzImage] Error 2

In ld.bfd brk/bss file_offsets match, but they differ with ld.gold:

$ objdump -h vmlinux.ld
[...]
  0 .text         00818bb3  ffffffff81000000  0000000001000000  00200000  2**12
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
[...]
 26 .bss          000e0000  ffffffff81fe8000  0000000001fe8000  013e8000  2**12
                  ALLOC
 27 .brk          00026000  ffffffff820c8000  00000000020c8000  013e8000  2**0
                  ALLOC

$ objdump -h vmlinux.ld | perl arch/x86/tools/calc_run_size.pl
21946368
# aka 0x14ee000


$ objdump -h vmlinux.gold
[...]
  0 .text         00818bb3  ffffffff81000000  0000000001000000  00001000  2**12
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
[...]
 26 .bss          000e0000  ffffffff81feb000  0000000001feb000  00e90000  2**12
                  ALLOC
 27 .brk          00026000  ffffffff820cb000  00000000020cb000  00f70000  2**0
                  ALLOC
