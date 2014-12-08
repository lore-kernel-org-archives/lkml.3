Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaLHFJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:09:00 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55405 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLHFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:08:59 -0500
Message-ID: <54853268.6030701@gmail.com>
Date: Sun, 07 Dec 2014 21:08:56 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel-bounces@lists.infradead.org,
        johan@kernel.org
Subject: Re: [PATCH] net: phy: micrel: workaround to NAND_Tree# incorrectly
 strapp-in during the reset period.
References: <1418009740-27384-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1418009740-27384-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/12/2014 19:35, Wenyou Yang a écrit :
> Appearance: On some boards, after power up, the Ethernet doesn't work.
> 
> Reason: On the SAMA5D4EK, the PIOE2 pin is connected to the NAND_Tree# of KSZ8081,
> But it outputs LOW during the reset period, which cause the NAND_Tree# enabled.
> 
> Workaround: In the .config_init(), add code to disable NAND_Tree#
> by operating Operation Mode Strap Override(i.e. Register 16h).

Your patch won't apply cleanly to the net-next tree where the PHY
drivers development is happening, especially not after Johan's recent
changes.

Is not what you are looking for a phy_fixup() rather than clearing this
bit for all Micrel PHYs?

> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  drivers/net/phy/micrel.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 8c2a29a..11d72cb 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -31,6 +31,7 @@
>  /* Operation Mode Strap Override */
>  #define MII_KSZPHY_OMSO				0x16
>  #define KSZPHY_OMSO_B_CAST_OFF			(1 << 9)
> +#define KSZPHY_OMSO_NAND_TREE_OVERRIDE		(1 << 5)
>  #define KSZPHY_OMSO_RMII_OVERRIDE		(1 << 1)
>  #define KSZPHY_OMSO_MII_OVERRIDE		(1 << 0)
>  
> @@ -180,7 +181,12 @@ static int kszphy_setup_led(struct phy_device *phydev,
>  
>  static int kszphy_config_init(struct phy_device *phydev)
>  {
> -	return 0;
> +	int rc;
> +
> +	phy_write(phydev, MII_KSZPHY_OMSO, phy_read(phydev, MII_KSZPHY_OMSO)
> +			& (~KSZPHY_OMSO_NAND_TREE_OVERRIDE));
> +	rc = ksz_config_flags(phydev);
> +	return rc < 0 ? rc : 0;
>  }
>  
>  static int kszphy_config_init_led8041(struct phy_device *phydev)
> 

