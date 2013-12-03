Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3LCIQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:16:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:51524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3LCIQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:16:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="437599170"
Date: Tue, 3 Dec 2013 10:15:56 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
Message-ID: <20131203081556.GA26423@xps8300>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:05:19PM +0800, Chris Ruehl wrote:
> @@ -154,6 +164,27 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
>  {
>  	int err;
>  
> +	if (nop->ulpi_vbus > 0) {
> +		unsigned int flags = 0;
> +
> +		if (nop->ulpi_vbus & 0x1)
> +			flags |= ULPI_OTG_DRVVBUS;
> +		if (nop->ulpi_vbus & 0x2)
> +			flags |= ULPI_OTG_DRVVBUS_EXT;
> +		if (nop->ulpi_vbus & 0x4)
> +			flags |= ULPI_OTG_EXTVBUSIND;
> +		if (nop->ulpi_vbus & 0x8)
> +			flags |= ULPI_OTG_CHRGVBUS;
> +
> +		nop->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, flags);
> +		if (!nop->ulpi) {
> +			dev_err(dev, "Failed create ULPI Phy\n");
> +			return -ENOMEM;
> +		}
> +		dev_dbg(dev, "Create ULPI Phy\n");
> +		nop->ulpi->io_priv =  nop->viewport;
> +	}

This is so wrong. You are registering one kind of usb phy driver from
an other. Change drivers/usb/phy/ulpi.c to be a platform device. The
whole flag system in it is pretty horrid. While you are at it, change
that so it sets the values based on boolean flags from OF properties
or platform data.

NAK for the whole set.


-- 
heikki
