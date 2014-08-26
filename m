Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866AbaHZKKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:10:23 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62364 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934540AbaHZKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: David Laight <David.Laight@aculab.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Andrew Bresticker <abrestic@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Tue, 26 Aug 2014 12:04:18 +0200
Message-ID: <4609609.i9jPXymFJZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17481234@AcuExch.aculab.com>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <20140826065729.GC15573@ulmo> <063D6719AE5E284EB5DD2968C1650D6D17481234@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9oe4QQ9GxSWGBRibBDghVEoPFifubn7XyhcknvQ7Czo
 TNATTp+XG+NATZ0mouK4A+5+BwfYPsM+OLbeNJcJqZvtBsMGfC
 Djkw7KaiOb17DekV4CEHfdsT2Tku+ZRziDGumjuu3Iup4WNWS/
 lF7NmlNFkdXh6v0pWTWaaRJhGs5RE9qzIz/TmToyOB17Cd9tgl
 hTr+aGGIi51y3btU11P+rSpm1Yj/gSzoTBzhoqBUwHHHohsXP4
 uO22y8rsUwgj26YFyb4uI9L5HwFlb2MxKQXAMxMs+/04mMEm+d
 a6C3HgHIIaVuRBAPjLNhcTfKFevsi5qEXbCNVFfg8wh26PNZQ4
 gc/a6jTkYIY+swj1oLsg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2014 08:54:53 David Laight wrote:
> From: Thierry Reding
> ...
> > > Is _nocache required? I don't see other drivers using it. I assume there's
> > > nothing special about the mbox registers.
> > 
> > Most drivers should be using devm_ioremap_resource() which will use the
> > _nocache variant of devm_ioremap() when appropriate. Usually the region
> > will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> > remapped uncached.
> 
> A related question:
> Is there any way for a driver to force that part of a PCIe BAR be mapped
> through the data cache even when the BAR isn't actually marked cacheable?

No. BARs are not actually marked cacheable anyway, except for the ROM
BAR, which we tend to not use.

Some architectures don't even allow any caching of PCI memory ranges,
so we have no architecture independent API for that.

It's possible that ioremap_cache() works on x86 and/or ARM if you call
it manually on the physical address (rather than using a resource
API).

> Some hardware has address regions (which might not be an entire BAR)
> that are actually memory and mapping through the data cache will
> generate longer PCIe transfers [1].
> Clearly the driver will have to be very careful about cache flushes
> and invalidates to make this work.

Some framebuffer drivers use writethrough mappings, but those again
are only available on few architectures. vesafb uses ioremap_cache,
but this works because the memory is in system RAM and not on PCI.

	Arnd
