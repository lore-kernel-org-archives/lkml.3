Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3EHKlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:41:36 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:45137 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3EHKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:41:35 -0400
Date: Wed, 8 May 2013 12:41:20 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jongsung Kim <neidhard.kim@lge.com>
Cc: davem@davemloft.net, peppe.cavallaro@st.com, chohnstaedt@innominate.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: add rtl8201f driver
Message-ID: <20130508104119.GA24905@electric-eye.fr.zoreil.com>
References: <201305081910.27203.neidhard.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305081910.27203.neidhard.kim@lge.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jongsung Kim <neidhard.kim@lge.com> :
> This patch adds the minimal driver to manage the
> Realtek RTL8201F 10/100Mbps Transceivers.

Your patch contains both "remove unused #define" and "support new hardware"
parts. I am not sure that the former is adequate for submission until
net-next opens.

> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
[...]
> +static int rtl8201f_config_intr(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	phy_write(phydev, RTL8201F_PSR, 0x0007);	/* select page 7 */

static void rtl8201f_page_select(struct phy_device *phydev, int page) ?

[...]
> @@ -96,16 +141,16 @@ static struct phy_driver rtl8211e_driver = {
>  
>  static int __init realtek_init(void)
>  {
> -	int ret;
> -
> -	ret = phy_driver_register(&rtl8211b_driver);
> -	if (ret < 0)
> +	if(phy_driver_register(&rtl8201f_driver) < 0)
         ^^ -> missing space.

> +		return -ENODEV;

Please propagate phy_driver_register error code.

> +	if(phy_driver_register(&rtl8211b_driver) < 0)
>  		return -ENODEV;
>  	return phy_driver_register(&rtl8211e_driver);

Unbalanced error paths.

>  }
>  
>  static void __exit realtek_exit(void)
>  {
> +	phy_driver_unregister(&rtl8201f_driver);
>  	phy_driver_unregister(&rtl8211b_driver);
>  	phy_driver_unregister(&rtl8211e_driver);

Code duplication.

You may use an array of phy_driver for realtek_{init/exit}

-- 
Ueimor
