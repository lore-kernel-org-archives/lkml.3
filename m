Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbbAFSFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:05:49 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47532 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755800AbbAFSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:05:47 -0500
Date: Tue, 6 Jan 2015 18:05:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Santosh Shilimkar <ssantosh@kernel.org>,
        Peter =?iso-8859-1?Q?K=FCmmel?= <syntheticpp@gmx.net>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: omap-intc: fix legacy DMA regression
Message-ID: <20150106180532.GO11502@n2100.arm.linux.org.uk>
References: <20150106123830.GD30544@fuloong-minipc.musicnaut.iki.fi>
 <1420563093-26026-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420563093-26026-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:51:33AM -0600, Felipe Balbi wrote:
> +	/*
> +	 * FIXME legacy OMAP DMA driver sitting under arch/arm/plat-omap/dma.c
> +	 * depends is still not ready for linear IRQ domains; because of that
> +	 * we need to temporarily "blacklist" OMAP2 and OMAP3 devices from using
> +	 * linear IRQ Domain until that driver is finally fixed.

"finally fixed" or finally killed off like it really needs to be, once
all users of it are killed.

We've been trying to do this for, what, three years now... I finally
pushed a WARN_ON() into that code to make it obvious to anyone who
uses omap_request_dma() that they really need to update their code.

Here's the list of references to that symbol which *still* need to be
fixed so that we can kill the legacy DMA driver:

drivers/media/platform/omap/omap_vout_vrfb.c:   ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
drivers/media/platform/omap3isp/isphist.c:              ret = omap_request_dma(OMAP24XX_DMA_NO_DEVICE, "DMA_ISP_HIST",
drivers/media/platform/soc_camera/omap1_camera.c:       err = omap_request_dma(OMAP_DMA_CAMERA_IF_RX, DRIVER_NAME,
drivers/mtd/onenand/omap2.c:            r = omap_request_dma(0, pdev->dev.driver->name,
drivers/usb/gadget/udc/omap_udc.c:              status = omap_request_dma(dma_channel,
drivers/usb/gadget/udc/omap_udc.c:              status = omap_request_dma(dma_channel,
drivers/usb/musb/tusb6010_omap.c:               ret = omap_request_dma(chdat->sync_dev, dev_name,
drivers/usb/musb/tusb6010_omap.c:               ret = omap_request_dma(tusb_dma->sync_dev, "TUSB shared",

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
