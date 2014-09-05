Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaIEMzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:55:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42970 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932187AbaIEMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:55:32 -0400
Date: Fri, 5 Sep 2014 13:51:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Robert Richter <robert.richter@caviumnetworks.com>,
        Robert Richter <rric@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Message-ID: <20140905125147.GC20164@leverpostej>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-2-git-send-email-rric@kernel.org>
 <20140905093239.GC30401@n2100.arm.linux.org.uk>
 <20140905104547.GT4703@rric.localhost>
 <20140905110552.GH30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905110552.GH30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:05:52PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 05, 2014 at 12:45:47PM +0200, Robert Richter wrote:
> > On 05.09.14 10:32:40, Russell King - ARM Linux wrote:
> > > On Fri, Sep 05, 2014 at 09:46:42AM +0200, Robert Richter wrote:
> > > > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > > > 
> > > > Increase maximum numbers of cpus to 32. This relates to current
> > > > maximal possible cpu number. Increasing this to 64 cpus will be a
> > > > separate patch not part of this enablement patches.
> > > > 
> > > > Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > > > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > > > ---
> > > >  arch/arm64/Kconfig | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > > index fd4e81a4e1ce..77fb82b0f684 100644
> > > > --- a/arch/arm64/Kconfig
> > > > +++ b/arch/arm64/Kconfig
> > > > @@ -134,6 +134,11 @@ source "kernel/Kconfig.freezer"
> > > >  
> > > >  menu "Platform selection"
> > > >  
> > > > +config ARCH_THUNDER
> > > > +	bool "Cavium Inc. Thunder SoC Family"
> > > > +	help
> > > > +	  This enables support for Cavium's Thunder Family of SoCs.
> > > > +
> > > >  config ARCH_VEXPRESS
> > > >  	bool "ARMv8 software model (Versatile Express)"
> > > >  	select ARCH_REQUIRE_GPIOLIB
> > > > @@ -256,6 +261,7 @@ config NR_CPUS
> > > >  	range 2 32
> > > >  	depends on SMP
> > > >  	# These have to remain sorted largest to smallest
> > > > +	default "32" if ARCH_THUNDER
> > > >  	default "8"
> > > 
> > > Why do you need ARCH_THUNDER?  If it's just to change this default,
> > 
> > No, we need it just to enable all our drivers on the SoC. We want to
> > enable the SoC by using defconfig + ARCH_THUNDER. As said in my other
> > mail, I put it here to be able to base all other thunder driver patch
> > sets on this initial base patch set. Otherwise this particular patch
> > and also the dtb patch need to be shipped with all other driver patch
> > sets. This might lead to duplicate submissions of the same patch.
> > 
> > With doing defconfig + ARCH_THUNDER we also want to enable the max
> > number of cpus that is currently supported. I only enable 32 cpus
> > since booting more cpus is untested. There might be problems at the 32
> > cpu boundary. Just setting it to 64 does not mean a kernel will
> > actually boot more than 32 cpus. But if it will be ack'ed, I would be
> > fine to set NR_CPUS to 32 or 64 in general and independent from
> > ARCH_THUNDER.
> > 
> > For simplicity I better drop setting NR_CPUS in this patch.
> 
> So, ARM64 will get a big long list of "config ARCH_foo" options just
> to stuff lots of broken select statements into the configuration.  Yes,
> this may have been the norm with ARM, but it's turned out to be more
> of a problem than a solution, especially as it keeps causing Kconfig
> warnings when things change in the rest of the kernel tree.

Agreed; this seems more pain than it is worth.

> The same is true with defconfigs - Linus threatened to delete all ARM
> defconfigs except one at one point.

IMO we should continue doing what we've done so far and make the ARM64
defconfig work on everything it can by default, no ARCH_* necessary.
That's what most people will build and test and we shouldn't get
platform-specific code (well, drivers) breaking the single image.

For the extreme configurations (really tiny or really big) custom
configuration being necessary is fine. That doesn't have to involve
ARCH_* config options.

If you want to build a custom config then you should have an idea of
what you need. ARCH_* options are only necessary if someone wants a
kernel tuned for a specific SoC but doesn't know anything about that
SoC.

Mark.
