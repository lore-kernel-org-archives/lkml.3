Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab3K1Squ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:46:50 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:47093 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3K1Sqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:46:48 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: =?utf-8?B?6LCi6LCi6LCi?= <shh.xie@gmail.com>,
        David Miller <davem@davemloft.net>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        mugunthanvnm <mugunthanvnm@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilian Medve <Emilian.Medve@freescale.com>,
        Madalin-Cristian Bucur <madalin.bucur@freescale.com>
Subject: Re: [PATCH 3/5][v2] phylib: Add generic 10G driver
Date: Thu, 28 Nov 2013 18:46:40 +0000
Message-ID: <32227243.rXJ6m6HlES@lenovo>
User-Agent: KMail/4.11.2 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <ED492CCEAF882048BC2237DE806547C915177468@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1385459675-30364-1-git-send-email-shh.xie@gmail.com> <CAE5a0GjyY_62qM7VRqSoWe-9epf4vV5Dek=2nyMXbCc6mJSNjg@mail.gmail.com> <ED492CCEAF882048BC2237DE806547C915177468@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 28 novembre 2013, 09:59:53 Shaohui Xie a écrit :

> Thank you for reviewing the patches!
> I thought I was suggested to use phy_drivers_register() and
> phy_drivers_unregister(), so I changed to use an array, seems I got you
> wrong. :)If using two separate genphy_driver instances as you mentioned
> above is OK, I’m OK to use them, the array size is a headache to me, and
> may need to iterate the array when we unbind the driver.
> If we go for the
> array, I'd like to use some constant for the array indices. Right now we
> only support a generic 10/100/1000 PHY and now a 10G phy, but one day we
> might support a generic 40G or 100G PHY so the array indices won't be as
> obvious as they are today.
> [S.H] if we go for the array, how about below codes:
> 
> enum generic_phy {
> 
>        INTERFACE_1G,
> 
>        INTERFACE_10G,
> 
>        INTERFACE_SUPP,
> 
> };
> 
> static struct phy_driver genphy_driver[ INTERFACE_SUPP];

I would prefer to use something named: GENPHY_DRV_1G, GENPHY_DRV_10G, 
GENPHY_DRV_MAX, but yes  that's the idea.

> 
> I’m OK with using array or two separate instances, anyone would be accepted
> is good to me:)
> >  extern int mdio_bus_init(void);
> >  extern void mdio_bus_exit(void);
> >
> >
> >
> > @@ -539,7 +540,7 @@ static int phy_attach_direct(struct net_device *dev,
> > struct phy_device *phydev,
> 
> >                         return -ENODEV;
> >                 
> >                 }
> >
> >
> >
> > -               d->driver = &genphy_driver.driver;
> > +               d->driver = &genphy_driver[0].driver;
> 
> 
> This is where using a constant for an index would become useful.
> [S.H] Yes.  Should be something like:
> d->driver = &genphy_driver[INTERFACE_1G].driver;
> right?

Yes exactly

> 
> 
> >
> >
> >                 err = d->driver->probe(d);
> >                 if (err >= 0)
> > 
> > @@ -620,7 +621,7 @@ void phy_detach(struct phy_device *phydev)
> > 
> >          * was using the generic driver), we unbind the device
> >          * from the generic driver so that there's a chance a
> >          * real driver could be loaded */
> > 
> > -       if (phydev->dev.driver == &genphy_driver.driver)
> > +       if (phydev->dev.driver == &genphy_driver[0].driver)
> > 
> >                 device_release_driver(&phydev->dev);
> >  
> >  }
> 
> [S.H] This may also need to changed as:
> 
>         for (i = 0; i < ARRAY_SIZE(genphy_driver); i++) {
> 
>                 if (phydev->dev.driver == &genphy_driver[i].driver)
> 
>                         device_release_driver(&phydev->dev);
> 
>         }

Yes, indeed.

