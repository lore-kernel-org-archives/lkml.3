Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaFFKyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:54:14 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43783 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFFKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:54:12 -0400
Message-ID: <53919DCE.1050708@gmail.com>
Date: Fri, 06 Jun 2014 12:54:06 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] usb: phy: add the Berlin USB PHY driver
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com> <1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1401983326-19205-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 05:48 PM, Antoine Ténart wrote:
> Add the driver driving the Marvell Berlin USB PHY. This allows to
> initialize the PHY and to use it from the USB driver later.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   drivers/usb/phy/Kconfig          |   9 ++
>   drivers/usb/phy/Makefile         |   1 +
>   drivers/usb/phy/phy-berlin-usb.c | 223 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 233 insertions(+)
>   create mode 100644 drivers/usb/phy/phy-berlin-usb.c
>
[...]
> diff --git a/drivers/usb/phy/phy-berlin-usb.c b/drivers/usb/phy/phy-berlin-usb.c
> new file mode 100644
> index 000000000000..79416668a71b
> --- /dev/null
> +++ b/drivers/usb/phy/phy-berlin-usb.c
> @@ -0,0 +1,223 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + * Jisheng Zhang <jszhang@marvell.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/usb/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>

nit: keep above alphabetically sorted.

> +#define USB_PHY_PLL		0x04
> +#define USB_PHY_PLL_CONTROL	0x08
> +#define USB_PHY_TX_CTRL0	0x10
> +#define USB_PHY_TX_CTRL1	0x14
> +#define USB_PHY_TX_CTRL2	0x18
> +#define USB_PHY_RX_CTRL		0x20
> +#define USB_PHY_ANALOG		0x34
> +
> +/* USB_PHY_PLL */
> +#define CLK_REF_DIV(x)		((x) << 4)
> +#define FEEDBACK_CLK_DIV(x)	((x) << 8)
> +
> +/* USB_PHY_PLL_CONTROL */
> +#define CLK_STABLE		(0x1 << 0)
> +#define PLL_CTRL_PIN		(0x1 << 1)
> +#define PLL_CTRL_REG		(0x1 << 2)
> +#define PLL_ON			(0x1 << 3)
> +#define PHASE_OFF_TOL_125	(0x0 << 5)
> +#define PHASE_OFF_TOL_250	(0x1 << 5)
> +#define KVC0_CALIB		(0x0 << 9)
> +#define KVC0_REG_CTRL		(0x1 << 9)
> +#define KVC0_HIGH		(0x0 << 10)
> +#define KVC0_LOW		(0x3 << 10)
> +#define CLK_BLK_EN		(0x1 << 13)

BIT() for the single bit flags above and below.

