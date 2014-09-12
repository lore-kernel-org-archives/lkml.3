Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaILTkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:40:24 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:34198 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaILTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:40:23 -0400
Date: Fri, 12 Sep 2014 21:40:14 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Message-ID: <20140912194014.GA15496@electric-eye.fr.zoreil.com>
References: <1394712342-15778-38-Taiwan-albertk@realtek.com>
 <1394712342-15778-39-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-39-Taiwan-albertk@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> If the parameter "features" of __rtl8169_set_features() is equal to
> dev->features, the variable "changed" is alwayes 0, and nothing would
> be changed.
[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 91652e7..f3ce284 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -6707,7 +6707,12 @@ static int rtl_open(struct net_device *dev)
>  
>  	rtl8169_init_phy(dev, tp);
>  
> -	__rtl8169_set_features(dev, dev->features);
> +	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
> +		tp->cp_cmd |= RxVlan;
> +	else
> +		tp->cp_cmd &= ~RxVlan;
> +
> +	RTL_W16(CPlusCmd, tp->cp_cmd);

Damn good catch.

The same fix should be relevant for NETIF_F_RXCSUM. You may thus as
well remove the "changed" test in __rtl8169_set_features and keep
everything there.

The commit message could notify the driver don't behave as expected since
6bbe021d405fff46b64a08dca51b06897b897a67 ("r8169: Support RX-ALL flag.")
to ease stable people's work.

-- 
Ueimor
