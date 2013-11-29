Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3K2NXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:23:48 -0500
Received: from mx0.aculab.com ([213.249.233.131]:36155 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754858Ab3K2NXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:23:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems on OMAP4 Panda
Date: Fri, 29 Nov 2013 13:17:48 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B744D@saturn3.aculab.com>
In-Reply-To: <1385730118-26402-2-git-send-email-rogerq@ti.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems on OMAP4 Panda
Thread-Index: Ac7tAzPCcn9gJOAJTzGeTYHCtwbJ0wAATCGw
References: <1385730118-26402-1-git-send-email-rogerq@ti.com> <1385730118-26402-2-git-send-email-rogerq@ti.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Roger Quadros" <rogerq@ti.com>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
Cc: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <ljkenny.mailinglists@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Of Roger Quadros
> With u-boot 2013.10, USB devices are sometimes not detected
> on OMAP4 Panda. To make us independent of what bootloader does
> with the USB Host module, we must RESET it to get it to a known
> good state. This patch Soft RESETs the USB Host module.
...
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -43,14 +43,18 @@
>  /* UHH Register Set */
>  #define	OMAP_UHH_REVISION				(0x00)
>  #define	OMAP_UHH_SYSCONFIG				(0x10)
> -#define	OMAP_UHH_SYSCONFIG_MIDLEMODE			(1 << 12)
> +#define	OMAP_UHH_SYSCONFIG_MIDLEMASK			(3 << 12)
> +#define OMAP_UHH_SYSCONFIG_MIDLESHIFT			(12)

(tab/space issue)

Wouldn't it be clearer to define these in the opposite order with:
+#define	OMAP_UHH_SYSCONFIG_MIDLEMASK			(3 << OMAP_UHH_SYSCONFIG_MIDLESHIFT)

... 
> +static void omap_usbhs_rev1_reset(struct device *dev)
> +{
> +	struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
> +	u32 reg;
> +	unsigned long timeout;
> +
> +	reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
> +
> +	/* Soft Reset */
> +	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
> +		    reg | OMAP_UHH_SYSCONFIG_SOFTRESET);
> +
> +	timeout = jiffies + msecs_to_jiffies(100);
> +	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
> +			& OMAP_UHH_SYSSTATUS_RESETDONE)) {
> +		cpu_relax();
> +
> +		if (time_after(jiffies, timeout)) {
> +			dev_err(dev, "Soft RESET operation timed out\n");
> +			break;
> +		}
> +	}
> +
> +	/* Set No-Standby */
> +	reg &= ~OMAP_UHH_SYSCONFIG_MIDLEMASK;
> +	reg |= OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY
> +		<< OMAP_UHH_SYSCONFIG_MIDLESHIFT;
> +
> +	/* Set No-Idle */
> +	reg &= ~OMAP_UHH_SYSCONFIG_SIDLEMASK;
> +	reg |= OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE
> +		<< OMAP_UHH_SYSCONFIG_SIDLESHIFT;

Why not pass in the mask and value and avoid replicating the
entire function. I can't see any other significant differences,
the udelay(2) won't be significant.

I'm not sure of the context this code runs in, but if the reset
is likely to take a significant portion of the 100ms timeout
period, why not just sleep for a few ms between status polls.

	David




