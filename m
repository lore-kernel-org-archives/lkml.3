Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404Ab3FSXxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:53:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43463 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934604Ab3FSXxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:53:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: override SDIO device's private register space size
Date: Thu, 20 Jun 2013 02:03:09 +0200
Message-ID: <6213625.DjAp0zuuFf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371563495-7325-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1371563495-7325-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 18, 2013 04:51:35 PM Mika Westerberg wrote:
> The SDIO device in Lynxpoint has its LTR registers allocated for a WiFi
> device (a child of the SDIO device) instead in ACPI namespace even though
> they physically belong to the SDIO device. In order to be able to access
> the LTR registers from the ACPI LPSS driver for diagnostic purposes we need
> to enlarge size of this private register space.
> 
> Work around this by adding a possibility to override size of the private
> register space in the ACPI LPSS driver and set correct size for the SDIO
> device.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Applies on top of https://patchwork.kernel.org/patch/2742521/ (ACPI / LPSS:
> Power up LPSS devices during enumeration)

Queued up for 3.11.

Thanks,
Rafael


>  drivers/acpi/acpi_lpss.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index a14d997..539aeae 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -44,6 +44,7 @@ struct lpss_device_desc {
>  	const char *clkdev_name;
>  	bool ltr_required;
>  	unsigned int prv_offset;
> +	size_t prv_size_override;
>  	bool clk_gate;
>  	struct lpss_shared_clock *shared_clock;
>  };
> @@ -69,6 +70,7 @@ static struct lpss_device_desc lpt_dev_desc = {
>  
>  static struct lpss_device_desc lpt_sdio_dev_desc = {
>  	.prv_offset = 0x1000,
> +	.prv_size_override = 0x1018,
>  	.ltr_required = true,
>  };
>  
> @@ -226,7 +228,10 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>  
>  	list_for_each_entry(rentry, &resource_list, node)
>  		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> -			pdata->mmio_size = resource_size(&rentry->res);
> +			if (dev_desc->prv_size_override)
> +				pdata->mmio_size = dev_desc->prv_size_override;
> +			else
> +				pdata->mmio_size = resource_size(&rentry->res);
>  			pdata->mmio_base = ioremap(rentry->res.start,
>  						   pdata->mmio_size);
>  			pdata->dev_desc = dev_desc;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
