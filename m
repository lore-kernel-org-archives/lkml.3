Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3EHPnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:43:05 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:45973 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3EHPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:43:00 -0400
Message-ID: <518A7284.4000504@cogentembedded.com>
Date: Wed, 08 May 2013 19:43:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: davem@davemloft.net, peppe.cavallaro@st.com, chohnstaedt@innominate.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: add rtl8201f driver
References: <201305081910.27203.neidhard.kim@lge.com>
In-Reply-To: <201305081910.27203.neidhard.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-05-2013 14:10, Jongsung Kim wrote:

> This patch adds the minimal driver to manage the
> Realtek RTL8201F 10/100Mbps Transceivers.

> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
> ---
>   drivers/net/phy/realtek.c |   60 +++++++++++++++++++++++++++++++++++++++-----
>   1 files changed, 53 insertions(+), 7 deletions(-)

> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 8e7af83..27847ca 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -16,9 +16,13 @@
>   #include <linux/phy.h>
>   #include <linux/module.h>
>
> -#define RTL821x_PHYSR		0x11
> -#define RTL821x_PHYSR_DUPLEX	0x2000
> -#define RTL821x_PHYSR_SPEED	0xc000

     Removal of unused #define's is a matter of a separate cleanup patch...

> +/* page 0 register 30 - interrupt indicators and SNR display register */
> +#define RTL8201F_ISR		0x1e
> +/* page 0 register 31 - page select register */
> +#define RTL8201F_PSR		0x1f
> +/* page 7 register 19 - interrupt, WOL enable, and LEDs function register */
> +#define RTL8201F_IER		0x13
> +
>   #define RTL821x_INER		0x12
>   #define RTL821x_INER_INIT	0x6400
>   #define RTL821x_INSR		0x13
> @@ -29,6 +33,15 @@ MODULE_DESCRIPTION("Realtek PHY driver");
>   MODULE_AUTHOR("Johnson Leung");
>   MODULE_LICENSE("GPL");
>
> +static int rtl8201f_ack_interrupt(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = phy_read(phydev, RTL8201F_ISR);

    This could be an initializer and so make the function shorter.

> +
> +	return (err < 0) ? err : 0;
> +}
> +
>   static int rtl821x_ack_interrupt(struct phy_device *phydev)
>   {
>   	int err;
[...]
> @@ -96,16 +141,16 @@ static struct phy_driver rtl8211e_driver = {
>
>   static int __init realtek_init(void)
>   {
> -	int ret;
> -
> -	ret = phy_driver_register(&rtl8211b_driver);
> -	if (ret < 0)
> +	if(phy_driver_register(&rtl8201f_driver) < 0)
> +		return -ENODEV;
> +	if(phy_driver_register(&rtl8211b_driver) < 0)

     You haven't run this patch thru scripts/checkpatch.pl -- there 
should be a space between *if* and (.

WBR, Sergei

