Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbaGYP4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:56:10 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53239 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaGYP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:56:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Date: Fri, 25 Jul 2014 17:55 +0200
Message-ID: <5237362.DJsH7MtqlU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406285147.8530.13.camel@smile.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com> <5426556.OzZIXLrofJ@wuerfel> <1406285147.8530.13.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JugfA5WItu3gI40Yv0x6EVdpJJdVpkY/U4ooJUPvD5S
 UPD8wSVdbxwBR34QIQdO1hpEzAje65vulBsleE6F5XksYhG/D+
 6vV29+7fWPT7m55QOnDpI/tgpjKEbrTqn68r0xwGUHqHFjoJGI
 oXkTnmTk5Xwg+wTpXgB5PcFOHb+G9kkadjSgjiFAam9EwDbef0
 Kq4Ka8JiUaMXbFNL0kzcSuk8XpdcPkM/QOjN8VIsU2UBbjhHyl
 6yRyKcM3B6kZE+27Mz9kYT2nfWv4Dui1HLPlAhti43Jteh8O5w
 N4dI6CZrTaF8U8vfOtu7zwWrAkHI8Iajoz4WVYHvRvKw9eGV7c
 dAmyClhI5SGaA1FXDROw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2014 13:45:47 Andy Shevchenko wrote:
> On Fri, 2014-07-25 at 12:19 +0200, Arnd Bergmann wrote:
> > On Friday 25 July 2014 12:55:59 Mika Westerberg wrote:
> > > On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> > > > On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > > > > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> 
> []
> 
> > > Something like this?
> 
> Arnd, this dependency to certain DMA driver looks really bad.
> 
> If we go that way, can we split that part to [another] module and make
> it dependent to DW_DMAC?

I don't see what you gain from that. The PCI ID will tell you which DMA
engine is being used. The driver already hardcodes a slave_id based on
the PCI ID today, and the 

> Or shall we introduce a dmaengine type field in the platform data and
> dynamically choose proper filter-whatever-function to get the channel?

We already have an interface for this, in the form of
dma_request_slave_channel(), which takes a string identifier that
is used to look up all that information in either device tree or
ACPI. It wouldn't be unreasonable to add a third path in there
to handle hardcoded platform devices, but that's a lot of work.
Note that you still need to encode a reference to the dma engine
in some way to do this right. The current code (with or without Mika's
patch) will break as soon as you have multiple DMA engine devices.

The current plan I think is to convert all platforms to use DT
or ACPI so they get the right data from tables passed by the
platform. I'm a bit puzzled about why Intel wants to support the
non-ACPI non-DT case again. If we have to support this case anyway,
what good will ACPI do us on those platforms?

> > > Hock Leong / Chiaue Ee, are you able to check if this works on your BYT
> > > machines?
> 
> > What I think you got wrong here (by following my bad advice) is the master
> > number. Looking at the code for dw_dma, I think src_master needs to be '1'
> > for your driver.
> 
> On some SoCs we have up to 4 masters. It's blurry for me how the SPI
> should choose those masters. Currently it works fine, but I suspect
> there are [might be] performance issues.

I think it works because the dw-dma defaults to the values used by
the specific implementation in your hardware.

> What about AVR32 case? We have to fix drivers as well there.

which ones?

	Arnd
