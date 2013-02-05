Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3BECaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:30:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:34743 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3BECaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:30:16 -0500
Message-ID: <1360031367.14701.47.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Date: Tue, 05 Feb 2013 13:29:27 +1100
In-Reply-To: <201302041724.47331.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 17:24 +0000, Arnd Bergmann wrote:
> On Monday 04 February 2013, Michal Simek wrote:
> > >
> > > and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
> > > symbols in Kconfig based on the system you are building for.
> > 
> > Using CONFIG_FOO_BIG/LITTLE is not good because it is just another
> > Kconfig option.
> > You can easily detect it at runtime and for dedicated hw with fixed
> > endians you can just
> > handle it in the driver and don't care about global setting.
> 
> The configuration option should not be visible, so it's
> not something a user would have to worry about. It's just
> sometimes nicer to express the configuration of the platform
> in terms of Kconfig syntax than it is in C code if you have
> complex platform dependencies.

As long as you never have a case where both are needed at runtime...

> > > This of course gets further complicated if you require different
> > > accessors per architecture, like ARM wanting readl or ioread32
> > > and PowerPC wanting in_le32 for a little-endian SoC component.

powerpc should never "want" in_le32. ioread32 should work just as well.
in_le32 is historical stuff and is never required.
 
> > FYI: I have got two responses on linux-arch from Alan
> > "Set the pointers up and pass them as data with your platform device, that
> > way the function definitions are buried in your platform code where they
> > depend."
> > 
> > and Geert:
> > "Or embed a struct io_ops * in struct device, to be set up by the bus driver?
> > 
> > Wasn't David Hinds working on something like this in the context of PCMCIA
> > a few decades ago?"
> > 
> > Based on their suggestions one way can be to pass it through void *platform_data
> > which is probably not the best and then which make more sense to me is to extend
> > struct dev_archdata archdata to add there native read/write functions.
> > 
> > What do you think?
> 
> I worry a little about code size if we have a lot of drivers that go
> from one instruction to an indirect function call for each readl/writel.
> Using platform_data ss also something that does not work too well with
> device tree based platform configuration, which tries hard to leave
> all run-time configuration inside of the driver.

readl/writel and ioread32/iowrite32 should always be equivalent.

So it all boils down to whether your device has different endianness (it
should not, doing so is stupid ... but if it really does then make it a
runtime wrapper that chooses between ioread32 and ioread32be

Cheers,
Ben.



