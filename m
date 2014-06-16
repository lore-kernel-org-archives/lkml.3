Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaFPJhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:37:16 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:35982 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaFPJhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:37:13 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 05:37:13 EDT
X-LISTENER: [mailrelay1.bredband.net]
X-SENDER-IP: [92.33.28.242]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAGW5nlNcIRzy/2dsb2JhbAANTcdRAYEnhHgBAQEBAgEnEUABBQsLFQMJFg8JAwIBAgEbKgYBDAEFAgEBiDYNsBKeexeOdgeEQwEDpXOLag
X-IPAS-Result: ApMBAGW5nlNcIRzy/2dsb2JhbAANTcdRAYEnhHgBAQEBAgEnEUABBQsLFQMJFg8JAwIBAgEbKgYBDAEFAgEBiDYNsBKeexeOdgeEQwEDpXOLag
X-IronPort-AV: E=Sophos;i="5.01,485,1400018400"; 
   d="scan'208";a="680934264"
Message-ID: <539EBA6F.7060008@gaisler.com>
Date: Mon, 16 Jun 2014 11:35:43 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: nyushchenko@dev.rtsoft.ru, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 20/21] usb: use devm_irq_of_parse_and_map() where appropriate
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1401880402-30091-21-git-send-email-nyushchenko@dev.rtsoft.ru>
In-Reply-To: <1401880402-30091-21-git-send-email-nyushchenko@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 13:13, nyushchenko@dev.rtsoft.ru wrote:
> From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
>
> This avoids leak of IRQ mapping on error paths, and makes it possible
> to use devm_request_irq() without facing unmap-while-handler-installed
> issues.
>
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> ---
>   drivers/usb/gadget/gr_udc.c       |   17 +++++++++++------
>   drivers/usb/host/ehci-grlib.c     |   11 ++++-------
>   drivers/usb/host/ehci-orion.c     |    3 ++-
>   drivers/usb/host/ehci-ppc-of.c    |   11 ++++-------
>   drivers/usb/host/ehci-xilinx-of.c |    8 ++++----
>   drivers/usb/host/ohci-ppc-of.c    |    7 ++-----
>   6 files changed, 27 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
> index f984ee7..0a3e586 100644
> --- a/drivers/usb/gadget/gr_udc.c
> +++ b/drivers/usb/gadget/gr_udc.c
> @@ -2108,19 +2108,24 @@ static int gr_probe(struct platform_device *ofdev)
>   	if (IS_ERR(regs))
>   		return PTR_ERR(regs);
>
> -	dev->irq = irq_of_parse_and_map(dev->dev->of_node, 0);
> -	if (!dev->irq) {
> +	dev->irq = devm_irq_of_parse_and_map(dev->dev, dev->dev->of_node, 0);
> +	if (dev->irq <= 0) {
>   		dev_err(dev->dev, "No irq found\n");
>   		return -ENODEV;
>   	}
>
>   	/* Some core configurations has separate irqs for IN and OUT events */
> -	dev->irqi = irq_of_parse_and_map(dev->dev->of_node, 1);
> +	dev->irqi = devm_irq_of_parse_and_map(dev->dev, dev->dev->of_node, 1);
> +	if (dev->irqi < 0) {
> +		dev_err(dev->dev, "could not locate irq\n");
> +		return dev->irqi;
> +	}
>   	if (dev->irqi) {
> -		dev->irqo = irq_of_parse_and_map(dev->dev->of_node, 2);
> -		if (!dev->irqo) {
> +		dev->irqo = devm_irq_of_parse_and_map(dev->dev,
> +				dev->dev->of_node, 2);
> +		if (dev->irqo <= 0) {
>   			dev_err(dev->dev, "Found irqi but not irqo\n");
> -			return -ENODEV;
> +			return dev->irqo ? dev->irqo : -ENODEV;
>   		}
>   	}
>
> diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
> index 495b6fb..666c03e 100644
> --- a/drivers/usb/host/ehci-grlib.c
> +++ b/drivers/usb/host/ehci-grlib.c
> @@ -111,11 +111,11 @@ static int ehci_hcd_grlib_probe(struct platform_device *op)
>   	hcd->rsrc_start = res.start;
>   	hcd->rsrc_len = resource_size(&res);
>
> -	irq = irq_of_parse_and_map(dn, 0);
> -	if (irq == NO_IRQ) {
> -		dev_err(&op->dev, "%s: irq_of_parse_and_map failed\n",
> +	irq = devm_irq_of_parse_and_map(&op->dev, dn, 0);
> +	if (irq <= 0) {
> +		dev_err(&op->dev, "%s: devm_irq_of_parse_and_map failed\n",
>   			__FILE__);
> -		rv = -EBUSY;
> +		rv = irq ? irq : -EINVAL;

Here and in more places below you change the return value from -EBUSY to 
-EINVAL when irq == 0. These changes and the reason for them is not 
something that is commented upon in the commit message. Maybe these 
changes were not intended or should be in a separate patch?

>   		goto err_irq;
>   	}
>
> @@ -145,7 +145,6 @@ static int ehci_hcd_grlib_probe(struct platform_device *op)
>   	return 0;
>
>   err_ioremap:
> -	irq_dispose_mapping(irq);
>   err_irq:
>   	usb_put_hcd(hcd);
>
> @@ -161,8 +160,6 @@ static int ehci_hcd_grlib_remove(struct platform_device *op)
>
>   	usb_remove_hcd(hcd);
>
> -	irq_dispose_mapping(hcd->irq);
> -
>   	usb_put_hcd(hcd);
>
>   	return 0;
> diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
> index 30d35e5..c88177b 100644
> --- a/drivers/usb/host/ehci-orion.c
> +++ b/drivers/usb/host/ehci-orion.c
> @@ -155,7 +155,8 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
>   	pr_debug("Initializing Orion-SoC USB Host Controller\n");
>
>   	if (pdev->dev.of_node)
> -		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +		irq = devm_irq_of_parse_and_map(&pdev->dev,
> +				pdev->dev.of_node, 0);
>   	else
>   		irq = platform_get_irq(pdev, 0);
>   	if (irq <= 0) {
> diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
> index 5479247..cc64210 100644
> --- a/drivers/usb/host/ehci-ppc-of.c
> +++ b/drivers/usb/host/ehci-ppc-of.c
> @@ -117,11 +117,11 @@ static int ehci_hcd_ppc_of_probe(struct platform_device *op)
>   	hcd->rsrc_start = res.start;
>   	hcd->rsrc_len = resource_size(&res);
>
> -	irq = irq_of_parse_and_map(dn, 0);
> -	if (irq == NO_IRQ) {
> -		dev_err(&op->dev, "%s: irq_of_parse_and_map failed\n",
> +	irq = devm_irq_of_parse_and_map(&op->dev, dn, 0);
> +	if (irq <= 0) {
> +		dev_err(&op->dev, "%s: devm_irq_of_parse_and_map failed\n",
>   			__FILE__);
> -		rv = -EBUSY;
> +		rv = irq ? irq : -EINVAL;
>   		goto err_irq;
>   	}
>
> @@ -174,7 +174,6 @@ static int ehci_hcd_ppc_of_probe(struct platform_device *op)
>   	return 0;
>
>   err_ioremap:
> -	irq_dispose_mapping(irq);
>   err_irq:
>   	usb_put_hcd(hcd);
>
> @@ -194,8 +193,6 @@ static int ehci_hcd_ppc_of_remove(struct platform_device *op)
>
>   	usb_remove_hcd(hcd);
>
> -	irq_dispose_mapping(hcd->irq);
> -
>   	/* use request_mem_region to test if the ohci driver is loaded.  if so
>   	 * ensure the ohci core is operational.
>   	 */
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> index fe57710..6c6f8c7 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -153,11 +153,11 @@ static int ehci_hcd_xilinx_of_probe(struct platform_device *op)
>   	hcd->rsrc_start = res.start;
>   	hcd->rsrc_len = resource_size(&res);
>
> -	irq = irq_of_parse_and_map(dn, 0);
> -	if (!irq) {
> -		dev_err(&op->dev, "%s: irq_of_parse_and_map failed\n",
> +	irq = devm_irq_of_parse_and_map(&op->dev, dn, 0);
> +	if (irq <= 0) {
> +		dev_err(&op->dev, "%s: devm_irq_of_parse_and_map failed\n",
>   			__FILE__);
> -		rv = -EBUSY;
> +		rv = irq ? irq : -EINVAL;
>   		goto err_irq;
>   	}
>
> diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
> index 965e3e9..fcdd23a 100644
> --- a/drivers/usb/host/ohci-ppc-of.c
> +++ b/drivers/usb/host/ohci-ppc-of.c
> @@ -121,11 +121,11 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
>   		goto err_rmr;
>   	}
>
> -	irq = irq_of_parse_and_map(dn, 0);
> +	irq = devm_irq_of_parse_and_map(*op->dev, dn, 0);
>   	if (irq == NO_IRQ) {
>   		dev_err(&op->dev, "%s: irq_of_parse_and_map failed\n",
>   			__FILE__);
> -		rv = -EBUSY;
> +		rv = irq ? irq : -EINVAL;
>   		goto err_rmr;
>   	}
>
> @@ -170,7 +170,6 @@ static int ohci_hcd_ppc_of_probe(struct platform_device *op)
>   			pr_debug("%s: cannot get ehci offset from fdt\n", __FILE__);
>   	}
>
> -	irq_dispose_mapping(irq);
>   err_rmr:
>    	usb_put_hcd(hcd);
>
> @@ -185,8 +184,6 @@ static int ohci_hcd_ppc_of_remove(struct platform_device *op)
>
>   	usb_remove_hcd(hcd);
>
> -	irq_dispose_mapping(hcd->irq);
> -
>   	usb_put_hcd(hcd);
>
>   	return 0;
>
