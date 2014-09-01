Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaIAJNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:13:23 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:51406 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:13:22 -0400
Date: Mon, 1 Sep 2014 10:13:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v1 1/5] mfd: lpc_sch: reduce duplicate code
Message-ID: <20140901091317.GG7374@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408705096-31286-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Andy Shevchenko wrote:

> This patch refactors the driver to use helper functions instead of
> copy'n'pasted pieces of code.
> 
> Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 146 ++++++++++++++++++++++----------------------------
>  1 file changed, 64 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index 4ee7550..0f01ef0 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -40,41 +40,6 @@

[...]

> -static int lpc_sch_probe(struct pci_dev *dev,
> -				const struct pci_device_id *id)
> +static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
> +			  struct resource *res, int size)
>  {
>  	unsigned int base_addr_cfg;
>  	unsigned short base_addr;
> -	int i, cells = 0;
> -	int ret;
>  
> -	pci_read_config_dword(dev, SMBASE, &base_addr_cfg);
> +	pci_read_config_dword(pdev, where, &base_addr_cfg);
>  	base_addr = 0;
>  	if (!(base_addr_cfg & (1 << 31)))
> -		dev_warn(&dev->dev, "Decode of the SMBus I/O range disabled\n");
> +		dev_warn(&pdev->dev, "Decode of the %s I/O range disabled\n",
> +			 name);
>  	else
>  		base_addr = (unsigned short)base_addr_cfg;
>  
>  	if (base_addr == 0) {
> -		dev_warn(&dev->dev, "I/O space for SMBus uninitialized\n");
> -	} else {
> -		lpc_sch_cells[cells++] = isch_smbus_cell;
> -		smbus_sch_resource.start = base_addr;
> -		smbus_sch_resource.end = base_addr + SMBUS_IO_SIZE - 1;
> +		dev_warn(&pdev->dev, "I/O space for %s uninitialized\n", name);
> +		return -ENODEV;

If you're going to return an error, you need to use dev_err() above.
>  	}
>  
> -	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> -	base_addr = 0;
> -	if (!(base_addr_cfg & (1 << 31)))
> -		dev_warn(&dev->dev, "Decode of the GPIO I/O range disabled\n");
> +	res->start = base_addr;
> +	res->end = base_addr + size - 1;
> +	res->flags = IORESOURCE_IO;
> +
> +	return 0;
> +}
> +
> +static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
> +				 const char *name, int size, int id,
> +				 struct mfd_cell *cell)
> +{
> +	struct resource *res;
> +	int ret;
> +
> +	res = devm_kzalloc(&pdev->dev, sizeof(*res), GFP_KERNEL);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	ret = lpc_sch_get_io(pdev, where, name, res, size);
> +	if (ret)
> +		return ret;
> +
> +	memset(cell, 0, sizeof(*cell));
> +
> +	cell->name = name;
> +	cell->resources = res;
> +	cell->num_resources = 1;
> +	cell->ignore_resource_conflicts = true;
> +	cell->id = id;
> +
> +	return 0;
> +}
> +
> +static int lpc_sch_probe(struct pci_dev *dev,
> +			 const struct pci_device_id *id)
> +{
> +	struct mfd_cell lpc_sch_cells[3];
> +	int size, cells = 0;
> +	int ret;
> +
> +	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus", SMBUS_IO_SIZE,
> +				    id->device, &lpc_sch_cells[cells]);
> +	if (!ret)
> +		cells++;

You're masking errors here.  You need to return on error.

> +	if (id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB)
> +		size = GPIO_IO_SIZE_CENTERTON;
>  	else
> -		base_addr = (unsigned short)base_addr_cfg;
> +		size = GPIO_IO_SIZE;
>  
> -	if (base_addr == 0) {
> -		dev_warn(&dev->dev, "I/O space for GPIO uninitialized\n");
> -	} else {
> -		lpc_sch_cells[cells++] = sch_gpio_cell;
> -		gpio_sch_resource.start = base_addr;
> -		if (id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB)
> -			gpio_sch_resource.end = base_addr + GPIO_IO_SIZE_CENTERTON - 1;
> -		else
> -			gpio_sch_resource.end = base_addr + GPIO_IO_SIZE - 1;
> -	}
> +	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio", size,
> +				    id->device, &lpc_sch_cells[cells]);
> +	if (!ret)
> +		cells++;
>  
>  	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC
>  	    || id->device == PCI_DEVICE_ID_INTEL_CENTERTON_ILB) {
> -		pci_read_config_dword(dev, WDTBASE, &base_addr_cfg);
> -		base_addr = 0;
> -		if (!(base_addr_cfg & (1 << 31)))
> -			dev_warn(&dev->dev, "Decode of the WDT I/O range disabled\n");
> -		else
> -			base_addr = (unsigned short)base_addr_cfg;
> -		if (base_addr == 0)
> -			dev_warn(&dev->dev, "I/O space for WDT uninitialized\n");
> -		else {
> -			lpc_sch_cells[cells++] = wdt_sch_cell;
> -			wdt_sch_resource.start = base_addr;
> -			wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
> -		}
> -	}
> -
> -	if (WARN_ON(cells > ARRAY_SIZE(lpc_sch_cells))) {
> -		dev_err(&dev->dev, "Cell count exceeds array size");
> -		return -ENODEV;
> +		ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
> +					    WDT_IO_SIZE,
> +					    id->device, &lpc_sch_cells[cells]);
> +		if (!ret)
> +			cells++;
>  	}
>  
>  	if (cells == 0) {
> @@ -151,9 +136,6 @@ static int lpc_sch_probe(struct pci_dev *dev,
>  		return -ENODEV;
>  	}
>  
> -	for (i = 0; i < cells; i++)
> -		lpc_sch_cells[i].id = id->device;
> -
>  	ret = mfd_add_devices(&dev->dev, 0, lpc_sch_cells, cells, NULL, 0, NULL);
>  	if (ret)
>  		mfd_remove_devices(&dev->dev);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
