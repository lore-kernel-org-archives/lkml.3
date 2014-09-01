Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaIALcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:32:06 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35237 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaIALcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:32:04 -0400
Date: Mon, 1 Sep 2014 12:31:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v1 4/5] mfd: lpc_sch: Add support for Intel Quark X1000
Message-ID: <20140901113158.GN7374@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-5-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140901092208.GI7374@lee--X1>
 <1409567306.30155.51.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409567306.30155.51.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Andy Shevchenko wrote:

> On Mon, 2014-09-01 at 10:22 +0100, Lee Jones wrote:
> > On Fri, 22 Aug 2014, Andy Shevchenko wrote:
> > 
> > > Intel Quark X1000 SoC supports IRQ based GPIO. This patch will
> > > enable MFD support for Quark X1000 and provide IRQ resources
> > > to Quark X1000 GPIO device driver.
> > > 
> > > Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > > Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> See my answers below.
> 
> > > ---
> > >  drivers/mfd/lpc_sch.c | 41 +++++++++++++++++++++++++++++++++++------
> > >  1 file changed, 35 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> > > index c4eb359..6145a4c 100644
> > > --- a/drivers/mfd/lpc_sch.c
> > > +++ b/drivers/mfd/lpc_sch.c
> > > @@ -37,6 +37,9 @@
> > >  #define GPIO_IO_SIZE	64
> > >  #define GPIO_IO_SIZE_CENTERTON	128
> > >  
> > > +/* Intel Quark X1000 GPIO IRQ Number */
> > > +#define GPIO_IRQ_QUARK_X1000	9
> > > +
> > >  #define WDTBASE		0x84
> > >  #define WDT_IO_SIZE	64
> > >  
> > > @@ -44,28 +47,37 @@ enum sch_chipsets {
> > >  	LPC_SCH = 0,		/* Intel Poulsbo SCH */
> > >  	LPC_ITC,		/* Intel Tunnel Creek */
> > >  	LPC_CENTERTON,		/* Intel Centerton */
> > > +	LPC_QUARK_X1000,	/* Intel Quark X1000 */
> > >  };
> > >  
> > >  struct lpc_sch_info {
> > >  	unsigned int io_size_smbus;
> > >  	unsigned int io_size_gpio;
> > >  	unsigned int io_size_wdt;
> > > +	int irq_gpio;
> > >  };
> > >  
> > >  static struct lpc_sch_info sch_chipset_info[] = {
> > >  	[LPC_SCH] = {
> > >  		.io_size_smbus = SMBUS_IO_SIZE,
> > >  		.io_size_gpio = GPIO_IO_SIZE,
> > > +		.irq_gpio = -1,
> > >  	},
> > >  	[LPC_ITC] = {
> > >  		.io_size_smbus = SMBUS_IO_SIZE,
> > >  		.io_size_gpio = GPIO_IO_SIZE,
> > >  		.io_size_wdt = WDT_IO_SIZE,
> > > +		.irq_gpio = -1,
> > >  	},
> > >  	[LPC_CENTERTON] = {
> > >  		.io_size_smbus = SMBUS_IO_SIZE,
> > >  		.io_size_gpio = GPIO_IO_SIZE_CENTERTON,
> > >  		.io_size_wdt = WDT_IO_SIZE,
> > > +		.irq_gpio = -1,
> > > +	},
> > > +	[LPC_QUARK_X1000] = {
> > > +		.io_size_gpio = GPIO_IO_SIZE,
> > > +		.irq_gpio = GPIO_IRQ_QUARK_X1000,
> > >  	},
> > >  };
> > >  
> > > @@ -73,6 +85,7 @@ static const struct pci_device_id lpc_sch_ids[] = {
> > >  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC), LPC_SCH },
> > >  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ITC_LPC), LPC_ITC },
> > >  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_CENTERTON_ILB), LPC_CENTERTON },
> > > +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB), LPC_QUARK_X1000 },
> > >  	{ 0, }
> > >  };
> > >  MODULE_DEVICE_TABLE(pci, lpc_sch_ids);
> > > @@ -106,14 +119,26 @@ static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
> > >  	return 0;
> > >  }
> > >  
> > > +static int lpc_sch_get_irq(struct resource *res, int irq)
> > > +{
> > > +	if (irq < 0)
> > > +		return -EINVAL;
> > > +
> > > +	res->start = irq;
> > > +	res->end = irq;
> > > +	res->flags = IORESOURCE_IRQ;
> > > +
> > > +	return 0;
> > > +}
> > 
> > Why does this need to be a separate function?
> > 
> > I fear that the code will become unnecessarily fragmented, just for the
> > sake of it.
> 
> I could do this as a condition branch.

You could, but you don't.

> > >  static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
> > > -				 const char *name, int size, int id,
> > > -				 struct mfd_cell *cell)
> > > +				 const char *name, int size, int irq,
> > > +				 int id, struct mfd_cell *cell)
> > >  {
> > >  	struct resource *res;
> > >  	int ret;
> > >  
> > > -	res = devm_kzalloc(&pdev->dev, sizeof(*res), GFP_KERNEL);
> > > +	res = devm_kcalloc(&pdev->dev, 2, sizeof(*res), GFP_KERNEL);
> > >  	if (!res)
> > >  		return -ENOMEM;
> > >  
> > > @@ -129,6 +154,10 @@ static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
> > >  	cell->ignore_resource_conflicts = true;
> > >  	cell->id = id;
> > >  
> > > +	ret = lpc_sch_get_irq(++res, irq);
> > > +	if (!ret)
> > > +		cell->num_resources++;
> > 
> > Once again, you're masking errors.  If it's not an error, don't return
> > one.  If it is, filter it back and fail the bind.
> 
> I have to know if there is such resource or not. Taking into account you
> prefer to see lpc_sch_get_irq embedded in here I just can do as a
> condition branch and there will be no more question I hope.

This is true.

> > >  	return 0;
> > >  }
> > >  
> > > @@ -141,19 +170,19 @@ static int lpc_sch_probe(struct pci_dev *dev,
> > >  	int ret;
> > >  
> > >  	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus",
> > > -				    info->io_size_smbus,
> > > +				    info->io_size_smbus, -1,
> > >  				    id->device, &lpc_sch_cells[cells]);
> > >  	if (!ret)
> > >  		cells++;
> > >  
> > >  	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio",
> > > -				    info->io_size_gpio,
> > > +				    info->io_size_gpio, info->irq_gpio,
> > >  				    id->device, &lpc_sch_cells[cells]);
> > >  	if (!ret)
> > >  		cells++;
> > >  
> > >  	ret = lpc_sch_populate_cell(dev, WDTBASE, "ie6xx_wdt",
> > > -				    info->io_size_wdt,
> > > +				    info->io_size_wdt, -1,
> > >  				    id->device, &lpc_sch_cells[cells]);
> > >  	if (!ret)
> > >  		cells++;
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
