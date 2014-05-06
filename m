Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaEFNgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:36:49 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38447 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796AbaEFNgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:36:46 -0400
Date: Tue, 6 May 2014 15:33:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 02/20] usb: ehci-orion: Add the optional PHY support
Message-ID: <20140506133341.GE6503@lunn.ch>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399335255-589-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:13:57AM +0200, Gregory CLEMENT wrote:
> This commit allows to use the PHY provided through the device tree. It
> will be useful for the Armada 375 SoCs. if no PHY is provided then the
> behavior of the driver is unchanged.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/ehci-orion.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
> index d6c19c37c76b..f6d9eb2e33cd 100644
> --- a/drivers/usb/host/ehci-orion.c
> +++ b/drivers/usb/host/ehci-orion.c
> @@ -15,6 +15,7 @@
>  #include <linux/clk.h>
>  #include <linux/platform_data/usb-ehci-orion.h>
>  #include <linux/of.h>
> +#include <linux/phy/phy.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/usb.h>
> @@ -46,6 +47,7 @@
>  
>  struct orion_ehci_hcd {
>  	struct clk *clk;
> +	struct phy *phy;
>  };
>  
>  static const char hcd_name[] = "ehci-orion";
> @@ -224,6 +226,18 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
>  	if (!IS_ERR(priv->clk))
>  		clk_prepare_enable(priv->clk);
>  
> +
> +	priv->phy = devm_phy_get(&pdev->dev, "usb");
> +	if (!IS_ERR(priv->phy)) {
> +		err = phy_init(priv->phy);
> +		if (err)
> +			goto err2;
> +
> +		err = phy_power_on(priv->phy);
> +		if (err)
> +			goto err3;
> +	}

Hi Gregory

What about EPROBE_DEFERRED?

     Andrew
