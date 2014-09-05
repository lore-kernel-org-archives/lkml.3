Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaIEOFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:05:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60040 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaIEOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:05:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Fri, 05 Sep 2014 16:04:06 +0200
Message-ID: <7863371.EMkUuntQWU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905125147.GC20164@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org> <20140905110552.GH30401@n2100.arm.linux.org.uk> <20140905125147.GC20164@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:K96xeqT0Lyjcx1rUzdjIJ6QtM4UFNYIeWCAcwFQaMCD
 CFGaRYsgTixP8ZiTJwzAF3Gp2QuytqU7a2Qp0oJYvkUEBHX/nk
 wDupIKAtavR5BsMqJ8nvL+u04SDHAsrCT04SkRK+Let6kGdeXL
 ooPMN02NJHoHY4ELIDs2fr+3ii79ePVgvPVUXRzALH7txkubpA
 kNH0d/bp2TTdSESf/bp8qB+tOMz+ezgZ6PrHEkCLaA/8+PuSEW
 HdYA17Qo9iFp7wJ+ZKsq28PwcR29Hxj21UOCzdAbz8SUd/mPX+
 /zzNhd7YmJS1JCkesDnCTLmR7DVwpsXtpG+XprgV4de+AIIQ4S
 0CEUaSeeGy7bd2B5hFAg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 13:51:47 Mark Rutland wrote:
> On Fri, Sep 05, 2014 at 12:05:52PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 05, 2014 at 12:45:47PM +0200, Robert Richter wrote:
> > > On 05.09.14 10:32:40, Russell King - ARM Linux wrote:
> > > No, we need it just to enable all our drivers on the SoC. We want to
> > > enable the SoC by using defconfig + ARCH_THUNDER. As said in my other
> > > mail, I put it here to be able to base all other thunder driver patch
> > > sets on this initial base patch set. Otherwise this particular patch
> > > and also the dtb patch need to be shipped with all other driver patch
> > > sets. This might lead to duplicate submissions of the same patch.
> > > 
> > > With doing defconfig + ARCH_THUNDER we also want to enable the max
> > > number of cpus that is currently supported. I only enable 32 cpus
> > > since booting more cpus is untested. There might be problems at the 32
> > > cpu boundary. Just setting it to 64 does not mean a kernel will
> > > actually boot more than 32 cpus. But if it will be ack'ed, I would be
> > > fine to set NR_CPUS to 32 or 64 in general and independent from
> > > ARCH_THUNDER.
> > > 
> > > For simplicity I better drop setting NR_CPUS in this patch.
> > 
> > So, ARM64 will get a big long list of "config ARCH_foo" options just
> > to stuff lots of broken select statements into the configuration.  Yes,
> > this may have been the norm with ARM, but it's turned out to be more
> > of a problem than a solution, especially as it keeps causing Kconfig
> > warnings when things change in the rest of the kernel tree.
> 
> Agreed; this seems more pain than it is worth.

Lots of select statements indeed would be a problem, but I don't think
that is what Robert was suggesting.

> > The same is true with defconfigs - Linus threatened to delete all ARM
> > defconfigs except one at one point.
> 
> IMO we should continue doing what we've done so far and make the ARM64
> defconfig work on everything it can by default, no ARCH_* necessary.
> That's what most people will build and test and we shouldn't get
> platform-specific code (well, drivers) breaking the single image.

Right.

> For the extreme configurations (really tiny or really big) custom
> configuration being necessary is fine. That doesn't have to involve
> ARCH_* config options.
> 
> If you want to build a custom config then you should have an idea of
> what you need. ARCH_* options are only necessary if someone wants a
> kernel tuned for a specific SoC but doesn't know anything about that
> SoC.

A common pattern these days is to do dependencies like

arch/*/Kconfig:
	config ARCH_FOO
	bool "Enable support for Foo platform"
	help
	  ...


drivers/*/Kconfig
	config SUBSYS_FOO
	bool "SUBSYS driver for Foo"
	depends on ARCH_FOO || COMPILE_TEST
	depends on OF && REGULATOR && GENERIC_PHY # or whatever

That way we can enable everything in the defconfig, but someone
who likes to build a more specialized kernel can disable the
other platforms and won't get the drivers that are specific to
those.

I personally think this is a bit more verbose than what we need, but
I don't strongly object doing it that way.

The code size really should not matter much on ARM64 though: it's
unlikely we will see a lot of systems with less than a few gigabytes
of memory, and I expect that a generic kernel would be e.g. 6 MB
instead of 4 MB for a platform specific kernel.

	Arnd
