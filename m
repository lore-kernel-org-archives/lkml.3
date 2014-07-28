Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaG1Msw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:48:52 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54600 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaG1Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:48:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Date: Mon, 28 Jul 2014 14:47:56 +0200
Message-ID: <5712887.nI9VbeNx2r@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406545580.8530.28.camel@smile.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com> <5237362.DJsH7MtqlU@wuerfel> <1406545580.8530.28.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7CW/gemtctbipgVDLrBPBX8ViwCuRgnpCEm2xF70eJh
 Huw57t1wHrBaMGcPmyD6FeQ+462i94fAjhvZsGQHPdUfJZrxL8
 lE+HqqN4kZwJIpoopMzh9kmRCkrzHAq2VbkPvPlOIV52P9edYa
 vD8xHtblnfIRhCjgVGZEv06QM4CVFwH+T3lfW3mB952lA1ruq1
 LMEk3p/KhHxZ5S85nUQcyDebODGeYkTetHlYy72+xfh7weEav3
 tNjhPS1FJ0ZSUZOWQzAd36mgWVT9SN1sCEbPY0vLfBGHfL7k5Y
 iA6+40ggAkZLbccUwdjIqe9ZDRc2qWM3IWeO8/ZkkuqdNKUp6U
 Q5QP45KCDhAjpF8At+jM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 14:06:20 Andy Shevchenko wrote:
> On Fri, 2014-07-25 at 17:55 +0200, Arnd Bergmann wrote:
> > On Friday 25 July 2014 13:45:47 Andy Shevchenko wrote:
> > > On Fri, 2014-07-25 at 12:19 +0200, Arnd Bergmann wrote:
> > > > On Friday 25 July 2014 12:55:59 Mika Westerberg wrote:
> > > > > On Fri, Jul 25, 2014 at 12:07:14PM +0300, Mika Westerberg wrote:
> > > > > > On Fri, Jul 25, 2014 at 10:38:36AM +0200, Arnd Bergmann wrote:
> > > > > > > On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> > > 
> > > []
> > > 
> > > > > Something like this?
> > > 
> > > Arnd, this dependency to certain DMA driver looks really bad.
> > > 
> > > If we go that way, can we split that part to [another] module and make
> > > it dependent to DW_DMAC?
> > 
> > I don't see what you gain from that. The PC ID will tell you which DMA
> > engine is being used. The driver already hardcodes a slave_id based on
> > the PCI ID today, and the 
> 
> "...and the..."?

Sorry for missing that.

the slave ID only makes sense in combination with the master device
it is used in, so the dependency exists already.

> > > Or shall we introduce a dmaengine type field in the platform data and
> > > dynamically choose proper filter-whatever-function to get the channel?
> > 
> > We already have an interface for this, in the form of
> > dma_request_slave_channel(), which takes a string identifier that
> > is used to look up all that information in either device tree or
> > ACPI. It wouldn't be unreasonable to add a third path in there
> > to handle hardcoded platform devices, but that's a lot of work.
> > Note that you still need to encode a reference to the dma engine
> > in some way to do this right. The current code (with or without Mika's
> > patch) will break as soon as you have multiple DMA engine devices.
> 
> What about to keep PCI case still valid? We can pass struct pci_dev (or
> actual struct device) of DMA controller to filter proper device.

Yes, that would be best. IIRC you have a single PCI device that instantiates
both the SPI and the DMA engine as subdevices (I haven't looked at the
code again), so that information would be readily available.
 
> > > > What I think you got wrong here (by following my bad advice) is the master
> > > > number. Looking at the code for dw_dma, I think src_master needs to be '1'
> > > > for your driver.
> > > 
> > > On some SoCs we have up to 4 masters. It's blurry for me how the SPI
> > > should choose those masters. Currently it works fine, but I suspect
> > > there are [might be] performance issues.
> > 
> > I think it works because the dw-dma defaults to the values used by
> > the specific implementation in your hardware.
> 
> 
> 
> > > What about AVR32 case? We have to fix drivers as well there.
> 
> > which ones?
> 
> arch/avr32/mach-at32ap/at32ap700x.c:1332:at32_add_device_mci
> 
> It seems opaque for me if it's used anywhere.

It seems correct to me. This is the filter function used by atmel_mci:

static bool atmci_filter(struct dma_chan *chan, void *pdata)
{
        struct mci_platform_data *sl_pdata = pdata;
        struct mci_dma_data *sl;

        if (!sl_pdata)
                return false;

        sl = sl_pdata->dma_slave;
        if (sl && find_slave_dev(sl) == chan->device->dev) {
                chan->private = slave_data_ptr(sl);
                return true;
        } else {
                return false;
        }
}

It sets the dw_dma_slave information from  slave_data_ptr(sl) here,
and does not attempt to set a slave_id at all, the slave_config
call only sets the required fields.

Do you still see a problem here?

> Actually the defaults came from original driver for AVR32 case.
> 
> Regarding to DW DMA databook the AHB masters could be used each by any
> channel, though it depends on what AHB layer is bound to (and
> corresponding peripheral device).
> 
> Thus, like I said we might have the [minor] performance issues if we
> use, for example, two out of four masters.

I don't see how: We have four cases that I am aware of, and all seem
to handle this right:

a) request line and masters are all configured from device-tree.
b) request line is configured from ACPI, masters are autoconfigured
c) request line and masters are all configured from avr32/arm32
   platform data.
d) request line and masters are all configured from Bay Trail
   PCI ID (Implemented by Mika's patch)

The ACPI case could be extended if we ever get an ACPI based system
that has more than two masters.
In the other cases, the same source of information that configures
the request line also configures the masters, so it's up to the
system integration to pick the best setting.

	Arnd