> 
> 
> >  EXPORT_SYMBOL(phy_detach);
> > 
> > @@ -689,6 +690,12 @@ static int genphy_config_advert(struct phy_device
> > *phydev)
> 
> >         return changed;
> >  
> >  }
> >
> >
> >
> > +int gen10g_config_advert(struct phy_device *dev)
> > +{
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_config_advert);
> > +
> > 
> >  /**
> >  
> >   * genphy_setup_forced - configures/forces speed/duplex from @phydev
> >   * @phydev: target phy_device struct
> > 
> > @@ -742,6 +749,11 @@ int genphy_restart_aneg(struct phy_device *phydev)
> > 
> >  }
> >  EXPORT_SYMBOL(genphy_restart_aneg);
> >
> >
> >
> > +int gen10g_restart_aneg(struct phy_device *phydev)
> > +{
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_restart_aneg);
> >
> >
> >
> >  /**
> >  
> >   * genphy_config_aneg - restart auto-negotiation or write BMCR
> > 
> > @@ -784,6 +796,12 @@ int genphy_config_aneg(struct phy_device *phydev)
> > 
> >  }
> >  EXPORT_SYMBOL(genphy_config_aneg);
> >
> >
> >
> > +int gen10g_config_aneg(struct phy_device *phydev)
> > +{
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_config_aneg);
> > +
> > 
> >  /**
> >  
> >   * genphy_update_link - update link status in @phydev
> >   * @phydev: target phy_device struct
> > 
> > @@ -913,6 +931,34 @@ int genphy_read_status(struct phy_device *phydev)
> > 
> >  }
> >  EXPORT_SYMBOL(genphy_read_status);
> >
> >
> >
> > +int gen10g_read_status(struct phy_device *phydev)
> > +{
> > +       int devad, reg;
> > +       u32 mmd_mask = phydev->c45_ids.devices_in_package;
> > +
> > +       phydev->link = 1;
> > +
> > +       /* For now just lie and say it's 10G all the time */
> > +       phydev->speed = SPEED_10000;
> > +       phydev->duplex = DUPLEX_FULL;
> > +
> > +       for (devad = 0; mmd_mask; devad++, mmd_mask = mmd_mask >> 1) {
> > +               if (!(mmd_mask & 1))
> > +                       continue;
> > +
> > +               /* Read twice because link state is latched and a
> > +                * read moves the current state into the register
> > +                */
> > +               phy_read_mmd(phydev, devad, MDIO_STAT1);
> > +               reg = phy_read_mmd(phydev, devad, MDIO_STAT1);
> > +               if (reg < 0 || !(reg & MDIO_STAT1_LSTATUS))
> > +                       phydev->link = 0;
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_read_status);
> > +
> > 
> >  static int genphy_config_init(struct phy_device *phydev)
> >  {
> >  
> >         int val;
> > 
> > @@ -959,6 +1005,16 @@ static int genphy_config_init(struct phy_device
> > *phydev)
>
> >
> >
> >         return 0;
> >  
> >  }
> > 
> > +
> > +static int gen10g_config_init(struct phy_device *phydev)
> > +{
> > +       /* Temporarily just say we support everything */
> > +       phydev->supported = SUPPORTED_10000baseT_Full;
> > +       phydev->advertising = SUPPORTED_10000baseT_Full;
> > +
> > +       return 0;
> > +}
> > +
> > 
> >  int genphy_suspend(struct phy_device *phydev)
> >  {
> >  
> >         int value;
> > 
> > @@ -974,6 +1030,12 @@ int genphy_suspend(struct phy_device *phydev)
> > 
> >  }
> >  EXPORT_SYMBOL(genphy_suspend);
> >
> >
> >
> > +int gen10g_suspend(struct phy_device *phydev)
> > +{
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_suspend);
> > +
> > 
> >  int genphy_resume(struct phy_device *phydev)
> >  {
> >  
> >         int value;
> > 
> > @@ -989,6 +1051,12 @@ int genphy_resume(struct phy_device *phydev)
> > 
> >  }
> >  EXPORT_SYMBOL(genphy_resume);
> >
> >
> >
> > +int gen10g_resume(struct phy_device *phydev)
> > +{
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_resume);
> > +
> > 
> >  /**
> >  
> >   * phy_probe - probe and init a PHY device
> >   * @dev: device to probe and init
> > 
> > @@ -1116,7 +1184,8 @@ void phy_drivers_unregister(struct phy_driver *drv,
> > int n)
> 
> >  }
> >  EXPORT_SYMBOL(phy_drivers_unregister);
> >
> >
> >
> > -static struct phy_driver genphy_driver = {
> > +static struct phy_driver genphy_driver[] = {
> > +{
> > 
> >         .phy_id         = 0xffffffff,
> >         .phy_id_mask    = 0xffffffff,
> >         .name           = "Generic PHY",
> > 
> > @@ -1127,7 +1196,18 @@ static struct phy_driver genphy_driver = {
> > 
> >         .suspend        = genphy_suspend,
> >         .resume         = genphy_resume,
> >         .driver         = {.owner= THIS_MODULE, },
> > 
> > -};
> > +}, {
> > +       .phy_id         = 0xffffffff,
> > +       .phy_id_mask    = 0xffffffff,
> > +       .name           = "Generic 10G PHY",
> > +       .config_init    = gen10g_config_init,
> > +       .features       = 0,
> > +       .config_aneg    = gen10g_config_aneg,
> > +       .read_status    = gen10g_read_status,
> > +       .suspend        = gen10g_suspend,
> > +       .resume         = gen10g_resume,
> > +       .driver         = {.owner = THIS_MODULE, },
> > +} };
> >
> >
> >
> >  static int __init phy_init(void)
> >  {
> > 
> > @@ -1137,7 +1217,8 @@ static int __init phy_init(void)
> > 
> >         if (rc)
> >         
> >                 return rc;
> >
> >
> >
> > -       rc = phy_driver_register(&genphy_driver);
> > +       rc = phy_drivers_register(genphy_driver,
> > +                                 ARRAY_SIZE(genphy_driver));
> > 
> >         if (rc)
> >         
> >                 mdio_bus_exit();
> >
> >
> >
> > @@ -1146,7 +1227,8 @@ static int __init phy_init(void)
> >
> >
> >
> >  static void __exit phy_exit(void)
> >  {
> > 
> > -       phy_driver_unregister(&genphy_driver);
> > +       phy_drivers_unregister(genphy_driver,
> > +                              ARRAY_SIZE(genphy_driver));
> > 
> >         mdio_bus_exit();
> >  
> >  }
> 
> [S.H] Using array could simplify the phy_init() and phy_exit(), this the
> advantage I see. But I may need to split the patch in two patches, one to
> change the genphy_driver to array, the second to add the generic 10g
> driver. Is it acceptable?

Yes, I am okay with two patches doing that.

Thanks!
-- 
Florian
