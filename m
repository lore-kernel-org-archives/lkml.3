Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab3GWSIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:08:38 -0400
Received: from www.xora.org.uk ([80.68.91.202]:36980 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3GWSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:08:35 -0400
Message-ID: <51EEC69F.9000006@slimlogic.co.uk>
Date: Tue, 23 Jul 2013 19:08:31 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, linux-omap@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: twl6030-irq: add error check when IRQs are masked
 initially
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com> <1374595624-15054-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1374595624-15054-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/13 17:07, Grygorii Strashko wrote:
> Add a missed check for errors when TWL IRQs are masked
> initially on probe and report an error in case of failure.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/mfd/twl6030-irq.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
> index b6030d9..790cc28 100644
> --- a/drivers/mfd/twl6030-irq.c
> +++ b/drivers/mfd/twl6030-irq.c
> @@ -313,7 +313,7 @@ int twl6030_init_irq(struct device *dev, int irq_num)
>  	struct			device_node *node = dev->of_node;
>  	int			nr_irqs, irq_base, irq_end;
>  	static struct irq_chip  twl6030_irq_chip;
> -	int			status = 0;
> +	int			status;
>  	int			i;
>  	u8			mask[3];
>  
> @@ -335,11 +335,16 @@ int twl6030_init_irq(struct device *dev, int irq_num)
>  	mask[2] = 0xFF;
>  
>  	/* mask all int lines */
> -	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
> +	status = twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_LINE_A, 3);
>  	/* mask all int sts */
> -	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_STS_A, 3);
> +	status |= twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_MSK_STS_A, 3);
>  	/* clear INT_STS_A,B,C */
> -	twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_STS_A, 3);
> +	status |= twl_i2c_write(TWL_MODULE_PIH, &mask[0], REG_INT_STS_A, 3);
> +
You can save two i2c writes here for slightly faster initialisation,
only one of the REG_INT_STS_A registers needs to be written to clear
them all. As per the irq handling routine comment.
> +	if (status < 0) {
> +		dev_err(dev, "I2C err writing TWL_MODULE_PIH: %d\n", status);
> +		return status;
> +	}
>  
>  	twl6030_irq_base = irq_base;
>  

Graeme

