Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaHTJXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:23:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43251 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaHTJXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:23:05 -0400
Date: Wed, 20 Aug 2014 10:22:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "atull@opensource.altera.com" <atull@opensource.altera.com>
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "skuribay@pobox.com" <skuribay@pobox.com>,
        "Romain.Baeriswyl@abilis.com" <Romain.Baeriswyl@abilis.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH] i2c: designware: deduce speed mode from device tree
 setting
Message-ID: <20140820092257.GA21174@leverpostej>
References: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408479529-24249-1-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 09:18:49PM +0100, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Use the documented, but unimplemented "clock-frequency"
> Device Tree setting as a guide on whether to set the speed
> mode bits in DW_IC_CON to standard or fast i2c mode.
> 
> Previously, the driver was hardwired to fast mode.  Default
> to fast mode if the "clock-frequency" property is not present
> for backwards compatiblity.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  drivers/i2c/busses/i2c-designware-platdrv.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index bc87733..18cd3d9 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -122,7 +122,8 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	struct dw_i2c_dev *dev;
>  	struct i2c_adapter *adap;
>  	struct resource *mem;
> -	int irq, r;
> +	int irq, r, ret, speed = DW_IC_CON_SPEED_FAST;
> +	u32 bus_rate;
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
> @@ -167,6 +168,11 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		of_property_read_u32(pdev->dev.of_node,
>  				     "i2c-scl-falling-time-ns",
>  				     &dev->scl_falling_time);
> +
> +		ret = of_property_read_u32(pdev->dev.of_node,
> +					   "clock-frequency", &bus_rate);
> +		if (!ret && (bus_rate <= 100000))
> +			speed = DW_IC_CON_SPEED_STD;

This looks a bit odd.

If the device only supports two particular speeds why do we accept any
other speed in the clock-frequency property? Surely we should at least
warn that something was off?

Thanks,
Mark

>  	}
>  
>  	dev->functionality =
> @@ -177,7 +183,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		I2C_FUNC_SMBUS_WORD_DATA |
>  		I2C_FUNC_SMBUS_I2C_BLOCK;
>  	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
> -		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
> +		DW_IC_CON_RESTART_EN | speed;
>  
>  	/* Try first if we can configure the device from ACPI */
>  	r = dw_i2c_acpi_configure(pdev);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
