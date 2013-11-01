Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3KARCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:02:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53895 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3KARCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:02:31 -0400
MIME-Version: 1.0
In-Reply-To: <1383317673-14704-1-git-send-email-jonas.jensen@gmail.com>
References: <1383317673-14704-1-git-send-email-jonas.jensen@gmail.com>
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 1 Nov 2013 10:01:50 -0700
X-Google-Sender-Auth: PY5iKjGcq6tUmlYDsZfk2I8V8EM
Message-ID: <CAGVrzcYfdChFNgkh=VAFZQfCRHyNTe_pZxx1Z6Sz1S8_1vzgtA@mail.gmail.com>
Subject: Re: [PATCH] phy: Add MOXA RTL8201CP PHY support
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonas,

2013/11/1 Jonas Jensen <jonas.jensen@gmail.com>:
> The MOXA UC-711X hardware(s) has an ethernet controller that seem
> to be developed internally. The IC used is "RTL8201CP".
>
> This patch adds an MDIO driver and also patches realtek to include
> RTL8201CP PHY driver.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>
> Notes:
>     The hardware does not use a separate IRQ for PHY.
>
>     The link state change interrupt can instead be caught by MAC but the
>     current drivers/of/of_mdio.c does not allow it to be handled in MAC.
>
>     Applies to next-20131031
>
>  .../devicetree/bindings/net/moxa,moxart-mdio.txt   |  19 ++
>  drivers/net/phy/Kconfig                            |   7 +
>  drivers/net/phy/Makefile                           |   1 +
>  drivers/net/phy/mdio-moxart.c                      | 201 +++++++++++++++++++++
>  drivers/net/phy/realtek.c                          |  15 ++
>  5 files changed, 243 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/moxa,moxart-mdio.txt
>  create mode 100644 drivers/net/phy/mdio-moxart.c
>
> diff --git a/Documentation/devicetree/bindings/net/moxa,moxart-mdio.txt b/Documentation/devicetree/bindings/net/moxa,moxart-mdio.txt
> new file mode 100644
> index 0000000..de0b90c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/moxa,moxart-mdio.txt
> @@ -0,0 +1,19 @@
> +* MOXA ART MDIO Ethernet Controller interface
> +
> +Required properties:
> +- compatible: should be "moxa,moxart-mdio".
> +- reg: address and length of the register set for the device.
> +
> +Example:
> +mdio1: mdio@92000090 {
> +       compatible = "moxa,moxart-mdio";
> +       reg = <0x92000090 0x8>;
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +
> +       ethphy1: ethernet-phy@1 {
> +               device_type = "ethernet-phy";
> +               compatible = "moxa,moxart-rtl8201cp";
> +               reg = <1>;
> +       };
> +};
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 342561a..9b5d46c 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -154,6 +154,13 @@ config MDIO_SUN4I
>           interface units of the Allwinner SoC that have an EMAC (A10,
>           A12, A10s, etc.)
>
> +config MDIO_MOXART
> +        tristate "MOXA ART MDIO interface support"
> +        depends on ARCH_MOXART
> +        help
> +          This driver supports the MDIO interface found in the network
> +          interface units of the MOXA ART SoC
> +
>  config MDIO_BUS_MUX
>         tristate
>         depends on OF_MDIO
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 23a2ab2..9013dfa 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -31,3 +31,4 @@ obj-$(CONFIG_MDIO_BUS_MUX)    += mdio-mux.o
>  obj-$(CONFIG_MDIO_BUS_MUX_GPIO)        += mdio-mux-gpio.o
>  obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) += mdio-mux-mmioreg.o
>  obj-$(CONFIG_MDIO_SUN4I)       += mdio-sun4i.o
> +obj-$(CONFIG_MDIO_MOXART)      += mdio-moxart.o
> diff --git a/drivers/net/phy/mdio-moxart.c b/drivers/net/phy/mdio-moxart.c
> new file mode 100644
> index 0000000..ad5d0f8
> --- /dev/null
> +++ b/drivers/net/phy/mdio-moxart.c
> @@ -0,0 +1,201 @@
> +/* MOXA ART Ethernet (RTL8201CP) MDIO interface driver
> + *
> + * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +
> +#define REG_PHY_CTRL            0
> +#define REG_PHY_WRITE_DATA      4
> +
> +/* REG_PHY_CTRL */
> +#define MIIWR                   BIT(27) /* init write sequence (auto cleared)*/
> +#define MIIRD                   BIT(26)
> +#define REGAD_MASK              0x3e00000
> +#define PHYAD_MASK              0x1f0000
> +#define MIIRDATA_MASK           0xffff
> +
> +/* REG_PHY_WRITE_DATA */
> +#define MIIWDATA_MASK           0xffff
> +
> +struct moxart_mdio_data {
> +       void __iomem            *base;
> +};
> +
> +static int moxart_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +       struct moxart_mdio_data *data = bus->priv;
> +       u32 ctrl = 0;
> +       unsigned int count = 5;
> +
> +       dev_dbg(&bus->dev, "%s\n", __func__);
> +
> +       ctrl |= MIIRD | ((mii_id << 16) & PHYAD_MASK) |
> +               ((regnum << 21) & REGAD_MASK);
> +
> +       writel(ctrl, data->base + REG_PHY_CTRL);
> +
> +       do {
> +               ctrl = readl(data->base + REG_PHY_CTRL);
> +
> +               if (!(ctrl & MIIRD))
> +                       return ctrl & MIIRDATA_MASK;
> +
> +               mdelay(10);
> +               count--;
> +       } while (count > 0);
> +
> +       dev_err(&bus->dev, "%s timed out\n", __func__);

I would keep these as a debugging aid and not spawn error messages on
the console by default.

