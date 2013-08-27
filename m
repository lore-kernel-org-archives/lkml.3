Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3H0Im4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:42:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62216 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3H0Imv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:42:51 -0400
Date: Tue, 27 Aug 2013 09:42:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, bigeasy@linutronix.de, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130827084245.GA7669@lee--X1>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Aug 2013, Zubair Lutfullah wrote:

> Previously the driver had only one-shot reading functionality.
> This patch adds triggered buffer support to the driver.
> 
> Continuous sampling starts when buffer is enabled.
> And samples are pushed to userpace by the trigger which
> triggers automatically at every hardware interrupt
> of FIFO1 filling with samples upto threshold value.
> 
> Userspace responsibility to stop sampling by writing zero
> in the buffer enable file.
> 
> Patil Rachna (TI) laid the ground work for ADC HW register access.
> Russ Dill (TI) fixed bugs in the driver relevant to FIFOs and IRQs.
> 
> I fixed channel scanning so multiple ADC channels can be read
> simultaneously and pushed to userspace.
> Restructured the driver to fit IIO ABI.
> And added trigger support.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c      |  254 +++++++++++++++++++++++++++++++---
>  include/linux/mfd/ti_am335x_tscadc.h |   13 ++
>  2 files changed, 246 insertions(+), 21 deletions(-)

MFD stuff looks okay to me.

Acked-by: Lee Jones <lee.jones@linaro.org>

<snip>

> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index db1791b..a372ebf 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -46,17 +46,25 @@
>  /* Step Enable */
>  #define STEPENB_MASK		(0x1FFFF << 0)
>  #define STEPENB(val)		((val) << 0)
> +#define ENB(val)			(1 << (val))
> +#define STPENB_STEPENB		STEPENB(0x1FFFF)
> +#define STPENB_STEPENB_TC	STEPENB(0x1FFF)
>  
>  /* IRQ enable */
>  #define IRQENB_HW_PEN		BIT(0)
>  #define IRQENB_FIFO0THRES	BIT(2)
> +#define IRQENB_FIFO0OVRRUN	BIT(3)
> +#define IRQENB_FIFO0UNDRFLW	BIT(4)
>  #define IRQENB_FIFO1THRES	BIT(5)
> +#define IRQENB_FIFO1OVRRUN	BIT(6)
> +#define IRQENB_FIFO1UNDRFLW	BIT(7)
>  #define IRQENB_PENUP		BIT(9)
>  
>  /* Step Configuration */
>  #define STEPCONFIG_MODE_MASK	(3 << 0)
>  #define STEPCONFIG_MODE(val)	((val) << 0)
>  #define STEPCONFIG_MODE_HWSYNC	STEPCONFIG_MODE(2)
> +#define STEPCONFIG_MODE_SWCNT	STEPCONFIG_MODE(1)
>  #define STEPCONFIG_AVG_MASK	(7 << 2)
>  #define STEPCONFIG_AVG(val)	((val) << 2)
>  #define STEPCONFIG_AVG_16	STEPCONFIG_AVG(4)
> @@ -124,6 +132,7 @@
>  #define	MAX_CLK_DIV		7
>  #define TOTAL_STEPS		16
>  #define TOTAL_CHANNELS		8
> +#define FIFO1_THRESHOLD		19
>  
>  /*
>  * ADC runs at 3MHz, and it takes
> @@ -153,6 +162,10 @@ struct ti_tscadc_dev {
>  
>  	/* adc device */
>  	struct adc_device *adc;
> +
> +	/* Context save */
> +	unsigned int irqstat;
> +	unsigned int ctrl;
>  };
>  
>  static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
