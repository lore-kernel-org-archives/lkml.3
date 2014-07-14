Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaGNTvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:51:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48638 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbaGNTvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:51:44 -0400
Date: Mon, 14 Jul 2014 21:51:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: clemens@ladisch.de, jdelvare@suse.de, linux@roeck-us.net,
        rdunlap@infradead.org, bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
Message-ID: <20140714195128.GA25124@pd.tnic>
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
> This patch adds temperature monitoring support for F15h M60h processor.
>  - Add new pci device id for the relevant processor
>  - The functionality of REG_REPORTED_TEMPERATURE is moved to
>    D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>    - So, use this to get CUR_TEMP value
>  - Add Kconfig, Doc entries to indicate support for this processor.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  Documentation/hwmon/k10temp |  2 +-
>  drivers/hwmon/Kconfig       |  4 ++--
>  drivers/hwmon/k10temp.c     | 22 ++++++++++++++++++++--
>  include/linux/pci_ids.h     |  1 +
>  4 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/hwmon/k10temp b/Documentation/hwmon/k10temp
> index ee6d30e..254d2f5 100644
> --- a/Documentation/hwmon/k10temp
> +++ b/Documentation/hwmon/k10temp
> @@ -11,7 +11,7 @@ Supported chips:
>    Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
>  * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
>  * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
> -* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity", "Kaveri"
> +* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity", "Kaveri", "Carrizo"
>  * AMD Family 16h processors: "Kabini", "Mullins"
>  
>    Prefix: 'k10temp'
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 02d3d85..57ba400 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -280,8 +280,8 @@ config SENSORS_K10TEMP
>  	  If you say yes here you get support for the temperature
>  	  sensor(s) inside your CPU. Supported are later revisions of
>  	  the AMD Family 10h and all revisions of the AMD Family 11h,
> -	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity/Kaveri) and
> -	  16h (Kabini/Mullins) microarchitectures.
> +	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity/Kaveri/Carrizo)
> +	  and 16h (Kabini/Mullins) microarchitectures.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called k10temp.
> diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
> index f7b46f6..5da872f 100644
> --- a/drivers/hwmon/k10temp.c
> +++ b/drivers/hwmon/k10temp.c
> @@ -51,13 +51,30 @@ MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
>  #define REG_NORTHBRIDGE_CAPABILITIES	0xe8
>  #define  NB_CAP_HTC			0x00000400
>  
> +/*
> + * For F15h M60h, functionality of REG_REPORTED_TEMPERATURE
> + * has been moved to D0F0xBC_xD820_0CA4 [Reported Temperature
> + * Control]
> + */
> +#define NB_SMU_IND_ADDR			0xb8
> +#define NB_SMU_IND_DATA			0xbc
> +#define IND_ADDR_OFFSET			0xd8200ca4
> +
>  static ssize_t show_temp(struct device *dev,
>  			 struct device_attribute *attr, char *buf)
>  {
>  	u32 regval;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
> +		pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
> +					   NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
> +		pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
> +					  NB_SMU_IND_DATA, &regval);
> +
> +	} else
> +		pci_read_config_dword(pdev, REG_REPORTED_TEMPERATURE, &regval);
>  
> -	pci_read_config_dword(to_pci_dev(dev),
> -			      REG_REPORTED_TEMPERATURE, &regval);
>  	return sprintf(buf, "%u\n", (regval >> 21) * 125);
>  }
>  
> @@ -211,6 +228,7 @@ static const struct pci_device_id k10temp_id_table[] = {
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
>  	{}
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 7fa3173..3c8e328 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -520,6 +520,7 @@
>  #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
> +#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573

I'm assuming this is used somewhere else besides k10temp.c?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
