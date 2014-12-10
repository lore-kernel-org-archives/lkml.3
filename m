Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaLJOgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:36:23 -0500
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:54048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753905AbaLJOgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:36:21 -0500
Date: Wed, 10 Dec 2014 15:36:01 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] gpio/xilinx: Convert the driver to platform device
 interface
References: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418217710-11987-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1418217710-11987-3-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.004
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <f86daba7727c4537947191ba871f4606@BY2FFO11FD006.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(438002)(164054003)(479174003)(377454003)(199003)(51704005)(24454002)(189002)(106466001)(65956001)(99396003)(64706001)(104016003)(87936001)(107046002)(120916001)(107886001)(23746002)(83506001)(47776003)(6806004)(19580405001)(21056001)(20776003)(2201001)(19580395003)(65806001)(92566001)(46102003)(64126003)(74316001)(92726002)(50466002)(50986999)(54356999)(77096005)(62966003)(86362001)(76176999)(77156002)(4396001)(31966008)(108616004)(65826006)(87944003)(107986001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB011;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:ovrnspm;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB011;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB011;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB011;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 02:21 PM, Ricardo Ribalda Delgado wrote:
> This way we do not need to transverse the device tree manually and we
> support hot plugged devices.
> 
> Also Implement remove callback so the driver can be unloaded
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> 
> v2: Suggested by Alexandre Courbot <gnurou@gmail.com>
> 
> Merge convert to platform device and implement remove callback in one patch
> 
>  drivers/gpio/gpio-xilinx.c | 79 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 59 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index 9483950..f946d96 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -51,6 +51,11 @@ struct xgpio_instance {
>  	u32 gpio_state;
>  	u32 gpio_dir;
>  	spinlock_t gpio_lock;
> +	bool inited;

like before - you should document it.
I know it is not proper kernel-doc format but I think
you can simple create one more patch before 1/3
and fix kernel-doc format first and then do your changes.

btw: this kernel-doc fixup is in xilinx git repo.

> +};
> +
> +struct xgpio {
> +	struct xgpio_instance port[2];
>  };
>  
>  /**
> @@ -173,24 +178,57 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
>  }
>  
>  /**
> + * xgpio_remove - Remove method for the GPIO device.
> + * @pdev: pointer to the platform device
> + *
> + * This function remove gpiochips and frees all the allocated resources.
> + */
> +static int xgpio_remove(struct platform_device *pdev)
> +{
> +	struct xgpio *xgpio = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < 2; i++) {
> +		if (!xgpio->port[i].inited)
> +			continue;
> +		gpiochip_remove(&xgpio->port[i].mmchip.gc);
> +
> +		if (i == 1)
> +			xgpio->port[i].mmchip.regs -= XGPIO_CHANNEL_OFFSET;
> +
> +		iounmap(xgpio->port[i].mmchip.regs);
> +		kfree(xgpio->port[i].mmchip.gc.label);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * xgpio_of_probe - Probe method for the GPIO device.
> - * @np: pointer to device tree node
> + * @pdev: pointer to the platform device
>   *
>   * This function probes the GPIO device in the device tree. It initializes the
>   * driver data structure. It returns 0, if the driver is bound to the GPIO
>   * device, or a negative value if there is an error.
>   */
> -static int xgpio_of_probe(struct device_node *np)
> +static int xgpio_probe(struct platform_device *pdev)
>  {
> +	struct xgpio *xgpio;
>  	struct xgpio_instance *chip;
>  	int status = 0;
> +	struct device_node *np = pdev->dev.of_node;
>  	const u32 *tree_info;
>  	u32 ngpio;
>  
> -	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -	if (!chip)
> +	xgpio = (struct xgpio *) devm_kzalloc(&pdev->dev, sizeof(*xgpio),
> +					      GFP_KERNEL);

don't need to recast it here.

> +	if (!xgpio)
>  		return -ENOMEM;
>  
> +	platform_set_drvdata(pdev, xgpio);
> +
> +	chip = &xgpio->port[0];
> +
>  	/* Update GPIO state shadow register with default value */
>  	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
>  
> @@ -210,6 +248,7 @@ static int xgpio_of_probe(struct device_node *np)
>  
>  	spin_lock_init(&chip->gpio_lock);
>  
> +	chip->mmchip.gc.dev = &pdev->dev;
>  	chip->mmchip.gc.direction_input = xgpio_dir_in;
>  	chip->mmchip.gc.direction_output = xgpio_dir_out;
>  	chip->mmchip.gc.get = xgpio_get;
> @@ -220,20 +259,18 @@ static int xgpio_of_probe(struct device_node *np)
>  	/* Call the OF gpio helper to setup and register the GPIO device */
>  	status = of_mm_gpiochip_add(np, &chip->mmchip);
>  	if (status) {
> -		kfree(chip);
>  		pr_err("%s: error in probe function with status %d\n",
>  		       np->full_name, status);
>  		return status;
>  	}
> +	chip->inited = true;
>  
>  	pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
>  							chip->mmchip.gc.base);
>  
>  	tree_info = of_get_property(np, "xlnx,is-dual", NULL);
>  	if (tree_info && be32_to_cpup(tree_info)) {
> -		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -		if (!chip)
> -			return -ENOMEM;
> +		chip = &xgpio->port[1];
>  
>  		/* Update GPIO state shadow register with default value */
>  		of_property_read_u32(np, "xlnx,dout-default-2",
> @@ -255,6 +292,7 @@ static int xgpio_of_probe(struct device_node *np)
>  
>  		spin_lock_init(&chip->gpio_lock);
>  
> +		chip->mmchip.gc.dev = &pdev->dev;
>  		chip->mmchip.gc.direction_input = xgpio_dir_in;
>  		chip->mmchip.gc.direction_output = xgpio_dir_out;
>  		chip->mmchip.gc.get = xgpio_get;
> @@ -265,7 +303,7 @@ static int xgpio_of_probe(struct device_node *np)
>  		/* Call the OF gpio helper to setup and register the GPIO dev */
>  		status = of_mm_gpiochip_add(np, &chip->mmchip);
>  		if (status) {
> -			kfree(chip);
> +			xgpio_remove(pdev);
>  			pr_err("%s: error in probe function with status %d\n",
>  			np->full_name, status);
>  			return status;
> @@ -273,6 +311,7 @@ static int xgpio_of_probe(struct device_node *np)
>  
>  		/* Add dual channel offset */
>  		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
> +		chip->inited = true;
>  
>  		pr_info("XGpio: %s: dual channel registered, base is %d\n",
>  					np->full_name, chip->mmchip.gc.base);
> @@ -286,19 +325,19 @@ static const struct of_device_id xgpio_of_match[] = {
>  	{ /* end of list */ },
>  };
>  
> -static int __init xgpio_init(void)
> -{
> -	struct device_node *np;
> -
> -	for_each_matching_node(np, xgpio_of_match)
> -		xgpio_of_probe(np);
> +MODULE_DEVICE_TABLE(of, xgpio_of_match);
>  
> -	return 0;
> -}
> +static struct platform_driver xgpio_plat_driver = {
> +	.probe		= xgpio_probe,
> +	.remove		= xgpio_remove,
> +	.driver		= {
> +			.name = "gpio-xilinx",
> +			.owner = THIS_MODULE,

remove this line - it was the part of resent cleanup

> +			.of_match_table	= xgpio_of_match,
> +	},
> +};
>  
> -/* Make sure we get initialized before anyone else tries to use us */
> -subsys_initcall(xgpio_init);
> -/* No exit call at the moment as we cannot unregister of GPIO chips */
> +module_platform_driver(xgpio_plat_driver);

subsys is 4. module_platform is different level that's why you are changing
order here. You shouldn't do it. Just keep the same level because
some drivers can depend on it.

Thanks,
Michal
