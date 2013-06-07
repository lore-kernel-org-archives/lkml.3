Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3FGMPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:15:31 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54196 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3FGMPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <07905E0D268758488D76D7D747F21BB6043C4AD7@rdc8.rdc>
References: <07905E0D268758488D76D7D747F21BB6043C4AD7@rdc8.rdc>
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 7 Jun 2013 13:14:49 +0100
X-Google-Sender-Auth: 9HFmxxvtHUhg8Qbuzo18El73aSk
Message-ID: <CAGVrzcZf8cT7r8+7OVEDSvMHB4rZbyMZM1kvstvdFHtX2QQzmA@mail.gmail.com>
Subject: Re: r6040 mac driver issue and solution
To: =?UTF-8?B?QnJ1Y2UgWWUgKOiRieS9s+asoyk=?= <Bruce.Ye@rdc.com.tw>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?T3dlbiBQZW5nICjlva3ph5HpmoYp?= <Owen.Peng@rdc.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Bruce,

2013/6/7 Bruce Ye (葉佳欣) <Bruce.Ye@rdc.com.tw>:
> Dear Florian:
> For RDC R6040 FAST ETHERNET DRIVER.
> There's an issue in r6040 driver and for some RDC platform. It only occurs when there's more than one Ethernet port.
> When initializing the MAC in boot up, r6040 driver set the same phy address to different ports.
> It also display in boot log as below.
> mii_bus:phy_addr=0:01
> mii_bus:phy_addr=1:01
>
> It will let the eth0 and eth1 work not in independent.
> That is, if there is a connection on eth1 but not on eth0. The eth1 can not work only if link up the eth0.
> To fix this problem is that giving the different phy address to different ports.
> I already tested it on r6040.c version 0.27 and version 0.28 by the change and is worked.

I see, thanks for the change. Have you verified that simply changing
mii_bus->phy_mask is sufficient? This should prevent the second MII
bus from probing the PHY at address 1. I will add this patch to my
patchqueue for r6040, thank you!

>
> Below is the change
>
> --- linux-3.7.2/drivers/net/ethernet/rdc/r6040.c.orig   2013-06-07 03:00:05.670250988 -0700
> +++ linux-3.7.2/drivers/net/ethernet/rdc/r6040.c        2013-06-07 03:05:01.666407765 -0700
> @@ -1037,8 +1037,18 @@ static int r6040_mii_probe(struct net_de
>  {
>         struct r6040_private *lp = netdev_priv(dev);
>         struct phy_device *phydev = NULL;
> +        static int first_find_addr = 0;
> +        int addr;
> +        for ( addr = first_find_addr; addr < PHY_MAX_ADDR; addr++ ) {
> +
> +        if ( lp->mii_bus->phy_map[addr] )
> +                phydev = lp->mii_bus->phy_map[addr];
> +
> +        if(phydev)
> +                break;
> +        }
> +        first_find_addr++ ;
>
> -       phydev = phy_find_first(lp->mii_bus);
>         if (!phydev) {
>                 dev_err(&lp->pdev->dev, "no PHY found\n");
>                 return -ENODEV;
> @@ -1194,6 +1204,10 @@ static int __devinit r6040_init_one(stru
>         lp->mii_bus->write = r6040_mdiobus_write;
>         lp->mii_bus->reset = r6040_mdiobus_reset;
>         lp->mii_bus->name = "r6040_eth_mii";
> +        if ( card_idx == 0 )
> +            lp->mii_bus->phy_mask = 0x1;
> +        else
> +            lp->mii_bus->phy_mask = 0x3;
>         snprintf(lp->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
>                 dev_name(&pdev->dev), card_idx);
>         lp->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
>
>
>
> Signed-off-by: Bruce Ye Developer <Bruce.Ye@rdc.com.tw>
>
> Best Regards
> Bruce
> RDC Semiconductor
