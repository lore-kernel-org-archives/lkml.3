Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaGQMUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:20:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42256 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932075AbaGQMUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:20:17 -0400
Date: Thu, 17 Jul 2014 13:20:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Chen <peter.chen@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140717122000.GV21766@n2100.arm.linux.org.uk>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <22032517.gk8PRUMaIU@wuerfel> <93903d5fdf85427bb8a418894540c122@BN1PR0301MB0772.namprd03.prod.outlook.com> <5456516.0fVZeXjF8k@wuerfel> <20140717111912.GA16025@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717111912.GA16025@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 07:19:15PM +0800, Peter Chen wrote:
> Currently, we are designing a generic driver, we don't know what's the
> hardware architecture, we are trying to find a solution how to set
> dma mask for all possible devices which will use this driver, Antoine's
> this patch is trying to cover this feature.
> 
> For example, 
> 
> Marvell Berlin doesn't need to set dma mask specific.
> http://marc.info/?l=linux-arm-kernel&m=140205228507045&w=2
> http://www.spinics.net/lists/linux-usb/msg110598.html

I can't make sense of those messages.

What are you saying - that ci_hdrc on Berlin does not use DMA at all?
Or that it doesn't care what the DMA mask is set to?

> Xilinx zynq needs to set dma mask as 0xFFFFFFF0
> http://marc.info/?l=linux-usb&m=140384129921706&w=2

Why?  The DMA mask does /not/ convey the DMA alignment requirements of
the transfers.  If you need it to be aligned to 16-bytes, then that's
something which is internal to the driver.  This is no different from
devices which require 32-bit alignment or 64-bit alignment.

You can't really expect the DMA subsystem to take care of that for you.
The DMA mask is about indicating what memory ranges are acceptable for
DMA, and not the alignment.

So, in this case, your DMA mask should be DMA_BIT_MASK(32), the same as
iMX.

However, if your driver does receive memory which is not appropriately
aligned, it is the driver's responsibility, not the DMA API, to deal
with that appropriately.

So, it sounds to me like:

- The DT code should be setting the DMA mask appropriately already.

- If the driver is using streaming DMA, should call:

	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
	if (err)
		handle error;

- If the driver is using coherent DMA only:

	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
	if (err)
		handle error;

- If the driver uses both coherent DMA and streaming DMA:

	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
	if (err)
		handle error;

Where the _bus_ has restrictions on the available memory (iow, the
higher address bits), these should be dealt with inside the DMA API.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
