Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3EVIBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:01:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:28724 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3EVIBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:01:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="245017462"
Date: Wed, 22 May 2013 11:05:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] gpio-langwell: use managed functions pcim_* and
 devm_*
Message-ID: <20130522080529.GW11878@intel.com>
References: <1369208859-16514-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1369208859-16514-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369208859-16514-4-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:47:38AM +0300, Andy Shevchenko wrote:
> This makes the error handling much more simpler than open-coding everything and
> in addition makes the probe function smaller an tidier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

In general this change looks good. Getting rid of 61 lines is certainly an
improvement!

David, are you able to check that this still works on your hardware? (I'm
pretty sure that Andy has tested this already on Medfield)

I have few minor comments, though. See below.

> ---
>  drivers/gpio/gpio-langwell.c | 82 ++++++++++++--------------------------------
>  1 file changed, 21 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index 8203084..8672282 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -320,56 +320,35 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
>  static int lnw_gpio_probe(struct pci_dev *pdev,
>  			  const struct pci_device_id *id)
>  {
> -	void __iomem *base;
> -	resource_size_t start, len;
>  	struct lnw_gpio *lnw;
>  	u32 gpio_base;
>  	u32 irq_base;
>  	int retval;
>  	int ngpio = id->driver_data;
>  
> -	retval = pci_enable_device(pdev);
> +	retval = pcim_enable_device(pdev);
>  	if (retval)
>  		return retval;
>  
> -	retval = pci_request_regions(pdev, "langwell_gpio");
> +	retval = pcim_iomap_regions(pdev, 1 << 0 | 1 << 1, pci_name(pdev));

I wonder if "langwell_gpio" is still a better name compared to
pci_name(pdev)?

>  	if (retval) {
> -		dev_err(&pdev->dev, "error requesting resources\n");
> -		goto err_pci_req_region;
> -	}
> -	/* get the gpio_base from bar1 */
> -	start = pci_resource_start(pdev, 1);
> -	len = pci_resource_len(pdev, 1);
> -	base = ioremap_nocache(start, len);
> -	if (!base) {
> -		dev_err(&pdev->dev, "error mapping bar1\n");
> -		retval = -EFAULT;
> -		goto err_ioremap;
> +		dev_err(&pdev->dev, "I/O memory mapping error\n");
> +		return retval;
>  	}
>  
> -	irq_base = readl(base);
> -	gpio_base = readl(sizeof(u32) + base);
> +	irq_base = readl(pcim_iomap_table(pdev)[1]);
> +	gpio_base = readl(sizeof(u32) + pcim_iomap_table(pdev)[1]);

Using pcim_iomap_table(pdev)[] is a bit confusing, at least for me. Can you
add a variable where you store that pointer and use that instead?

>  	/* release the IO mapping, since we already get the info from bar1 */
> -	iounmap(base);
> -	/* get the register base from bar0 */
> -	start = pci_resource_start(pdev, 0);
> -	len = pci_resource_len(pdev, 0);
> -	base = devm_ioremap_nocache(&pdev->dev, start, len);
> -	if (!base) {
> -		dev_err(&pdev->dev, "error mapping bar0\n");
> -		retval = -EFAULT;
> -		goto err_ioremap;
> -	}
> +	pcim_iounmap_regions(pdev, 1 << 1);
>  
>  	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
>  	if (!lnw) {
>  		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
> -		retval = -ENOMEM;
> -		goto err_ioremap;
> +		return -ENOMEM;
>  	}
>  
> -	lnw->reg_base = base;
> +	lnw->reg_base = pcim_iomap_table(pdev)[0];
>  	lnw->chip.label = dev_name(&pdev->dev);
>  	lnw->chip.request = lnw_gpio_request;
>  	lnw->chip.direction_input = lnw_gpio_direction_input;
