Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731Ab3BOLqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:46:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:13574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3BOLqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:46:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,673,1355126400"; 
   d="scan'208";a="291617460"
Date: Fri, 15 Feb 2013 13:50:37 +0200
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
Subject: Re: [PATCH] i2c-designware: Interrupt sharing and SDA hold time
Message-ID: <20130215115037.GT20771@intel.com>
References: <1360923110-21692-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360923110-21692-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:11:50AM +0100, Christian Ruppert wrote:
> This patch implements interrupt sharing and SDA hold time configuration in
> the designware i2c driver. Both functions are enabled through platform data
> or device tree. Tested with Linux-3.8rc4 (Synopsys ARC port, see
> https://github.com/foss-for-synopsys-dwc-arc-processors/linux/commits/arc-3.8-baseline).
> 
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   18 ++++++++++
>  drivers/i2c/busses/i2c-designware-core.c           |    6 +++
>  drivers/i2c/busses/i2c-designware-core.h           |    2 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |   34 +++++++++++++++++++-
>  include/linux/i2c/i2c-designware.h                 |   13 +++++++
>  5 files changed, 72 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/i2c/i2c-designware.h
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> index e42a2ee..474386b 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -10,6 +10,12 @@ Recommended properties :
>  
>   - clock-frequency : desired I2C bus clock frequency in Hz.
>  
> +Optional properties :
> + - interrupts-shared : If this property is present, the interrupt line is
> +   considered shared with other devices.
> + - sda-hold-time : If this property is present, the register SDA_HOLD will
> +   be initialised with its value.
> +
>  Example :
>  
>  	i2c@f0000 {
> @@ -20,3 +26,15 @@ Example :
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
> +		interrupts-shared;
> +		clock-frequency = <400000>;
> +		sda-hold-time = <0x64>;
> +	};
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> index cbba7db..36ba0b5 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -34,6 +34,7 @@
>  #include <linux/io.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
> +#include <linux/i2c/i2c-designware.h>
>  #include "i2c-designware-core.h"
>  
>  /*
> @@ -66,6 +67,7 @@
>  #define DW_IC_STATUS		0x70
>  #define DW_IC_TXFLR		0x74
>  #define DW_IC_RXFLR		0x78
> +#define DW_IC_SDA_HOLD		0x7c
>  #define DW_IC_TX_ABRT_SOURCE	0x80
>  #define DW_IC_COMP_PARAM_1	0xf4
>  #define DW_IC_COMP_TYPE		0xfc
> @@ -309,6 +311,10 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>  	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
>  	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
>  
> +	/* Configure SDA Hold Time if required */
> +	if (dev->pdat_flags & I2C_DW_PDAT_FLAGS_SET_HOLDTIME)
> +		dw_writel(dev, dev->sda_hold_time, DW_IC_SDA_HOLD);

AFAIK, DW_IC_SDA_HOLD minimum value is 1 so you could just do:

	if (dev->sda_hold_time)
		dw_writel(dev, dev->sda_hold_time, DW_IC_SDA_HOLD);

Also should this be configurable for standard and fast modes both?
Something like sm_sda_hold_time and fm_sda_hold_time?

> +
>  	/* Configure Tx/Rx FIFO threshold levels */
>  	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
>  	dw_writel(dev, 0, DW_IC_RX_TL);
> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> index 9c1840e..ef20477 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -88,6 +88,8 @@ struct dw_i2c_dev {
>  	u32			master_cfg;
>  	unsigned int		tx_fifo_depth;
>  	unsigned int		rx_fifo_depth;
> +	u32			sda_hold_time;
> +	unsigned int		pdat_flags;
>  };
>  
>  #define ACCESS_SWAP		0x00000001
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 343357a..2ad2da3 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -34,11 +34,13 @@
>  #include <linux/sched.h>
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
> +#include <linux/of.h>
>  #include <linux/of_i2c.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/i2c/i2c-designware.h>
>  #include "i2c-designware-core.h"
>  
>  static struct i2c_algorithm i2c_dw_algo = {
> @@ -56,6 +58,28 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	struct i2c_adapter *adap;
>  	struct resource *mem, *ioarea;
>  	int irq, r;
> +	unsigned long irqf;
> +	struct i2c_designware_platform_data *pdat = pdev->dev.platform_data;
> +
> +	if ((!pdat) && pdev->dev.of_node) {
> +		struct device_node *node = pdev->dev.of_node;
> +
> +		pdat = kmalloc(sizeof(struct i2c_designware_platform_data),
> +				GFP_KERNEL);
> +		if (!pdat)
> +			return -ENOMEM;
> +
> +		pdat->flags = 0;
> +
> +		if (of_get_property(node, "interrupts-shared", NULL))
> +			pdat->flags |= I2C_DW_PDAT_FLAGS_SHARE_IRQ;
> +
> +		if (!of_property_read_u32(node, "sda-hold-time",
> +					&pdat->sda_hold_time))
> +			pdat->flags |= I2C_DW_PDAT_FLAGS_SET_HOLDTIME;
> +
> +		pdev->dev.platform_data = pdat;

I do not understand why you need a separate platform data at all? Can't you
do it in a same way than the ACPI code?

And this probably doesn't apply to the i2c/next branch because we added the
ACPI enumeration there.

> +	}
>  
>  	/* NOTE: driver uses the static register mapping */
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -120,12 +144,20 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
>  		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
>  	}
> +	dev->sda_hold_time = pdat->sda_hold_time;
> +	dev->pdat_flags = pdat->flags;
> +
>  	r = i2c_dw_init(dev);
>  	if (r)
>  		goto err_iounmap;
>  
>  	i2c_dw_disable_int(dev);
> -	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
> +
> +	irqf = IRQF_DISABLED;
> +	if (dev->pdat_flags & I2C_DW_PDAT_FLAGS_SHARE_IRQ)
> +		irqf |= IRQF_SHARED;

Please check Wolfram's i2c/next. This is set already there.

> +
> +	r = request_irq(dev->irq, i2c_dw_isr, irqf, pdev->name, dev);
>  	if (r) {
>  		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
>  		goto err_iounmap;
> diff --git a/include/linux/i2c/i2c-designware.h b/include/linux/i2c/i2c-designware.h
> new file mode 100644
> index 0000000..ea8192a
> --- /dev/null
> +++ b/include/linux/i2c/i2c-designware.h
> @@ -0,0 +1,13 @@
> +#ifndef __I2C_DESIGNWARE_H__
> +#define __I2C_DESIGNWARE_H__
> +
> +#include <linux/platform_device.h>
> +
> +struct i2c_designware_platform_data {
> +	unsigned int flags;
> +#define I2C_DW_PDAT_FLAGS_SHARE_IRQ    (1L<<0)
> +#define I2C_DW_PDAT_FLAGS_SET_HOLDTIME (1L<<1)
> +	u32          sda_hold_time;
> +};
> +
> +#endif /* __I2C_DESIGNWARE_H__ */
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
