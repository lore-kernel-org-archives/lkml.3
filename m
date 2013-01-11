Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3AKRRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:17:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44943 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3AKRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:17:43 -0500
Date: Fri, 11 Jan 2013 17:17:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/14] usb: phy: nop: Handle power supply regulator for
	the PHY
Message-ID: <20130111171726.GI23505@n2100.arm.linux.org.uk>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com> <1357836694-30788-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357836694-30788-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 06:51:24PM +0200, Roger Quadros wrote:
> We use "vcc" as the supply name for the PHY's power supply.
> The power supply will be enabled during .init() and disabled
> during .shutdown()
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/otg/nop-usb-xceiv.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
> index 163f972..1c6db10 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -33,11 +33,13 @@
>  #include <linux/usb/nop-usb-xceiv.h>
>  #include <linux/slab.h>
>  #include <linux/clk.h>
> +#include <linux/regulator/consumer.h>
>  
>  struct nop_usb_xceiv {
>  	struct usb_phy		phy;
>  	struct device		*dev;
>  	struct clk		*clk;
> +	struct regulator	*vcc;
>  };
>  
>  static struct platform_device *pd;
> @@ -70,6 +72,11 @@ static int nop_init(struct usb_phy *phy)
>  {
>  	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
>  
> +	if (nop->vcc) {
> +		if (regulator_enable(nop->vcc))
> +			dev_err(phy->dev, "Failed to enable power\n");
> +	}
> +
>  	if (nop->clk)
>  		clk_enable(nop->clk);
>  
> @@ -82,6 +89,11 @@ static void nop_shutdown(struct usb_phy *phy)
>  
>  	if (nop->clk)
>  		clk_disable(nop->clk);
> +
> +	if (nop->vcc) {
> +		if (regulator_disable(nop->vcc))
> +			dev_err(phy->dev, "Failed to disable power\n");
> +	}
>  }
>  
>  static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
> @@ -157,6 +169,12 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	nop->vcc = devm_regulator_get(&pdev->dev, "vcc");
> +	if (IS_ERR(nop->vcc)) {
> +		dev_dbg(&pdev->dev, "Error getting vcc regulator\n");
> +		nop->vcc = NULL;
> +	}

Is it really appropriate for drivers to do this kind of thing with
pointer-returning functions (I mean, setting the pointer to NULL on
error, rather than just using a test for IS_ERR() in the above
locations).  You are imposing driver-local assumptions on an API.

Practically it probably doesn't make much difference but given the
amount of mistakes that we have with IS_ERR_OR_NULL()...
