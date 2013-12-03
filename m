Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3LCOOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:14:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:6170 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3LCOOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:14:06 -0500
Message-ID: <529DE722.70305@atmel.com>
Date: Tue, 3 Dec 2013 15:13:54 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] usb: ohci-at91: fix irq and iomem resource retrieval
References: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com> <1386079669-3995-2-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1386079669-3995-2-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 15:07, Boris BREZILLON :
> When using dt resources retrieval (interrupts and reg properties) there is
> no predefined order for these resources in the platform dev resource
> table.
>
> Retrieve resources using the platform_get_resource function instead of
> direct resource table entries to avoid resource type mismatch.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/usb/host/ohci-at91.c |   19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 418444e..7aec6ca 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -136,23 +136,26 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	struct ohci_hcd *ohci;
>   	int retval;
>   	struct usb_hcd *hcd = NULL;
> +	struct device *dev = &pdev->dev;
> +	struct resource *mem_r, *irq_r;
>
> -	if (pdev->num_resources != 2) {
> -		pr_debug("hcd probe: invalid num_resources");
> +	mem_r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem_r) {
> +		dev_dbg(dev, "hcd probe: missing memory resource\n");
>   		return -ENODEV;
>   	}
>
> -	if ((pdev->resource[0].flags != IORESOURCE_MEM)
> -			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
> -		pr_debug("hcd probe: invalid resource type\n");
> +	irq_r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!irq_r) {
> +		dev_dbg(dev, "hcd probe: missing irq resource\n");
>   		return -ENODEV;
>   	}
>
>   	hcd = usb_create_hcd(driver, &pdev->dev, "at91");
>   	if (!hcd)
>   		return -ENOMEM;
> -	hcd->rsrc_start = pdev->resource[0].start;
> -	hcd->rsrc_len = resource_size(&pdev->resource[0]);
> +	hcd->rsrc_start = mem_r->start;
> +	hcd->rsrc_len = resource_size(mem_r);
>
>   	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
>   		pr_debug("request_mem_region failed\n");
> @@ -199,7 +202,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	ohci->num_ports = board->ports;
>   	at91_start_hc(pdev);
>
> -	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
> +	retval = usb_add_hcd(hcd, irq_r->start, IRQF_SHARED);
>   	if (retval == 0)
>   		return retval;
>
>


-- 
Nicolas Ferre
