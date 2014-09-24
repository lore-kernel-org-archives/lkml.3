Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaIXKGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:06:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaIXKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:06:38 -0400
Message-ID: <1411553179.2735.4.camel@pengutronix.de>
Subject: Re: [PATCH 5/9] gpio: vf610: Extend with wakeup support
From: Lucas Stach <l.stach@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com, linux@arm.linux.org.uk, jingchang.lu@freescale.com,
        b20788@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Date: Wed, 24 Sep 2014 12:06:19 +0200
In-Reply-To: <704b6bb97147b3d0ee1557b43d85ab9376c28666.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
	 <704b6bb97147b3d0ee1557b43d85ab9376c28666.1411404079.git.stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Am Montag, den 22.09.2014, 19:09 +0200 schrieb Stefan Agner:
> Support Vybrid GPIO's as wakeup source by requesting the parent
> IRQ as wakeup IRQ.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/gpio/gpio-vf610.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
> index 5f59424..50326af 100644
> --- a/drivers/gpio/gpio-vf610.c
> +++ b/drivers/gpio/gpio-vf610.c
> @@ -196,12 +196,28 @@ static void vf610_gpio_irq_unmask(struct irq_data *d)
>  			  pcr_base);
>  }
>  
> +static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
> +{
> +	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
> +
> +	if (enable)
> +		enable_irq_wake(port->irq);
> +	else
> +		disable_irq_wake(port->irq);
> +
> +	return 0;
> +}
> +
> +
>  static struct irq_chip vf610_gpio_irq_chip = {
>  	.name		= "gpio-vf610",
>  	.irq_ack	= vf610_gpio_irq_ack,
>  	.irq_mask	= vf610_gpio_irq_mask,
>  	.irq_unmask	= vf610_gpio_irq_unmask,
>  	.irq_set_type	= vf610_gpio_irq_set_type,
> +#ifdef CONFIG_PM_SLEEP
> +	.irq_set_wake	= vf610_gpio_irq_set_wake,
> +#endif

Either you need to get rid of this #ifdef and always assign this
function or you need to wrap the function itself into the same #ifdef.
Otherwise you provoke a unused function warning with !CONFIG_PM_SLEEP.

Given that this function isn't really that big I would argue to just
drop the #ifdef.

Regards,
Lucas 

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

