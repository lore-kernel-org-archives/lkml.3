Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaLHHJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:09:41 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45492 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHHJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:09:40 -0500
Message-ID: <54854EAC.8090504@linaro.org>
Date: Mon, 08 Dec 2014 08:09:32 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org
CC: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI, EINJ: Enhance error injection tolerance level
References: <c5f50564109273ab7f1c5fab4490169ae573128d.1417641347.git.tony.luck@intel.com>
In-Reply-To: <c5f50564109273ab7f1c5fab4490169ae573128d.1417641347.git.tony.luck@intel.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 03.12.2014 o 22:22, Luck, Tony pisze:
> From: "Chen, Gong" <gong.chen@linux.intel.com>
>
> Some BIOSes utilize PCI MMCFG space read/write opertion to trigger
> specific errors. EINJ will report errors as below when hitting such
> cases:
>
> APEI: Can not request [mem 0x83f990a0-0x83f990a3] for APEI EINJ Trigger registers
>
> It is because on x86 platform ACPI based PCI MMCFG logic has
> reserved all MMCFG spaces so that EINJ can't reserve it again.
> We already trust the ACPI/APEI code when using the EINJ interface
> so it is not a big leap to also trust it to access the right
> MMCFG addresses. Skip address checking to allow the access.
>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   drivers/acpi/apei/apei-base.c | 58 ++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 52 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
> index 2cd7bdd6c8b3..e809d3c4904d 100644
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -41,6 +41,9 @@
>   #include <linux/interrupt.h>
>   #include <linux/debugfs.h>
>   #include <asm/unaligned.h>
> +#ifdef CONFIG_PCI_MMCONFIG
> +#include <asm/pci_x86.h>
> +#endif
>
>   #include "apei-internal.h"
>
> @@ -449,7 +452,7 @@ int apei_resources_sub(struct apei_resources *resources1,
>   }
>   EXPORT_SYMBOL_GPL(apei_resources_sub);
>
> -static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
> +static int apei_get_res_callback(__u64 start, __u64 size, void *data)
>   {
>   	struct apei_resources *resources = data;
>   	return apei_res_add(&resources->iomem, start, size);
> @@ -457,9 +460,42 @@ static int apei_get_nvs_callback(__u64 start, __u64 size, void *data)
>
>   static int apei_get_nvs_resources(struct apei_resources *resources)
>   {
> -	return acpi_nvs_for_each_region(apei_get_nvs_callback, resources);
> +	return acpi_nvs_for_each_region(apei_get_res_callback, resources);
>   }
>
> +#ifdef CONFIG_PCI_MMCONFIG
> +static int pci_mmcfg_for_each_region(int (*func)(__u64 start, __u64 size,
> +				     void *data), void *data)
> +{
> +	struct pci_mmcfg_region *cfg;
> +	int rc;
> +
> +	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
> +		return 0;
> +
> +	if (list_empty(&pci_mmcfg_list))
> +		return 0;
> +
> +	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
> +		rc = func(cfg->res.start, resource_size(&cfg->res), data);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int apei_get_mmcfg_resources(struct apei_resources *resources)
> +{
> +	return pci_mmcfg_for_each_region(apei_get_res_callback, resources);
> +}
> +#else
> +static int apei_get_mmcfg_resources(struct apei_resources *resources)
> +{
> +	return 0;
> +}
> +#endif
> +

If this is the case for x86 only, IMHO it should be wrapped into:
#if CONFIG_X86 && CONFIG_PCI_MMCONFIG or something similar.

If it solves problem related to ACPI, you should not use in this file:
 > +	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 > +		return 0;
This is very x86 specific. We are making a lot of effort to make 
MMCONFIG platform independent now.

Regards,
Tomasz