> +/* USB_PHY_TX_CTRL0 */
> +#define EXT_HS_RCAL_EN		(0x1 << 3)
> +#define EXT_FS_RCAL_EN		(0x1 << 4)
> +#define IMPCAL_VTH_DIV(x)	((x) << 5)
> +#define EXT_RS_RCAL_DIV(x)	((x) << 8)
> +#define EXT_FS_RCAL_DIV(x)	((x) << 12)
> +
> +/* USB_PHY_TX_CTRL1 */
> +#define TX_VDD15_14		(0x0 << 4)
> +#define TX_VDD15_15		(0x1 << 4)
> +#define TX_VDD15_16		(0x2 << 4)
> +#define TX_VDD15_17		(0x3 << 4)
> +#define TX_VDD12_VDD		(0x0 << 6)
> +#define TX_VDD12_11		(0x1 << 6)
> +#define TX_VDD12_12		(0x2 << 6)
> +#define TX_VDD12_13		(0x3 << 6)
> +#define LOW_VDD_EN		(0x1 << 8)
> +#define TX_OUT_AMP(x)		((x) << 9)
> +
> +/* USB_PHY_TX_CTRL2 */
> +#define TX_CHAN_CTRL_REG(x)	((x) << 0)
> +#define DRV_SLEWRATE(x)		((x) << 4)
> +#define IMP_CAL_FS_HS_DLY_0	(0x0 << 6)
> +#define IMP_CAL_FS_HS_DLY_1	(0x1 << 6)
> +#define IMP_CAL_FS_HS_DLY_2	(0x2 << 6)
> +#define IMP_CAL_FS_HS_DLY_3	(0x3 << 6)
> +#define FS_DRV_EN_MASK(x)	((x) << 8)
> +#define HS_DRV_EN_MASK(x)	((x) << 12)
> +
> +/* USB_PHY_RX_CTRL */
> +#define PHASE_FREEZE_DLY_2_CL	(0x0 << 0)
> +#define PHASE_FREEZE_DLY_4_CL	(0x1 << 0)
> +#define ACK_LENGTH_8_CL		(0x0 << 2)
> +#define ACK_LENGTH_12_CL	(0x1 << 2)
> +#define ACK_LENGTH_16_CL	(0x2 << 2)
> +#define ACK_LENGTH_20_CL	(0x3 << 2)
> +#define SQ_LENGTH_3		(0x0 << 4)
> +#define SQ_LENGTH_6		(0x1 << 4)
> +#define SQ_LENGTH_9		(0x2 << 4)
> +#define SQ_LENGTH_12		(0x3 << 4)
> +#define DISCON_THRESHOLD_260	(0x0 << 6)
> +#define DISCON_THRESHOLD_270	(0x1 << 6)
> +#define DISCON_THRESHOLD_280	(0x2 << 6)
> +#define DISCON_THRESHOLD_290	(0x3 << 6)
> +#define SQ_THRESHOLD(x)		((x) << 8)
> +#define LPF_COEF(x)		((x) << 12)
> +#define INTPL_CUR_10		(0x0 << 14)
> +#define INTPL_CUR_20		(0x1 << 14)
> +#define INTPL_CUR_30		(0x2 << 14)
> +#define INTPL_CUR_40		(0x3 << 14)
> +
> +/* USB_PHY_ANALOG */
> +#define ANA_PWR_UP		(0x1 << 1)
> +#define ANA_PWR_DOWN		(0x1 << 2)
> +#define V2I_VCO_RATIO(x)	((x) << 7)
> +#define R_ROTATE_90		(0x0 << 10)
> +#define R_ROTATE_0		(0x1 << 10)
> +#define MODE_TEST_EN		(0x1 << 11)
> +#define ANA_TEST_DC_CTRL(x)	((x) << 12)
> +
> +#define to_berlin_phy_priv(p)	container_of((p), struct berlin_phy_priv, phy)
> +
> +struct berlin_phy_priv {
> +	void __iomem		*base;
> +	struct usb_phy		phy;
> +	struct reset_control	*rst_ctrl;
> +	int			pwr_gpio;

Is the GPIO used for USB power? If so, we should not rely on
GPIO at all but use regulator API. Thinking of Chromecast which
is externally powered over USB, there will be no regulator nor
GPIO at all.

> +};
> +
> +static int berlin_phy_init(struct usb_phy *phy)
> +{
> +	struct berlin_phy_priv *priv = to_berlin_phy_priv(phy);
> +	int ret;
> +
> +	reset_control_reset(priv->rst_ctrl);
> +
> +	writel(CLK_REF_DIV(0xc) | FEEDBACK_CLK_DIV(0x54),
> +	       priv->base + USB_PHY_PLL);

@Jisheng: IIRC the dividers above are different for BG2? Can you please
evaluate?

> +	writel(CLK_STABLE | PLL_CTRL_REG | PHASE_OFF_TOL_250 | KVC0_REG_CTRL |
> +	       CLK_BLK_EN, priv->base + USB_PHY_PLL_CONTROL);
> +	writel(V2I_VCO_RATIO(0x5) | R_ROTATE_0 | ANA_TEST_DC_CTRL(0x5),
> +	       priv->base + USB_PHY_ANALOG);
> +	writel(PHASE_FREEZE_DLY_4_CL | ACK_LENGTH_16_CL | SQ_LENGTH_12 |
> +	       DISCON_THRESHOLD_260 | SQ_THRESHOLD(0xa) | LPF_COEF(0x2) |
> +	       INTPL_CUR_30, priv->base + USB_PHY_RX_CTRL);
> +
> +	writel(TX_VDD12_13 | TX_OUT_AMP(0x3), priv->base + USB_PHY_TX_CTRL1);
> +	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4),
> +	       priv->base + USB_PHY_TX_CTRL0);
> +
> +	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4) |
> +	       EXT_FS_RCAL_DIV(0x2), priv->base + USB_PHY_TX_CTRL0);
> +
> +	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4),
> +	       priv->base + USB_PHY_TX_CTRL0);
> +	writel(TX_CHAN_CTRL_REG(0xf) | DRV_SLEWRATE(0x3) | IMP_CAL_FS_HS_DLY_3 |
> +	       FS_DRV_EN_MASK(0xd), priv->base + USB_PHY_TX_CTRL2);
> +
> +	ret = gpio_direction_output(priv->pwr_gpio, 0);

