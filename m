Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaE0WaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:30:14 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:61352 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaE0WaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <1401226727-5508-6-git-send-email-linux@rainbow-software.org>
References: <1401226727-5508-1-git-send-email-linux@rainbow-software.org> <1401226727-5508-6-git-send-email-linux@rainbow-software.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 27 May 2014 15:29:31 -0700
Message-ID: <CAGVrzcbD=OhzuWRuxJVG1SJeYDsOYaV2AozsWafBtX6gcF08vw@mail.gmail.com>
Subject: Re: [PATCH 5/9] tlan: Restart autonegotiation on link loss
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Samuel Chessman <chessman@tux.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-05-27 14:38 GMT-07:00 Ondrej Zary <linux@rainbow-software.org>:
> When link is lost on a card which uses internal PHY for 10 Mbit speeds,
> restart autonegotiation to allow switching between 10 and 100 Mbps speeds.

I think you should take a look at implementing libphy read/write stubs
for this driver, that would allow you not to open-code such things.

>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/net/ethernet/ti/tlan.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
> index 31d4a96..1047b3f 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
> @@ -2721,6 +2721,7 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
>         else if (!(mode & 0x0080) && (mode & 0x0040))
>                 priv->tlan_full_duplex = true;
>
> +       /* switch to internal PHY for 10 Mbps */
>         if ((!(mode & 0x0180)) &&
>             (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) &&
>             (priv->phy_num != 0)) {
> @@ -2788,6 +2789,19 @@ static void tlan_phy_monitor(unsigned long data)
>                                dev->name);
>                         tlan_dio_write8(dev->base_addr, TLAN_LED_REG, 0);
>                         netif_carrier_off(dev);
> +                       if (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) {
> +                               /* power down internal PHY */
> +                               u16 data = MII_GC_PDOWN | MII_GC_LOOPBK
> +                                       | MII_GC_ISOLATE;
> +                               tlan_mii_sync(dev->base_addr);
> +                               tlan_mii_write_reg(dev, priv->phy[0],
> +                                       MII_GEN_CTL, data);
> +                               /* set to external PHY */
> +                               priv->phy_num = 1;
> +                               /* restart autonegotiation */
> +                               tlan_set_timer(dev, (4*HZ/10), TLAN_TIMER_PHY_PDOWN);
> +                               return;
> +                       }
>                 }
>         }
>
> --
> Ondrej Zary
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Florian
