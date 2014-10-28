Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaJ1PdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:33:02 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56469 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaJ1Pco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:32:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] ARM: allow errata and XIP options to be enabled without ARCH_MULTIPLATFORM_STRICT
Date: Tue, 28 Oct 2014 16:32:10 +0100
Message-ID: <1934157.clviKoL2bZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028150521.GK27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <1831362.dUvM0VHfPi@wuerfel> <20141028150521.GK27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ifashKwfT79rgJ8h3CSB/ftLRqXOkx1a/Eg1NSqwLIh
 9Y53lEcBxZapLQ8eaoxwrL8bjlDcaYxche/pXQr4yLy+SzxdNj
 17DbvVjN1LngNzgfXnao4KpDpi0mLFSjaDpCdsVD05Uxzg7Fd4
 RkaBmm1xWtoSss5egJ6Wy1BYpuIDn8SOtGThu7rR/iRbqVwKAL
 h1PTVclT/9JMPfpMwpFsfdBFEdQ5Ewiec6e7vbDxsBA6A6fC2e
 9DP+950Kc0J1X31nqsrLPNuSNNlfD6nAiSLGDaJ9R5UmDLXbcx
 2subslXJX+fglaHkSC3HkZEhMfWUUvU3VAgJ2DAJCU2PNZx1G7
 cHKwSPo+wmSSlx9Vxroc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 15:05:21 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 03:50:31PM +0100, Arnd Bergmann wrote:
> > That would solve the problem for V7M, but I also don't see a reason
> > to disallow XIP_KERNEL on a platform that depends on ARCH_MULTIPLATFORM.
> > 
> > The main problem is that any ARMv4/v5 platform that currently uses
> > XIP_KERNEL breaks when we do a conversion to ARCH_MULTIPLATFORM, and
> > I think that is bad.
> > 
> > The same applies to ZBOOT_ROM, which we should probably treat the
> > same way here. An example for that is the Renesas SH-Mobile SH7372 that
> > can boot directly from MMC. I really want Renesas to convert
> > all of their SH-Mobile machines to multiplatform, just like all other
> > ARMv7 platforms. There is nothing preventing you from running a
> > multiplatform kernel on SH7372 as long as you don't want to load the
> > kernel from MMC without a proper bootloader. I also don't see a reason
> > to take out that feature just because they are migrating to multiplatform
> > (there may or may not be other reasons to deprecate this feature, but that
> > is a different matter). At the moment SH-Mobile can be built either
> > as a standalone platform or as multiplatform, but even now you can build
> > a kernel that uses CONFIG_ZBOOT_ROM_MMCIF and will only ever work on
> > SH7372 but includes all other shmobile targets as well.
> > 
> > I don't see anything wrong with that, and I would like to see this
> > keep working when SH7372 is part of ARCH_MULTIPLATFORM, but at the
> > same time think it's good to have ARCH_MULTIPLATFORM_STRICT to prevent
> > this from being selected for a kernel that is supposed to run everywhere.
> 
> What you're asking for is a multiplatform kernel which can't be run on
> multiple platforms.  Think about that for a while.
> 
> If you're going to be building an ARMv5 XIP kernel, then it needs to only
> include support for the ARMv5 SoC which you are targetting.  It's no good
> to think "oh, we can then include other ARMv5 SoCs too" - you can, but
> the kernel will never run there.
> 
> That's where the pre-multiplatform setup works well - it ensures that the
> correct dependencies are there.  What we need to do is to combine these
> two properly such that if you want to build with a feature which limits
> you to one SoC, then the kernel configuration limits you to exactly that.
> That's not done by making some magic Kconfig option which disables a load
> of dependencies but still lets you chuck lots of useless stuff in together.

Part of the underlying problem here is really that Kconfig isn't able
to express the set of dependencies. It already fails to do that for
a platform that supports multiple boards and you want to build an XIP
kernel for one of the boards.

What you would want to express is that either

- as soon as XIP_KERNEL is set, you can only enable boards that have
  the exact same ROM address for running the kernel from (usually
  just one board), or

- the XIP_KERNEL option disappears when you enable multiple boards
  that are mutually incompatible whenever XIP is enabled.

We don't do either at the moment, and I've tried to come up with
a way to express this in Kconfig and haven't found one. Allowing
the multiple mach-* directories to behave the same way as multiple
boards in a single platform do today is not a fundamental change,
but more a consequence of generally being able to build them together.

> In any case, the thought of an XIP kernel with an allmodconfig config
> rather misses one of the fundamental problems with XIP multiplatform.

I never said anything about running an XIP kernel with allmodconfig,
or even an XIP kernel with more than one platform enabled. What I want
is to be able to turn on XIP_KERNEL in a configuration that has exactly
one machine enabled, but not requiring that machine to have a separate
entry in the "ARM system type" choice statement.

The fact that it allows one to also set silly configurations is unfortunate,
but there are lots of silly configurations that one can enable today.

> If you /ever/ want to write to the flash which the XIP kernel is contained,
> you must move the interrupt handling code out into RAM, so that when an
> interrupt happens, you can talk to the flash chip to make the kernel
> readable again.  That takes *all* of the initial interrupt handling code
> and data into RAM.
>
> What that means is that our current IRQ multi-handler solution doesn't
> work there - and we need a set of platform specific assembly fragments
> to do this.

This would be imply ARCH_MTD_XIP, which is currently not allowed for
anything that is part of ARCH_MULTIPLATFORM, and this patch doesn't
change that. If we ever want to allow it, I think you are right
that it would require significant extra work for abstracting xip_irqpending,
xip_currtime, xip_elapsed_since and xip_cpu_idle to build with more
than one platform enabled.

> As I said previously, there's also the complexity in setting up the XIP
> mappings in the assembly code, which takes quite an amount of knowledge
> of the physical memory layout on the SoC.
> 
> Frankly, I think the idea of XIP and multiplatform is a pipedream.

What about MMU-less systems then? The underlying problem is similar:
when we converted ARCH_VEXPRESS to multiplatform, we lost the ability
to run the Cortex-R4 tiles, or to run the ARMv7-A tiles with the MMU
disabled, which apparently were either working out of the box, or
required only a small set of patches on top.

	Arnd
