Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3ENLDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:03:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:23899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab3ENLDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,670,1363158000"; 
   d="scan'208";a="313298736"
Date: Tue, 14 May 2013 14:07:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v7] i2c-designware: make SDA hold time configurable
Message-ID: <20130514110745.GA10906@intel.com>
References: <20130327084158.GB11010@ab42.lan>
 <1364373760-12469-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364373760-12469-1-git-send-email-christian.ruppert@abilis.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:59:54PM +0200, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Hi Wolfram,

What happened to this patch? I don't see it merged for 3.10.

The reason I'm asking is that I would like to add ACPI support for the SDA
hold time parameter analogous to the DT version.

Thanks.

> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   14 ++++++++++++++
>  drivers/i2c/busses/i2c-designware-core.c           |    5 +++++
>  drivers/i2c/busses/i2c-designware-core.h           |    1 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |    9 +++++++++
>  4 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> index e42a2ee..21fabe7 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -10,6 +10,9 @@ Recommended properties :
>  
>   - clock-frequency : desired I2C bus clock frequency in Hz.
>  
> +Optional properties :
> + - sda-hold-time : should contain the SDA hold time in nanoseconds.
> +
>  Example :
>  
>  	i2c@f0000 {
> @@ -20,3 +23,14 @@ Example :
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
> +		sda-hold-time = <300>;
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
> index 0ceb6e1..0a6e29b 100644
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
> @@ -136,6 +137,14 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(dev->clk);
>  
> +	if (pdev->dev.of_node) {
> +		u32 ht;
> +		u32 ic_clk = dev->get_clk_rate_khz(dev);
> +
> +		of_property_read_u32(pdev->dev.of_node, "sda-hold-time", &ht);
> +		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
> +	}
> +
>  	dev->functionality =
>  		I2C_FUNC_I2C |
>  		I2C_FUNC_10BIT_ADDR |
> -- 
> 1.7.1
> 
