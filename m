Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBXSUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:20:55 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41123 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBXSUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:20:54 -0500
MIME-Version: 1.0
In-Reply-To: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 24 Feb 2014 10:20:10 -0800
Message-ID: <CAGVrzcadYTYQEvPxqdMf2f741y5sAgnOYm3EC=f7SOkr8SK2WQ@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add suspend_halted module param
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

2014-02-23 8:58 GMT-08:00 Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com>:
> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
>   ("net: phy: resume/suspend PHYs on attach/detach")
> introduced a feature to suspend PHYs when entering halted state.
>
> Unfortunately, not all bootloaders properly power-up PHYs on reset
> and fail to access ethernet because the PHY is still powered down.
>
> Therefore, we add a boolean module parameter suspend_halted with
> default value of true. Disabling that parameter prevents PHYs from
> being suspended when entering halted state.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> ---
> Andrew, can you please re-test if disabling the feature does work on
> your board? I tried a bunch of mine, but none failed to power-up the
> PHY in u-boot.

Would be good to get Andrew's testing on this just to make sure it
solves his problem. Otherwise:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

>
> Cc: David Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/phy/phy_device.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 4b03e63639b7..671eea0eb5db 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -40,6 +40,10 @@ MODULE_DESCRIPTION("PHY library");
>  MODULE_AUTHOR("Andy Fleming");
>  MODULE_LICENSE("GPL");
>
> +static bool suspend_halted = true;
> +module_param(suspend_halted, bool, 0644);
> +MODULE_PARM_DESC(suspend_halted, "Suspend PHYs when entering halted state.");
> +
>  void phy_device_free(struct phy_device *phydev)
>  {
>         put_device(&phydev->dev);
> @@ -685,6 +689,12 @@ int phy_suspend(struct phy_device *phydev)
>         struct phy_driver *phydrv = to_phy_driver(phydev->dev.driver);
>         struct ethtool_wolinfo wol;
>
> +       /* Some bootloaders do not power-up PHYs properly after reset,
> +        * allow to disable the suspend halted PHYs feature.
> +        */
> +       if (!suspend_halted)
> +               return -ENOSYS;
> +
>         /* If the device has WOL enabled, we cannot suspend the PHY */
>         wol.cmd = ETHTOOL_GWOL;
>         phy_ethtool_get_wol(phydev, &wol);
> --
> 1.8.5.3
>



-- 
Florian
