Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIAJQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:16:15 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46355 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAJQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:16:13 -0400
Date: Mon, 1 Sep 2014 10:16:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
 chipset info struct
Message-ID: <20140901091607.GH7374@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408705096-31286-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Andy Shevchenko wrote:

> Introduce additional struct to hold chipset info. This chipset
> info will be used to store features that are supported by specific
> processor or chipset. LPC_SCH supports SMBUS, GPIO and WDT features.
> As this code base might expand further to support more processors,
> this implementation will help to keep code base clean and manageable.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 65 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 46 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index 0f01ef0..c4eb359 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -40,10 +40,39 @@
>  #define WDTBASE		0x84
>  #define WDT_IO_SIZE	64
>  
> +enum sch_chipsets {
> +	LPC_SCH = 0,		/* Intel Poulsbo SCH */
> +	LPC_ITC,		/* Intel Tunnel Creek */
> +	LPC_CENTERTON,		/* Intel Centerton */
> +};
> +
> +struct lpc_sch_info {
> +	unsigned int io_size_smbus;
> +	unsigned int io_size_gpio;
> +	unsigned int io_size_wdt;
> +};
> +
> +static struct lpc_sch_info sch_chipset_info[] = {
> +	[LPC_SCH] = {
> +		.io_size_smbus = SMBUS_IO_SIZE,
> +		.io_size_gpio = GPIO_IO_SIZE,
> +	},
> +	[LPC_ITC] = {
> +		.io_size_smbus = SMBUS_IO_SIZE,
> +		.io_size_gpio = GPIO_IO_SIZE,
> +		.io_size_wdt = WDT_IO_SIZE,
> +	},
> +	[LPC_CENTERTON] = {
> +		.io_size_smbus = SMBUS_IO_SIZE,
> +		.io_size_gpio = GPIO_IO_SIZE_CENTERTON,
> +		.io_size_wdt = WDT_IO_SIZE,
> +	},
> +};
> +
>  static const struct pci_device_id lpc_sch_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC), LPC_SCH },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC), LPC_ITC },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB), LPC_CENTERTON },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
> @@ -54,6 +83,9 @@ static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
>  	unsigned int base_addr_cfg;
>  	unsigned short base_addr;
>  
> +	if (size == 0)
> +		return -EINVAL;
> +
>  	pci_read_config_dword(pdev, where, &base_addr_cfg);
>  	base_addr = 0;
>  	if (!(base_addr_cfg & (1 << 31)))
> @@ -104,32 +136,27 @@ static int lpc_sch_probe(struct pci_dev *dev,
>  			 const struct pci_device_id *id)
>  {
>  	struct mfd_cell lpc_sch_cells[3];
> -	int size, cells = 0;
> +	struct lpc_sch_info *info = &sch_chipset_info[id->driver_data];
> +	int cells = 0;
>  	int ret;
>  
> -	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus", SMBUS_IO_SIZE,
> +	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus",
> +				    info->io_size_smbus,
>  				    id->device, &lpc_sch_cells[cells]);
>  	if (!ret)
>  		cells++;
>  
> -	if (id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB)
> -		size = GPIO_IO_SIZE_CENTERTON;
> -	else
> -		size = GPIO_IO_SIZE;
> -
> -	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio", size,
> +	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio",
> +				    info->io_size_gpio,
>  				    id->device, &lpc_sch_cells[cells]);
>  	if (!ret)
>  		cells++;
>  
> -	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC
> -	    || id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB) {
> -		ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
> -					    WDT_IO_SIZE,
> -					    id->device, &lpc_sch_cells[cells]);
> -		if (!ret)
> -			cells++;
> -	}
> +	ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
> +				    info->io_size_wdt,
> +				    id->device, &lpc_sch_cells[cells]);
> +	if (!ret)
> +		cells++;

The first patch would look a great deal cleaner if it had these
changes in too.  Unless you have a really good reason not to, please
consider squashing them.

>  	if (cells == 0) {
>  		dev_err(&dev->dev, "All decode registers disabled.\n");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