> +
> +       return -ETIMEDOUT;
> +}
> +
> +static int moxart_mdio_write(struct mii_bus *bus, int mii_id,
> +                            int regnum, u16 value)
> +{
> +       struct moxart_mdio_data *data = bus->priv;
> +       u32 ctrl = 0;
> +       unsigned int count = 5;
> +
> +       dev_dbg(&bus->dev, "%s\n", __func__);
> +
> +       ctrl |= MIIWR | ((mii_id << 16) & PHYAD_MASK) |
> +               ((regnum << 21) & REGAD_MASK);
> +
> +       value &= MIIWDATA_MASK;
> +
> +       writel(value, data->base + REG_PHY_WRITE_DATA);
> +       writel(ctrl, data->base + REG_PHY_CTRL);
> +
> +       do {
> +               ctrl = readl(data->base + REG_PHY_CTRL);
> +
> +               if (!(ctrl & MIIWR))
> +                       return 0;
> +
> +               mdelay(10);
> +               count--;
> +       } while (count > 0);
> +
> +       dev_err(&bus->dev, "%s timed out\n", __func__);

Ditto.

> +
> +       return -ETIMEDOUT;
> +}
> +
> +static int moxart_mdio_reset(struct mii_bus *bus)
> +{
> +       int data, i;
> +
> +       for (i = 0; i < PHY_MAX_ADDR; i++) {
> +               data = moxart_mdio_read(bus, i, MII_BMCR);
> +               if (data < 0)
> +                       continue;
> +
> +               data |= BMCR_RESET;
> +               if (moxart_mdio_write(bus, i, MII_BMCR, data) < 0)
> +                       continue;
> +       }
> +
> +       return 0;
> +}
> +
> +static int moxart_mdio_probe(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct mii_bus *bus;
> +       struct moxart_mdio_data *data;
> +       struct resource *res;
> +       int ret, i;
> +
> +       bus = mdiobus_alloc_size(sizeof(*data));
> +       if (!bus)
> +               return -ENOMEM;
> +
> +       bus->name = "MOXA ART Ethernet MII";
> +       bus->read = &moxart_mdio_read;
> +       bus->write = &moxart_mdio_write;
> +       bus->reset = &moxart_mdio_reset;
> +       snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev->dev));

If you only support device tree probing, this might be fine, but you
might want to be safe in case someone does a !OF instantiation and
also use pdev->id as an additional unique identifier, so something
like:

%s-%d-mii, pdev->name, pdev->id

will work.

> +       bus->parent = &pdev->dev;
> +
> +       bus->irq = devm_kzalloc(&pdev->dev, sizeof(int) * PHY_MAX_ADDR,
> +                       GFP_KERNEL);
> +       if (!bus->irq) {
> +               ret = -ENOMEM;
> +               goto err_out_free_mdiobus;
> +       }
> +
> +       /* Setting PHY_IGNORE_INTERRUPT here even if it has no effect,
> +        * of_mdiobus_register() sets these PHY_POLL.
> +        * Ideally, the interrupt from MAC controller could be used to
> +        * detect link state changes, not polling, i.e. if there was
> +        * a way phy_driver could set PHY_HAS_INTERRUPT but have that
> +        * interrupt handled in ethernet drivercode.
> +        */
> +       for (i = 0; i < PHY_MAX_ADDR; i++)
> +               bus->irq[i] = PHY_IGNORE_INTERRUPT;

This type of configuration where the PHY interrupt is actually
serviced by a link interrupt bit in the Ethernet MAC driver now works
since 5ea94e768 ("phy: add phy_mac_interrupt() to use with
PHY_IGNORE_INTERRUPT") so setting PHY_IGNORE_INTERRUPT is the right
way to signal this and this will no longer make the PHY library poll
for the link state.

> +
> +       data = bus->priv;
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       data->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(data->base)) {
> +               ret = PTR_ERR(data->base);
> +               goto err_out_free_mdiobus;
> +       }
> +
> +       ret = of_mdiobus_register(bus, np);
> +       if (ret < 0)
> +               return ret;

You still need to call mdiobus_free() here in case registration fails.

> +
> +       platform_set_drvdata(pdev, bus);
> +
> +       return 0;
> +
> +err_out_free_mdiobus:
> +       mdiobus_free(bus);
> +       return ret;
> +}
> +
> +static int moxart_mdio_remove(struct platform_device *pdev)
> +{
> +       struct mii_bus *bus = platform_get_drvdata(pdev);
> +
> +       mdiobus_unregister(bus);
> +       mdiobus_free(bus);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id moxart_mdio_dt_ids[] = {
> +       { .compatible = "moxa,moxart-mdio" },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, moxart_mdio_dt_ids);
> +
> +static struct platform_driver moxart_mdio_driver = {
> +       .probe = moxart_mdio_probe,
> +       .remove = moxart_mdio_remove,
> +       .driver = {
> +               .name = "moxart-mdio",
> +               .of_match_table = moxart_mdio_dt_ids,
> +       },
> +};
> +
> +module_platform_driver(moxart_mdio_driver);
> +
> +MODULE_DESCRIPTION("MOXA ART MDIO interface driver");
> +MODULE_AUTHOR("Jonas Jensen <jonas.jensen@gmail.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 138de83..fa1d69a 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -64,6 +64,18 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
>         return err;
>  }
>
> +/* RTL8201CP */
> +static struct phy_driver rtl8201cp_driver = {
> +       .phy_id         = 0x00008201,
> +       .name           = "RTL8201CP Ethernet",
> +       .phy_id_mask    = 0x0000ffff,
> +       .features       = PHY_BASIC_FEATURES,

If this PHY is internal to your SoC (same die/package) you should also
add PHY_IS_INTERNAL to get a consistent ethtool reporting (among
others).
-- 
Florian
