Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaH1L3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:29:15 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62894 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaH1L3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:29:11 -0400
Date: Thu, 28 Aug 2014 12:29:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/9] mfd: Add ACPI support
Message-ID: <20140828112900.GM24579@lee--X1>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
 <1408255459-17625-6-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408255459-17625-6-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014, Mika Westerberg wrote:

> If an MFD device is backed by ACPI namespace, we should allow subdevice
> drivers to access their corresponding ACPI companion devices through normal
> means (e.g using ACPI_COMPANION()).
> 
> This patch adds such support to the MFD core. If the MFD parent device
> doesn't specify any ACPI _HID/_CID for the child device, the child device
> will share the parent ACPI companion device. Otherwise the child device
> will be assigned with the corresponding ACPI companion, if found in the
> namespace below the parent.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> ---
>  Documentation/acpi/enumeration.txt | 27 +++++++++++++++++++++++++
>  drivers/mfd/mfd-core.c             | 41 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/core.h           |  3 +++
>  3 files changed, 71 insertions(+)
> 
> diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> index e182be5e3c83..74e35c54febf 100644
> --- a/Documentation/acpi/enumeration.txt
> +++ b/Documentation/acpi/enumeration.txt
> @@ -312,3 +312,30 @@ a code like this:
>  
>  There are also devm_* versions of these functions which release the
>  descriptors once the device is released.
> +
> +MFD devices
> +~~~~~~~~~~~
> +The MFD devices create platform devices from their children. For the
> +child devices there needs to be an ACPI handle that they can use to
> +reference parts of the ACPI namespace that relate to them. In the Linux
> +MFD subsystem we provide two ways:
> +
> +	o The children share the parent ACPI handle.
> +	o The MFD cell can specify the ACPI id of the device.
> +
> +For the first case, the MFD drivers do not need to do anything. The
> +resulting child platform device will have its ACPI_COMPANION() set to point
> +to the parent device.
> +
> +If the ACPI namespace has a device that we can match using an ACPI id,
> +the id should be set like:
> +
> +	static struct mfd_cell my_subdevice_cell = {
> +		.name = "my_subdevice",
> +		/* set the resources relative to the parent */
> +		.acpi_pnpid = "XYZ0001",
> +	};
> +
> +The ACPI id "XYZ0001" is then used to lookup an ACPI device directly under
> +the MFD device and if found, that ACPI companion device is bound to the
> +resulting child platform device.
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 892d343193ad..bb466b28b3b6 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -78,6 +78,45 @@ static int mfd_platform_add_cell(struct platform_device *pdev,
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_ACPI)
> +static void mfd_acpi_add_device(const struct mfd_cell *cell,
> +				struct platform_device *pdev)
> +{
> +	struct acpi_device *parent_adev;
> +	struct acpi_device *adev = NULL;
> +
> +	parent_adev = ACPI_COMPANION(pdev->dev.parent);
> +	if (!parent_adev)
> +		return;
> +
> +	/*
> +	 * MFD child device gets its ACPI handle either from the ACPI
> +	 * device directly under the parent that matches the acpi_pnpid or
> +	 * it will use the parent handle if is no acpi_pnpid is given.
> +	 */
> +	if (cell->acpi_pnpid) {
> +		struct acpi_device_id ids[2] = {};
> +		struct acpi_device *child_adev;
> +
> +		strlcpy(ids[0].id, cell->acpi_pnpid, sizeof(ids[0].id));
> +		list_for_each_entry(child_adev, &parent_adev->children, node)
> +			if (acpi_match_device_ids(child_adev, ids)) {
> +				adev = child_adev;
> +				break;
> +			}

What happens if cell->acpi_pnpid is provided, but not matched?

Surely adev will them be NULL?

In these cases shouldn't you then "adev = parent_adev"?

> +	} else {
> +		adev = parent_adev;
> +	}
> +
> +	ACPI_COMPANION_SET(&pdev->dev, adev);
> +}
> +#else
> +static inline void mfd_acpi_add_device(const struct mfd_cell *cell,
> +				       struct platform_device *pdev)
> +{
> +}
> +#endif
> +
>  static int mfd_add_device(struct device *parent, int id,
>  			  const struct mfd_cell *cell, atomic_t *usage_count,
>  			  struct resource *mem_base,
> @@ -118,6 +157,8 @@ static int mfd_add_device(struct device *parent, int id,
>  		}
>  	}
>  
> +	mfd_acpi_add_device(cell, pdev);
> +
>  	if (cell->pdata_size) {
>  		ret = platform_device_add_data(pdev,
>  					cell->platform_data, cell->pdata_size);
> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index f543de91ce19..73e1709d4c09 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -44,6 +44,9 @@ struct mfd_cell {
>  	 */
>  	const char		*of_compatible;
>  
> +	/* Matches ACPI PNP id, either _HID or _CID */
> +	const char		*acpi_pnpid;
> +
>  	/*
>  	 * These resources can be specified relative to the parent device.
>  	 * For accessing hardware you should use resources from the platform dev

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
