Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaLPKSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:18:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:55221 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaLPKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:18:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,585,1413270000"; 
   d="scan'208";a="648368656"
Date: Tue, 16 Dec 2014 12:16:26 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ken Xue <Ken.Xue@amd.com>
Cc: rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] acpi:lpss:Refine lpss codes to fit acpi soc.
Message-ID: <20141216101626.GW1300@lahna.fi.intel.com>
References: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:05:51AM +0800, Ken Xue wrote:

This is missing changelog.

> Signed-off-by: Ken Xue <Ken.Xue@amd.com>

...

> +static int lpss_common_setup(struct acpi_soc_dev_private_data *pdata)
>  {
> -	struct lpss_device_desc *dev_desc;
> -	struct lpss_private_data *pdata;
> -	struct resource_list_entry *rentry;
> -	struct list_head resource_list;
> -	struct platform_device *pdev;
> -	int ret;
> -
> -	dev_desc = (struct lpss_device_desc *)id->driver_data;
> -	if (!dev_desc) {
> -		pdev = acpi_create_platform_device(adev);
> -		return IS_ERR_OR_NULL(pdev) ? PTR_ERR(pdev) : 1;
> -	}
> -	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> -	if (!pdata)
> -		return -ENOMEM;
> -
> -	INIT_LIST_HEAD(&resource_list);
> -	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
> -	if (ret < 0)
> -		goto err_out;
> -
> -	list_for_each_entry(rentry, &resource_list, node)
> -		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> -			if (dev_desc->prv_size_override)
> -				pdata->mmio_size = dev_desc->prv_size_override;
> -			else
> -				pdata->mmio_size = resource_size(&rentry->res);
> -			pdata->mmio_base = ioremap(rentry->res.start,
> -						   pdata->mmio_size);
> -			break;
> -		}
> -
> -	acpi_dev_free_resource_list(&resource_list);
> +	int ret = 0;
> +	struct acpi_soc_dev_desc *dev_desc;


Please order these so that the longest line is on top. E.g

	struct acpi_soc_dev_desc *dev_desc;
	int ret = 0;

Ditto for other similar places.

>  
> -	pdata->dev_desc = dev_desc;
> +	dev_desc = pdata->dev_desc;
>  
> -	if (dev_desc->setup)
> -		dev_desc->setup(pdata);
> +	if (dev_desc->flags & LPSS_CLK)
> +		ret = register_device_clock(pdata->adev, pdata);
>  
> -	if (dev_desc->flags & LPSS_CLK) {
> -		ret = register_device_clock(adev, pdata);
> -		if (ret) {
> -			/* Skip the device, but continue the namespace scan. */
> -			ret = 0;
> -			goto err_out;
> -		}
> -	}
> +	return ret;
> +}

...

>  void __init acpi_lpss_init(void)
>  {
>  	if (!lpt_clk_init()) {
> -		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
> -		acpi_scan_add_handler(&lpss_handler);
> +		a_soc.ids = acpi_lpss_device_ids;
> +		a_soc.attr_group = &lpss_attr_group;
> +		a_soc.pm_domain = &acpi_lpss_pm_domain;

If AMD stuff is not needing PM domain or LTR, I suggest that you leave
both to be part of LPSS and not move them to acpi_soc.

> +		register_acpi_soc(&a_soc, true);
                                          ^^^^ This needs to be false

>  	}
>  }
