Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3KLRyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:54:16 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39332 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3KLRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:54:13 -0500
MIME-Version: 1.0
In-Reply-To: <1384168049-2899-1-git-send-email-shh.xie@gmail.com>
References: <1384168049-2899-1-git-send-email-shh.xie@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 12 Nov 2013 09:53:32 -0800
Message-ID: <CAGVrzcZa2-yduRDxwGnYeoLJcRFjDr9OHtkUReAPF0cDseamJg@mail.gmail.com>
Subject: Re: [PATCH 2/4] phylib: Add generic 10G driver
To: shh.xie@gmail.com
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        madalin.bucur@freescale.com, Shruti@freescale.com,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shaohui,

2013/11/11  <shh.xie@gmail.com>:
> From: Andy Fleming
>
> Very incomplete, but will allow for binding an ethernet controller
> to it.
>
> Also, Add XGMII interface type

So that should be two separate patches, and
drivers/of/of_net.c::of_get_phy_mode() must be updated to know about
XMGII.

>
> Signed-off-by: Andy Fleming

Missing Andy's Signed-off-by tag.

> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> ---
>  drivers/net/phy/phy_device.c | 101 ++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/phy.h          |   1 +
>  2 files changed, 101 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 74630e9..30bf2d5 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -32,6 +32,7 @@
>  #include <linux/module.h>
>  #include <linux/mii.h>
>  #include <linux/ethtool.h>
> +#include <linux/mdio.h>
>  #include <linux/phy.h>
>
>  #include <asm/io.h>
> @@ -689,6 +690,13 @@ static int genphy_config_advert(struct phy_device *phydev)
>         return changed;
>  }
>
> +int gen10g_config_advert(struct phy_device *dev)
> +{
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_config_advert);
> +
> +
>  /**
>   * genphy_setup_forced - configures/forces speed/duplex from @phydev
>   * @phydev: target phy_device struct
> @@ -742,6 +750,12 @@ int genphy_restart_aneg(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_restart_aneg);
>
> +int gen10g_restart_aneg(struct phy_device *phydev)
> +{
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_restart_aneg);
> +
>
>  /**
>   * genphy_config_aneg - restart auto-negotiation or write BMCR
> @@ -784,6 +798,13 @@ int genphy_config_aneg(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_config_aneg);
>
> +int gen10g_config_aneg(struct phy_device *phydev)
> +{
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_config_aneg);
> +
> +
>  /**
>   * genphy_update_link - update link status in @phydev
>   * @phydev: target phy_device struct
> @@ -913,6 +934,35 @@ int genphy_read_status(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_read_status);
>
> +int gen10g_read_status(struct phy_device *phydev)
> +{
> +       int devad, reg;
> +       u32 mmd_mask = phydev->c45_ids.devices_in_package;
> +
> +       phydev->link = 1;
> +
> +       /* For now just lie and say it's 10G all the time */
> +       phydev->speed = 10000;

Can you at least make this a little more proof? Something along:

if (phydev->supported & (SUPPORTED_10000baseT_Full))
            phydev->speed = SPEED_10000;
else if (phydev->supported & (SUPPORTED_1000baseT_Full)
            phydev->speed = SPEED_1000;

Although ideally we should be reading the relevant registers to figure
out what to do.

> +       phydev->duplex = DUPLEX_FULL;
> +
> +       for (devad = 0; mmd_mask; devad++, mmd_mask = mmd_mask >> 1) {
> +               if (!(mmd_mask & 1))
> +                       continue;
> +
> +               /* Read twice because link state is latched and a
> +                * read moves the current state into the register
> +                */
> +               phy_read_mmd(phydev, devad, MDIO_STAT1);
> +               reg = phy_read_mmd(phydev, devad, MDIO_STAT1);
> +               if (reg < 0 || !(reg & MDIO_STAT1_LSTATUS))
> +                       phydev->link = 0;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_read_status);
> +
> +
>  static int genphy_config_init(struct phy_device *phydev)
>  {
>         int val;
> @@ -959,6 +1009,15 @@ static int genphy_config_init(struct phy_device *phydev)
>
>         return 0;
>  }
> +
> +static int gen10g_config_init(struct phy_device *phydev)
> +{
> +       /* Temporarily just say we support everything */
> +       phydev->supported = phydev->advertising = SUPPORTED_10000baseT_Full;

For consistency you should set SUPPORTED_TP, 1000baseT_Full does not
make sense for anything but twisted pairs AFAIR.

> +
> +       return 0;
> +}
> +
>  int genphy_suspend(struct phy_device *phydev)
>  {
>         int value;
> @@ -974,6 +1033,13 @@ int genphy_suspend(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_suspend);
>
> +int gen10g_suspend(struct phy_device *phydev)
> +{
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_suspend);
> +
> +
>  int genphy_resume(struct phy_device *phydev)
>  {
>         int value;
> @@ -989,6 +1055,13 @@ int genphy_resume(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL(genphy_resume);
>
> +int gen10g_resume(struct phy_device *phydev)
> +{
> +       return 0;
> +}
> +EXPORT_SYMBOL(gen10g_resume);
> +
> +
>  /**
>   * phy_probe - probe and init a PHY device
>   * @dev: device to probe and init
> @@ -1129,6 +1202,20 @@ static struct phy_driver genphy_driver = {
>         .driver         = {.owner= THIS_MODULE, },
>  };
>
> +static struct phy_driver gen10g_driver = {
> +       .phy_id         = 0xffffffff,
> +       .phy_id_mask    = 0xffffffff,
> +       .name           = "Generic 10G PHY",
> +       .config_init    = gen10g_config_init,
> +       .features       = 0,

This should be updated to be PHY_10GBIT_FEATURES where
PHY_10GBIT_FEATURES is defined to contain at least PHY_GBIT_FEATURES.

> +       .config_aneg    = gen10g_config_aneg,
> +       .read_status    = gen10g_read_status,
> +       .suspend        = gen10g_suspend,
> +       .resume         = gen10g_resume,
> +       .driver         = {.owner = THIS_MODULE, },
> +};
> +
> +
>  static int __init phy_init(void)
>  {
>         int rc;
> @@ -1139,13 +1226,25 @@ static int __init phy_init(void)
>
>         rc = phy_driver_register(&genphy_driver);
>         if (rc)
> -               mdio_bus_exit();
> +               goto genphy_register_failed;
> +
> +       rc = phy_driver_register(&gen10g_driver);
> +       if (rc)
> +               goto gen10g_register_failed;
> +
> +       return rc;
> +
> +gen10g_register_failed:
> +       phy_driver_unregister(&genphy_driver);
> +genphy_register_failed:
> +       mdio_bus_exit();

As a subsequent patch you could use phy_drivers_register()

>
>         return rc;
>  }
>
>  static void __exit phy_exit(void)
>  {
> +       phy_driver_unregister(&gen10g_driver);
>         phy_driver_unregister(&genphy_driver);

And phy_drivers_unregister() here.

>         mdio_bus_exit();
>  }
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 684925a..f864004 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -66,6 +66,7 @@ typedef enum {
>         PHY_INTERFACE_MODE_RGMII_TXID,
>         PHY_INTERFACE_MODE_RTBI,
>         PHY_INTERFACE_MODE_SMII,
> +       PHY_INTERFACE_MODE_XGMII,
>  } phy_interface_t;
>
>
> --
> 1.8.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Florian
