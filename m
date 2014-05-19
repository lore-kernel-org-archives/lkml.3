Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaESFxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:53:35 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:57142 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaESFxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:53:34 -0400
Date: Mon, 19 May 2014 07:53:28 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@gmail.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] pwm: i.MX: Avoid sample FIFO overflow for i.MX PWM
 version2
Message-ID: <20140519075328.7f2ef0c5@ipc1.ka-ro>
In-Reply-To: <1400217068-22642-1-git-send-email-Ying.Liu@freescale.com>
References: <1400217068-22642-1-git-send-email-Ying.Liu@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Liu Ying wrote:
[...]
> @@ -30,6 +32,7 @@
>  /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
>  
>  #define MX3_PWMCR                 0x00    /* PWM Control Register */
> +#define MX3_PWMIR                 0x08    /* PWM Interrupt Register */
>  #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
>  #define MX3_PWMPR                 0x10    /* PWM Period Register */
>  #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
> @@ -38,7 +41,12 @@
>  #define MX3_PWMCR_DBGEN			(1 << 22)
>  #define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
>  #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
> +#define MX3_PWMCR_SWR		  (1 << 3)
>  #define MX3_PWMCR_EN              (1 << 0)
> +#define MX3_PWMSR_ROV             (1 << 4)
> +#define MX3_PWMIR_RIE             (1 << 1)
> +
You should decide whether to use tabs or spaces for indentation.
And probably cleanup the indentation of the existing definitions to use
all the same indentation style.

> @@ -128,6 +160,13 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>  	else
>  		period_cycles = 0;
>  
> +	if (!enable || duty_cycles == 0)
> +		imx_pwm_software_reset_v2(chip);
> +	else if (readl(imx->mmio_base + MX3_PWMSAR))
> +		/* No rollover irq generated if duty peroid is zero. */
typo: 'period'.

> @@ -135,27 +174,55 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>  		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
>  		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
>  
> -	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +	if (enable)
>  		cr |= MX3_PWMCR_EN;
>  
>  	writel(cr, imx->mmio_base + MX3_PWMCR);
>  
> +	if (enable && duty_cycles)
> +		/* No rollover irq generated if duty peroid is zero. */
dto.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
