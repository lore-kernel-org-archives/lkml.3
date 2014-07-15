Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaGONzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:55:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:65205 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGONzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:55:07 -0400
Date: Tue, 15 Jul 2014 15:54:26 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@freescale.com, mkl@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: flexcan: switch on clocks before accessing
 ecr register
Message-ID: <20140715155426.3c03f0d8@ipc1.ka-ro>
In-Reply-To: <c80f9d2ec80d01088e51be61a4e7845cbfe58f6a.1405428166.git.stefan@agner.ch>
References: <cover.1405428166.git.stefan@agner.ch>
	<c80f9d2ec80d01088e51be61a4e7845cbfe58f6a.1405428166.git.stefan@agner.ch>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stefan Agner wrote:
> Reported-by: Ashutosh Singh <ashuleapyear@gmail.com>
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> [stefan@agner.ch: added return check for clk_enable_prepare]
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/net/can/flexcan.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index f425ec2..89745aa 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -383,12 +383,26 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
>  {
>  	const struct flexcan_priv *priv = netdev_priv(dev);
>  	struct flexcan_regs __iomem *regs = priv->base;
> -	u32 reg = flexcan_read(&regs->ecr);
> +	u32 reg, err;
> +
> +	err = clk_prepare_enable(priv->clk_ipg);
> +	if (err)
> +		return err;
> +
> +	err = clk_prepare_enable(priv->clk_per);
> +	if (err)
> +		goto out_disable_ipg;
> +
> +	reg = flexcan_read(&regs->ecr);
>  
flexcan_get_berr_counter() may be called from interrupt context and
thus must not call any functions that can sleep.
Compiling the driver with CONFIG_DEBUG_ATOMIC_SLEEP would catch this!


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
