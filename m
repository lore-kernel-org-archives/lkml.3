Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaBRXWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:22:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37944 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaBRXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:22:45 -0500
Date: Tue, 18 Feb 2014 17:20:17 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mcb: Add PCI carrier for MEN Chameleon Bus
Message-ID: <20140218232017.GA31820@joshc.qualcomm.com>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
 <1392737654-22682-3-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392737654-22682-3-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 04:34:13PM +0100, Johannes Thumshirn wrote:
> Add support for MCB over PCI devices. Both PCI attached on-board Chameleon FPGAs
> as well as CompactPCI based MCB carrier cards are supported with this driver.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  drivers/mcb/Kconfig   |  13 ++++++
>  drivers/mcb/Makefile  |   2 +
>  drivers/mcb/mcb-pci.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 123 insertions(+)
>  create mode 100644 drivers/mcb/mcb-pci.c
> 
> diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
> index 9e7d6f5..8b058bc 100644
> --- a/drivers/mcb/Kconfig
> +++ b/drivers/mcb/Kconfig
> @@ -14,3 +14,16 @@ menuconfig MCB
>  
>  	   If build as a module, the module is called mcb.ko
>  
> +if MCB
> +config MCB_PCI
> +	   tristate "PCI based MCB carrier"
> +	   default m if MCB

'if MCB' is redundant (MCB has to be set for this option to even be
available).

[..]
> +++ b/drivers/mcb/mcb-pci.c
> @@ -0,0 +1,108 @@

Copyright/license blurb?

> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/mcb.h>
> +
> +#include "mcb-internal.h"
> +
> +static struct mcb_bus *bus;
> +struct priv {
> +	void __iomem *base;
> +};

This seems weird.  Why is the bus not part of your private data?  Seems
like you're unnecessarily restricting yourself to supporting only one of
these devices at a time...

> +
> +static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct priv *priv;
> +	phys_addr_t mapbase;
> +	int ret = 0;

No need to initialize.

> +	int num_cells;
> +	unsigned long flags;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(struct priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to enable PCI device\n");
> +		return -ENODEV;
> +	}
> +
> +	mapbase = pci_resource_start(pdev, 0);
> +	if (!mapbase) {
> +		dev_err(&pdev->dev, "No PCI resource\n");
> +		goto err_start;
> +	}
> +
> +	ret = pci_request_region(pdev, 0, KBUILD_MODNAME);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request PCI BARs\n");
> +		goto err_start;
> +	}
> +
> +	priv->base = pci_iomap(pdev, 0, 0);

Hmm.  There should really be a devm_* variant for PCI resources.

[..]
> +
> +static void mcb_pci_remove(struct pci_dev *pdev)
> +{
> +	struct priv *priv = pci_get_drvdata(pdev);
> +
> +	mcb_release_bus(bus);
> +
> +	pci_iounmap(pdev, priv->base);
> +	pci_release_region(pdev, 0);
> +	pci_disable_device(pdev);
> +	pci_set_drvdata(pdev, NULL);
> +}
> +
> +static struct pci_device_id mcb_pci_tbl[] = {

const?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
