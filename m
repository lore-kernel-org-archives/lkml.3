Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935966Ab3BOPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:50:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab3BOPuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:50:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
Date: Fri, 15 Feb 2013 15:49:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>, Pavel Machek <pavel@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Simon Horman <horms+renesas@verge.net.au>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <201302151105.14253.arnd@arndb.de> <20130215111306.GM17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130215111306.GM17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151549.55440.arnd@arndb.de>
X-Provags-ID: V02:K0:VAd7Xeb+rTCyBS91OzlsX2eag/Fe/5z24f1h6ab/gRw
 MjEotNvGhn+GUdqdb8kdF35Frgw4lPMZIZp2wPqO7v+wf6xyuC
 gDDbMSfkITalxTwbtjYxkvvYmCMHNFKOnNT6WurCum91xtcFqS
 aaIGxxZphx4UwDOwlqV3vMK6ig+tcgan6m4/wCMUt9wdt7BWkT
 ptz+0tN4+EwcYjLW7myQk6+Ne+k5Dc7uLFqriEZO0btURcDGfU
 YORLI5k6E0z4r/v/K0rW3AIC69xpOcO0zfKQ/sfcRbxsn1E1nO
 sp20rvyol8G39lm2HupWbp3USefx5lcBC/nitXSqdLtJHCSliN
 lUoYOEU8pNPfriBBqzHA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2013, Russell King - ARM Linux wrote:
> > The .text section alone is just short of 32MB.
> 
> I suspect when it does go over that, we'll see a lot more link time
> failures due to the 'bl' instructions failing to encode their PC relative
> jumps.  The only solution then will be to switch everything to use the
> less efficient long jumps (load address from literal pool, bx) which'll
> also need much of the asm changed.  That also brings up the question
> whether we want to penalize the kernel performance just to make
> allyesconfig work... I guess we can make it a compile time option, which
> of course allyesconfig will automatically enable.  I suspect we'll see
> a lot of people mistakenly enabling it too though.

I'm not too worried about people accidentally enabling such a build option,
at least if it's appropriately labeled as something that nobody should
need.

Changing the inline assembly however sounds like a big pain to do, which
would cause performance and size overhead as well as regressions in
rarely executed code when we get it wrong. I've tried rebulding
the allyesconfig kernel with -O3 -funroll-all-loops to make it even
bigger on purpose, and got these errors:

arch/arm/kernel/built-in.o:(.fixup+0x8): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x10): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x18): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x20): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x28): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x30): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x38): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x40): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x48): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x50): relocation truncated to fit: R_ARM_JUMP24 against `.text'
arch/arm/kernel/built-in.o:(.fixup+0x58): additional relocation overflows omitted from the output

so the .fixup section is completely out of reach of the start of the .text section.

The size output for the partial link of vmlinux.o is

section                     size         addr
.head.text                   492   3221258240
.text                   43889568   3221258752
.text.head                     8            0
.rodata                 11020608         4096
__bug_table               138636     11024704
.pci_fixup                     0     11163340
.builtin_fw                  684     11163340
.rio_ops                       0     11164024
__ksymtab                  53424     11164024
__ksymtab_gpl              43560     11217448
__ksymtab_unused               0     11261008
__ksymtab_unused_gpl           0     11261008
__ksymtab_gpl_future           0     11261008
__kcrctab                  26712     11261008
__kcrctab_gpl              21780     11287720
__kcrctab_unused               0     11309500
__kcrctab_unused_gpl           0     11309500
__kcrctab_gpl_future           0     11309500
__ksymtab_strings         251888     11309500
__param                    33104     11561388
__modver                    1284     11594492
__ex_table                  6288     11595776
.ARM.unwind_idx           907888     11602064
.ARM.unwind_tab          1362276     12509952
.notes                        36     13872228
.init.text                685436     13873152
.exit.text                124324     14558588
.init.arch.info             5396     14682912
.init.tagtable                72     14688308
.init.smpalt                 952     14688380
.init.pv_table              2232     14689332
.init.data                649164     14691568
.exit.data                   120     15340732
.data..percpu            1460032     15343616
.data                    3370676     16809984
.tcm_start                   332     20180660
.text_itcm                     0   4294836224
.dtcm_start                    0     20180992
.data_dtcm                     0   4294868992
.tcm_end                       0     20180992
.bss                     8007852     20180992
.comment                  314424            0
.ARM.attributes               50            0
.debug_line             19185565            0
.debug_info             61757649            0
.debug_abbrev            5835457            0
.debug_aranges            299416            0
.debug_ranges           10482064            0
.debug_frame             4601768            0
.debug_str              37433732            0
.debug_loc              45578206            0
Total                  257553155

I had the idea that turning off THUMB2 support in allyesconfig would help,
but then I found that it's already disabled unlike what I claimed earlier,
because ARMv6 support is enabled alongside ARMv7, so we are still screwed.

Also, with the size of the kernel binary growing, it may just be a
matter of time until this is not just a problem for artificial cases
like allyesconfig, but also for something that users will actually
want to run.

IIRC, 10 years ago, half a megabyte seemed like a reasonable size
for a kernel binary, while today 5 megabyte are not out of the
ordinary on ARM. If the trend continues the same way, we might
have users complaining about 32 megabyte kernels in 5-7 years from
now, unless everybody is using 64-bit by then ;-)

	Arnd
