Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaENNDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:03:08 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55316 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaENNDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:03:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Date: Wed, 14 May 2014 15:02:34 +0200
Message-ID: <16480004.aaDhzlOZgi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400060942-10588-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <1400060942-10588-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:QyHzI2p0xXsZFIE5aq3frctmammo03ThSf0HLeRrn9m
 MrJ55AX4xlCGc57MmDrQLwjbDW7wBVy84hhSrjyLr72jX6lkF7
 jLUnxGGqm3tOAody8RCrJ9uIAISVbOhijqZoSZoyMEuffNE06W
 rJlpPj48W1HN/1adWWEaWKxvfja1tUiI6A0GLF4RFBzRHf/28T
 QbtOWl+9QtlIhY7yCMHJpduuUZd8mnZAIF6gx+e0Jl46NINMyn
 UPzR4eAenJpR+tXHqIrmK0dg6FuI0fFHZLzPuTp4wnni5gthRH
 yjpOOTVbsImAQQ4L+DJHqrzgqKML5FqxO8SSr3Em0sx+AMPRCS
 aZQUpQj9VjwN+tWTbEp4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 11:48:57 Antoine Ténart wrote:
> +static int phy_berlin_sata_power_on(struct phy *phy)
> +{
> +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> +       u32 regval;
> +
> +       spin_lock(&priv->lock);
> +
> +       /* Power up PHY */
> +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> +       regval = readl(priv->base + HOST_VSA_DATA);
> +       regval &= ~(desc->val);
> +       writel(regval, priv->base + HOST_VSA_DATA);
> +
> +       /* Configure MBus */
> +       writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
> +       regval = readl(priv->base + HOST_VSA_DATA);
> +       regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
> +       writel(regval, priv->base + HOST_VSA_DATA);
> +
> +       spin_unlock(&priv->lock);
> +
> +       return 0;
> +}
> +
> +static int phy_berlin_sata_power_off(struct phy *phy)
> +{
> +       struct phy_berlin_desc *desc = phy_get_drvdata(phy);
> +       struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
> +       u32 regval;
> +
> +       spin_lock(&priv->lock);
> +
> +       /* Power down PHY */
> +       writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
> +       regval = readl(priv->base + HOST_VSA_DATA);
> +       regval |= desc->val;
> +       writel(regval, priv->base + HOST_VSA_DATA);
> +
> +       spin_unlock(&priv->lock);
> +
> +       return 0;

I don't get this part: you have a reference to the phy here,
but then you go poking the phy registers from the SATA driver
rather than calling a PHY API function.


> +                * By default the PHY node is used to request and match a PHY.
> +                * We describe one PHY per sub-node here. Use the right node.
> +                */
> +               phy->dev.of_node = child;
> +
> +               priv->phys[phy_id].phy = phy;
> +               priv->phys[phy_id].val = desc[phy_id].val;
> +               priv->phys[phy_id].index = phy_id;
> +               phy_set_drvdata(phy, &priv->phys[phy_id]);

And here, you set a driver specific value into a structure used by the
PHY.

Both of these are layering violations. You should either use the PHY
interfaces correctly so the SATA driver doesn't have to know about the
specific, or not use a PHY device node at all and do everything in
the SATA front-end.

	Arnd
