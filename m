Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbaLJOSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:18:25 -0500
Received: from mail-by2on0099.outbound.protection.outlook.com ([207.46.100.99]:21342
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756159AbaLJOSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:18:23 -0500
Date: Wed, 10 Dec 2014 15:18:04 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] gpio/xilinx: Remove offset property
References: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418217710-11987-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1418217710-11987-2-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.004
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <3c4acafb6be84bf0a27f11b16d0309c3@BL2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174003)(377454003)(189002)(24454002)(199003)(164054003)(51704005)(87936001)(92726002)(99396003)(86362001)(4396001)(50466002)(23746002)(104016003)(46102003)(83506001)(21056001)(92566001)(77096005)(77156002)(65956001)(65806001)(62966003)(19580395003)(19580405001)(6806004)(64706001)(20776003)(47776003)(106466001)(107886001)(2201001)(74316001)(76176999)(50986999)(107046002)(120916001)(54356999)(31966008)(108616004)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB060;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB060;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB060;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 02:21 PM, Ricardo Ribalda Delgado wrote:
> Instead of calculating the register offset per call, pre-calculate it on
> probe time.
> 
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> 
> v2: Add Acked-by 
> 
>  drivers/gpio/gpio-xilinx.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index ba18b06..9483950 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -50,7 +50,6 @@ struct xgpio_instance {
>  	struct of_mm_gpio_chip mmchip;
>  	u32 gpio_state;
>  	u32 gpio_dir;
> -	u32 offset;

when you remove offset property you should also remove offset from comment
above of this structure.

>  	spinlock_t gpio_lock;
>  };
>  
> @@ -65,12 +64,8 @@ struct xgpio_instance {
>  static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
>  {
>  	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> -	struct xgpio_instance *chip =
> -	    container_of(mm_gc, struct xgpio_instance, mmchip);
>  
> -	void __iomem *regs = mm_gc->regs + chip->offset;
> -
> -	return !!(xgpio_readreg(regs + XGPIO_DATA_OFFSET) & BIT(gpio));
> +	return !!(xgpio_readreg(mm_gc->regs + XGPIO_DATA_OFFSET) & BIT(gpio));
>  }
>  
>  /**
> @@ -88,7 +83,6 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
>  	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
>  	struct xgpio_instance *chip =
>  	    container_of(mm_gc, struct xgpio_instance, mmchip);
> -	void __iomem *regs = mm_gc->regs;
>  
>  	spin_lock_irqsave(&chip->gpio_lock, flags);
>  
> @@ -98,8 +92,7 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
>  	else
>  		chip->gpio_state &= ~BIT(gpio);
>  
> -	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
> -							 chip->gpio_state);
> +	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
>  
>  	spin_unlock_irqrestore(&chip->gpio_lock, flags);
>  }
> @@ -119,13 +112,12 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
>  	struct xgpio_instance *chip =
>  	    container_of(mm_gc, struct xgpio_instance, mmchip);
> -	void __iomem *regs = mm_gc->regs;
>  
>  	spin_lock_irqsave(&chip->gpio_lock, flags);
>  
>  	/* Set the GPIO bit in shadow register and set direction as input */
>  	chip->gpio_dir |= BIT(gpio);
> -	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
> +	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
>  
>  	spin_unlock_irqrestore(&chip->gpio_lock, flags);
>  
> @@ -148,7 +140,6 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
>  	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
>  	struct xgpio_instance *chip =
>  	    container_of(mm_gc, struct xgpio_instance, mmchip);
> -	void __iomem *regs = mm_gc->regs;
>  
>  	spin_lock_irqsave(&chip->gpio_lock, flags);
>  
> @@ -157,12 +148,11 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
>  		chip->gpio_state |= BIT(gpio);
>  	else
>  		chip->gpio_state &= ~BIT(gpio);
> -	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
> -		       chip->gpio_state);
> +	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
>  
>  	/* Clear the GPIO bit in shadow register and set direction as output */
>  	chip->gpio_dir &= ~BIT(gpio);
> -	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
> +	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
>  
>  	spin_unlock_irqrestore(&chip->gpio_lock, flags);
>  
> @@ -178,10 +168,8 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
>  	struct xgpio_instance *chip =
>  	    container_of(mm_gc, struct xgpio_instance, mmchip);
>  
> -	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
> -							chip->gpio_state);
> -	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET,
> -							 chip->gpio_dir);
> +	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET,	chip->gpio_state);
> +	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
>  }
>  
>  /**
> @@ -247,9 +235,6 @@ static int xgpio_of_probe(struct device_node *np)
>  		if (!chip)
>  			return -ENOMEM;
>  
> -		/* Add dual channel offset */
> -		chip->offset = XGPIO_CHANNEL_OFFSET;
> -
>  		/* Update GPIO state shadow register with default value */
>  		of_property_read_u32(np, "xlnx,dout-default-2",
>  				     &chip->gpio_state);
> @@ -285,6 +270,10 @@ static int xgpio_of_probe(struct device_node *np)
>  			np->full_name, status);
>  			return status;
>  		}
> +
> +		/* Add dual channel offset */
> +		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
> +
>  		pr_info("XGpio: %s: dual channel registered, base is %d\n",
>  					np->full_name, chip->mmchip.gc.base);
>  	}
> 

Thanks,
Michal
