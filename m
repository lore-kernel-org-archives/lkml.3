Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaEOGQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:16:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45205 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaEOGP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:15:57 -0400
Message-ID: <53745B74.2040808@ti.com>
Date: Thu, 15 May 2014 11:45:16 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <tj@kernel.org>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-ide@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com> <1400060942-10588-2-git-send-email-antoine.tenart@free-electrons.com> <537341AF.5030105@ti.com> <20140514102122.GA11140@kwain>
In-Reply-To: <20140514102122.GA11140@kwain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 14 May 2014 03:51 PM, Antoine Ténart wrote:
> Hi,
> 
> On Wed, May 14, 2014 at 03:43:03PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Wednesday 14 May 2014 03:18 PM, Antoine Ténart wrote:
> 
> […]
> 
>>> +#define to_berlin_sata_phy_priv(desc)	\
>>> +	container_of((desc), struct phy_berlin_priv, phys[(desc)->index])
>>> +
>>> +struct phy_berlin_desc {
>>> +	struct phy	*phy;
>>> +	u32		val;
>>> +	unsigned	index;
>>> +};
>>> +
>>> +struct phy_berlin_priv {
>>> +	void __iomem	*base;
>>> +	spinlock_t	lock;
>>> +	struct phy_berlin_desc	phys[BERLIN_SATA_PHY_NB];
>>
>> Can't we do away with hardcoding BERLIN_SATA_PHY_NB?
> 
> We can't if we want to be able to use the container_of macro in
> to_berlin_sata_phy_priv(). And we want a common structure to store the
> common spinlock and base address.

to get phy_berlin_priv, you can use dev_get_drvdata(phy->dev->parent).

> 
> […]
> 
>>> +		/*
>>> +		 * By default the PHY node is used to request and match a PHY.
>>> +		 * We describe one PHY per sub-node here. Use the right node.
>>> +		 */
>>> +		phy->dev.of_node = child;
>>> +
>>> +		priv->phys[phy_id].phy = phy;
>>> +		priv->phys[phy_id].val = desc[phy_id].val;
>>> +		priv->phys[phy_id].index = phy_id;
>>> +		phy_set_drvdata(phy, &priv->phys[phy_id]);
>>> +
>>> +		/* Make sure the PHY is off */
>>> +		phy_berlin_sata_power_off(phy);
>>> +
>>> +		phy_provider = devm_of_phy_provider_register(&phy->dev,
>>> +							     of_phy_simple_xlate);
>>> +		if (IS_ERR(phy_provider))
>>> +			return PTR_ERR(phy_provider);
>>
>> was this intentional? registering multiple PHY providers?
> 
> Yes. Each sub-node describe a PHY and register as a PHY provider. This
> allow to reference the PHY as <&sata_phy0> and not <&sata_phy 0>. It
> would be confusing to have a sub-node sata_phy0 and to use its parent
> to access it.

It is still a single PHY provider, so you can't register multiple PHY
providers. So in this case <&sata_phy 0> is not that bad.

However phy-core.c should be patched with the following (only compile tested)

>From 2517d4c0ad7f13abc2613516ef2b222a1fbcb550 Mon Sep 17 00:00:00 2001
From: Kishon Vijay Abraham I <kishon@ti.com>
Date: Thu, 15 May 2014 11:32:57 +0530
Subject: [PATCH] phy: phy-core: Support modelling multi-PHY PHY nodes as
 subnodes of PHY PROVIDER

When a single PHY provider implementing multiple PHYs is represented in dt,
the PHYs should be modelled as sub nodes of the PHY PROVIDER node.

So the consumers using the PHY will have the phandle of the sub node rather
than the phandle of the PHY PROVIDER. Amended *of_phy_provider_lookup* in
PHY core to return the PHY PROVIDER even when the phandle of the PHY PROVIDERs
sub node is provided.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..124c6ec 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -83,10 +83,18 @@ static struct phy *phy_lookup(struct device *device, const
char *port)
 static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
 {
        struct phy_provider *phy_provider;
+       struct device_node *child;

        list_for_each_entry(phy_provider, &phy_provider_list, list) {
-               if (phy_provider->dev->of_node == node)
+               if (phy_provider->dev->of_node != node) {
+                       for_each_child_of_node(phy_provider->dev->of_node,
+                               child) {
+                               if (child == node)
+                                       return phy_provider;
+                       }
+               } else {
                        return phy_provider;
+               }
        }

        return ERR_PTR(-EPROBE_DEFER);
-- 
1.7.9.5

Thanks
Kishon
