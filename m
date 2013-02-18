Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3BRKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:53:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:44204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3BRKxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:53:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,686,1355126400"; 
   d="scan'208";a="203521213"
Date: Mon, 18 Feb 2013 12:57:42 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v2] i2c-designware: make SDA hold time configurable
Message-ID: <20130218105742.GK20771@intel.com>
References: <20130215164937.GV20771@intel.com>
 <1361182467-19184-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361182467-19184-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 11:14:27AM +0100, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
> It was tested on a hybrid of i2c/next and arc-3.8-baseline (see
> https://github.com/foss-for-synopsys-dwc-arc-processors/linux/commits/arc-3.8-baseline) since our platform is ARC based and this architecture is not yet
> supported by i2c/next.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Looks good but I have still one minor comment. See below.

> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   15 +++++++++++++++
>  drivers/i2c/busses/i2c-designware-core.c           |    5 +++++
>  drivers/i2c/busses/i2c-designware-core.h           |    1 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |    8 ++++++++
>  4 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> index e42a2ee..fb2eac8 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -10,6 +10,10 @@ Recommended properties :
>  
>   - clock-frequency : desired I2C bus clock frequency in Hz.
>  
> +Optional properties :
> + - sda-hold-time : If this property is present, the register SDA_HOLD will
> +   be initialised with its value.
> +
>  Example :
>  
>  	i2c@f0000 {
> @@ -20,3 +24,14 @@ Example :
>  		interrupts = <11>;
>  		clock-frequency = <400000>;
>  	};
> +
> +	i2c@1120000 {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "snps,designware-i2c";
> +		reg = <0x1120000 0x1000>;
> +		interrupt-parent = <&ictl>;
> +		interrupts = <12 1>;
> +		clock-frequency = <400000>;
> +		sda-hold-time = <0x64>;
> +	};
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> index 94fd818..ba40e14 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -67,6 +67,7 @@
>  #define DW_IC_STATUS		0x70
>  #define DW_IC_TXFLR		0x74
>  #define DW_IC_RXFLR		0x78
> +#define DW_IC_SDA_HOLD		0x7c
>  #define DW_IC_TX_ABRT_SOURCE	0x80
>  #define DW_IC_COMP_PARAM_1	0xf4
>  #define DW_IC_COMP_TYPE		0xfc
> @@ -310,6 +311,10 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>  	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
>  	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
>  
> +	/* Configure SDA Hold Time if required */
> +	if (dev->sda_hold_time)
> +		dw_writel(dev, dev->sda_hold_time, DW_IC_SDA_HOLD);
> +
>  	/* Configure Tx/Rx FIFO threshold levels */
>  	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
>  	dw_writel(dev, 0, DW_IC_RX_TL);
> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> index 9c1840e..33dfec3 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -88,6 +88,7 @@ struct dw_i2c_dev {
>  	u32			master_cfg;
>  	unsigned int		tx_fifo_depth;
>  	unsigned int		rx_fifo_depth;
> +	u32			sda_hold_time;
>  };
>  
>  #define ACCESS_SWAP		0x00000001
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index d2a33e9..9cb0100 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -34,6 +34,7 @@
>  #include <linux/sched.h>
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
> +#include <linux/of.h>
>  #include <linux/of_i2c.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm.h>
> @@ -136,6 +137,13 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(dev->clk);
>  
> +	if (pdev->dev.of_node) {
> +		if (of_property_read_u32(pdev->dev.of_node, "sda-hold-time",
> +						&dev->sda_hold_time))
> +			dev->sda_hold_time = 0;
> +	} else
> +		dev->sda_hold_time = 0;

You don't need to explicitly set this to 0 because the dev object is
allocated using kzalloc() which already zeroes out the whole structure.
