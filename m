Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaIZUER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:04:17 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50013 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaIZUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:04:15 -0400
Date: Fri, 26 Sep 2014 15:04:09 -0500
From: Michael Welling <mwelling@emacinc.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        linus.walleij@linaro.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: GPIO registration for external Ethernet PHY oscillator
 enable/disable
Message-ID: <20140926200408.GA32264@sysresccd>
References: <20140925191722.GA2481@sysresccd>
 <54247372.40803@gmail.com>
 <20140926165919.GA3518@sysresccd>
 <54259F83.5020006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54259F83.5020006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 10:16:51AM -0700, Florian Fainelli wrote:
> 
> Yes and no, this might feel like the wrong place, but ultimately, the
> Ethernet MAC is a consumer of the PHY device, and is in control, through
> the PHY library of how and when the PHY gets to be powered off.
>

So here is the patch that I made that hooks into the macb driver.

Please look it over and tell me if we are on the same page.

The thing that bothers me about this solution is that it will only work with the macb driver.
So everytime I use the same PHY/OSC combo with a different SoC I will have to do another patch.

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index e4e34b6..8cd363f 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
+#include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 
 #include "macb.h"
@@ -1833,6 +1834,16 @@ static int __init macb_probe(struct platform_device *pdev)
                bp->phy_interface = err;
        }
 
+       bp->phy_osc_gpio = of_get_named_gpio(pdev->dev.of_node, "osc-gpio", 0);
+
+       if (gpio_is_valid(bp->phy_osc_gpio))
+       {
+               if (gpio_request(bp->phy_osc_gpio, "osc-gpio") != 0) {
+                       pr_info("Oscillator GPIO not available.\n");
+                       bp->phy_osc_gpio = 0;
+               }
+       }
+
        if (bp->phy_interface == PHY_INTERFACE_MODE_RGMII)
                macb_or_gem_writel(bp, USRIO, GEM_BIT(RGMII));
        else if (bp->phy_interface == PHY_INTERFACE_MODE_RMII)
@@ -1927,6 +1938,9 @@ static int macb_suspend(struct platform_device *pdev, pm_message_t state)
        netif_carrier_off(netdev);
        netif_device_detach(netdev);
 
+       if (gpio_is_valid(bp->phy_osc_gpio))
+               gpio_set_value_cansleep(bp->phy_osc_gpio, 0);
+
        clk_disable_unprepare(bp->hclk);
        clk_disable_unprepare(bp->pclk);
 
@@ -1941,6 +1955,9 @@ static int macb_resume(struct platform_device *pdev)
        clk_prepare_enable(bp->pclk);
        clk_prepare_enable(bp->hclk);
 
+       if (gpio_is_valid(bp->phy_osc_gpio))
+               gpio_set_value_cansleep(bp->phy_osc_gpio, 1);
+
        netif_device_attach(netdev);
 
        return 0;
diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index f407615..8ca3dbd 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -596,6 +596,7 @@ struct macb {
        u32                     caps;
 
        phy_interface_t         phy_interface;
+       int                     phy_osc_gpio;
 
        /* AT91RM9200 transmit */
        struct sk_buff *skb;                    /* holds skb until xmit interrupt completes */

 