As mentioned above, this should be using regulator API. And also, if
there is no dummy regulator allowed, it should be optional.

> +	if (ret)
> +		return ret;
> +
> +	gpio_set_value(priv->pwr_gpio, 1);
> +
> +	return 0;
> +}
> +
> +static void berlin_phy_shutdown(struct usb_phy *phy)
> +{
> +	struct berlin_phy_priv *priv = to_berlin_phy_priv(phy);
> +
> +	gpio_set_value(priv->pwr_gpio, 0);
> +}
> +
> +static int berlin_phy_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct berlin_phy_priv *priv;
> +	struct resource *res;
> +	int ret, gpio;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	priv->rst_ctrl = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(priv->rst_ctrl)) {
> +		ret = PTR_ERR(priv->rst_ctrl);
> +		dev_err(&pdev->dev, "cannot get reset controller: %d\n", ret);

Hmm, considering a non arch_init call registered reset driver, it does
also spit out an error for -EPROBE_DEFER, does it?

> +		return ret;
> +	}
> +
> +	gpio = of_get_named_gpio(np, "power-gpio", 0);
> +	if (!gpio_is_valid(gpio))
> +		return gpio;
> +
> +	ret = gpio_request(gpio, "power-gpio");
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot request GPIO %d", gpio);
> +		return ret;
> +	}
> +	priv->pwr_gpio = gpio;
> +
> +	priv->phy.io_priv = priv->base;
> +	priv->phy.dev = &pdev->dev;
> +	priv->phy.label = "phy-berlin-usb";
> +	priv->phy.init = berlin_phy_init;
> +	priv->phy.shutdown = berlin_phy_shutdown;
> +	priv->phy.type = USB_PHY_TYPE_USB2;
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	return usb_add_phy_dev(&priv->phy);
> +}
> +
> +static const struct of_device_id phy_berlin_sata_of_match[] = {
> +	{ .compatible = "marvell,berlin-usbphy" },

If we need to distinguish BG2 and later SoCs, we either need two
different compatibles. Or we just have a vendor specific property
describing the divider values above.

Sebastian

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, phy_berlin_sata_of_match);
> +
> +static struct platform_driver phy_berlin_usb_driver = {
> +	.probe	= berlin_phy_probe,
> +	.driver	= {
> +		.name		= "phy-berlin-usb",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= phy_berlin_sata_of_match,
> +	 },
> +};
> +module_platform_driver(phy_berlin_usb_driver);
> +
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_DESCRIPTION("Marvell Berlin USB PHY driver");
> +MODULE_LICENSE("GPL");
>

