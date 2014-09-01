Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaIALiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:38:19 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:50420 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaIALiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:38:16 -0400
Date: Mon, 1 Sep 2014 12:38:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v1 1/5] mfd: lpc_sch: reduce duplicate code
Message-ID: <20140901113805.GO7374@lee--X1>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140901091317.GG7374@lee--X1>
 <1409566903.30155.47.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409566903.30155.47.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Andy Shevchenko wrote:

> On Mon, 2014-09-01 at 10:13 +0100, Lee Jones wrote:
> > On Fri, 22 Aug 2014, Andy Shevchenko wrote:
> > 
> > > This patch refactors the driver to use helper functions instead of
> > > copy'n'pasted pieces of code.
> > > 
> > > Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >  drivers/mfd/lpc_sch.c | 146 ++++++++++++++++++++++----------------------------
> > >  1 file changed, 64 insertions(+), 82 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> > > index 4ee7550..0f01ef0 100644
> > > --- a/drivers/mfd/lpc_sch.c
> > > +++ b/drivers/mfd/lpc_sch.c
> > > @@ -40,41 +40,6 @@
> > 
> > [...]
> 
> Thanks for review, my answers below.
> 
> > 
> > > -static int lpc_sch_probe(struct pci_dev *dev,
> > > -				const struct pci_device_id *id)
> > > +static int lpc_sch_get_io(struct pci_dev *pdev, int where, const char *name,
> > > +			  struct resource *res, int size)
> > >  {
> > >  	unsigned int base_addr_cfg;
> > >  	unsigned short base_addr;
> > > -	int i, cells = 0;
> > > -	int ret;
> > >  
> > > -	pci_read_config_dword(dev, SMBASE, &base_addr_cfg);
> > > +	pci_read_config_dword(pdev, where, &base_addr_cfg);
> > >  	base_addr = 0;
> > >  	if (!(base_addr_cfg & (1 << 31)))
> > > -		dev_warn(&dev->dev, "Decode of the SMBus I/O range disabled\n");
> > > +		dev_warn(&pdev->dev, "Decode of the %s I/O range disabled\n",
> > > +			 name);
> > >  	else
> > >  		base_addr = (unsigned short)base_addr_cfg;
> > >  
> > >  	if (base_addr == 0) {
> > > -		dev_warn(&dev->dev, "I/O space for SMBus uninitialized\n");
> > > -	} else {
> > > -		lpc_sch_cells[cells++] = isch_smbus_cell;
> > > -		smbus_sch_resource.start = base_addr;
> > > -		smbus_sch_resource.end = base_addr + SMBUS_IO_SIZE - 1;
> > > +		dev_warn(&pdev->dev, "I/O space for %s uninitialized\n", name);
> > > +		return -ENODEV;
> > 
> > If you're going to return an error, you need to use dev_err() above.
> 
> Okay.
> 
> > >  	}
> > >  
> > > -	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> > > -	base_addr = 0;
> > > -	if (!(base_addr_cfg & (1 << 31)))
> > > -		dev_warn(&dev->dev, "Decode of the GPIO I/O range disabled\n");
> > > +	res->start = base_addr;
> > > +	res->end = base_addr + size - 1;
> > > +	res->flags = IORESOURCE_IO;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int lpc_sch_populate_cell(struct pci_dev *pdev, int where,
> > > +				 const char *name, int size, int id,
> > > +				 struct mfd_cell *cell)
> > > +{
> > > +	struct resource *res;
> > > +	int ret;
> > > +
> > > +	res = devm_kzalloc(&pdev->dev, sizeof(*res), GFP_KERNEL);
> > > +	if (!res)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = lpc_sch_get_io(pdev, where, name, res, size);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	memset(cell, 0, sizeof(*cell));
> > > +
> > > +	cell->name = name;
> > > +	cell->resources = res;
> > > +	cell->num_resources = 1;
> > > +	cell->ignore_resource_conflicts = true;
> > > +	cell->id = id;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int lpc_sch_probe(struct pci_dev *dev,
> > > +			 const struct pci_device_id *id)
> > > +{
> > > +	struct mfd_cell lpc_sch_cells[3];
> > > +	int size, cells = 0;
> > > +	int ret;
> > > +
> > > +	ret = lpc_sch_populate_cell(dev, SMBASE, "isch_smbus", SMBUS_IO_SIZE,
> > > +				    id->device, &lpc_sch_cells[cells]);
> > > +	if (!ret)
> > > +		cells++;
> > 
> > You're masking errors here.  You need to return on error.
> 
> No, I don't. It's a local error, I just need to understand if the HW has
> or hasn't the IP part we're looking for.

Yes, you do.  -ENOMEM is not a local error, it needs to be returned.

> I could, let's say, return true or false, if you prefer, with the above
> meaning.

I don't see this very often, which makes me wonder if it's the right
thing to do at all; however, if you're going to this then please
return a local state, instead of a Linux Error Code.

#define LCP_SKIP_RESOURCE /* Seems resonable? */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
