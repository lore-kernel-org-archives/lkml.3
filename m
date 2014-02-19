Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaBSJqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:46:33 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.165]:11617 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbaBSJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:46:30 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-39.messagelabs.com!1392803187!12217719!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 19 Feb 2014 10:46:27 +0100
Date: Wed, 19 Feb 2014 10:46:25 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mcb: Add PCI carrier for MEN Chameleon Bus
Message-ID: <20140219094625.GB16649@jtlinux>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
 <1392737654-22682-3-git-send-email-johannes.thumshirn@men.de>
 <20140218232017.GA31820@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140218232017.GA31820@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:20:17PM -0600, Josh Cartwright wrote:
> On Tue, Feb 18, 2014 at 04:34:13PM +0100, Johannes Thumshirn wrote:
> > Add support for MCB over PCI devices. Both PCI attached on-board Chameleon FPGAs
> > as well as CompactPCI based MCB carrier cards are supported with this driver.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > ---
> >  drivers/mcb/Kconfig   |  13 ++++++
> >  drivers/mcb/Makefile  |   2 +
> >  drivers/mcb/mcb-pci.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 123 insertions(+)
> >  create mode 100644 drivers/mcb/mcb-pci.c
> >
> > diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
> > index 9e7d6f5..8b058bc 100644
> > --- a/drivers/mcb/Kconfig
> > +++ b/drivers/mcb/Kconfig
> > @@ -14,3 +14,16 @@ menuconfig MCB
> >
> >  	   If build as a module, the module is called mcb.ko
> >
> > +if MCB
> > +config MCB_PCI
> > +	   tristate "PCI based MCB carrier"
> > +	   default m if MCB
>
> 'if MCB' is redundant (MCB has to be set for this option to even be
> available).

OK

>
> [..]
> > +++ b/drivers/mcb/mcb-pci.c
> > @@ -0,0 +1,108 @@
>
> Copyright/license blurb?

Args, forgotten, sorry.

>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/mcb.h>
> > +
> > +#include "mcb-internal.h"
> > +
> > +static struct mcb_bus *bus;
> > +struct priv {
> > +	void __iomem *base;
> > +};
>
> This seems weird.  Why is the bus not part of your private data?  Seems
> like you're unnecessarily restricting yourself to supporting only one of
> these devices at a time...

You're right. Funny enough I didn't notice it, while testing as I used 2 identical
carrier cards. Card 2 must then have overwritten Card 1 :-(.

>
> > +
> > +static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > +{
> > +	struct priv *priv;
> > +	phys_addr_t mapbase;
> > +	int ret = 0;
>
> No need to initialize.

OK

>
> > +	int num_cells;
> > +	unsigned long flags;
> > +
> > +	priv = devm_kzalloc(&pdev->dev, sizeof(struct priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	ret = pci_enable_device(pdev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to enable PCI device\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	mapbase = pci_resource_start(pdev, 0);
> > +	if (!mapbase) {
> > +		dev_err(&pdev->dev, "No PCI resource\n");
> > +		goto err_start;
> > +	}
> > +
> > +	ret = pci_request_region(pdev, 0, KBUILD_MODNAME);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to request PCI BARs\n");
> > +		goto err_start;
> > +	}
> > +
> > +	priv->base = pci_iomap(pdev, 0, 0);
>
> Hmm.  There should really be a devm_* variant for PCI resources.

I don't think so, as I have to free the resources afterwards again so the mcb
devices can access these resources. Otherwise I would need to make them muxed,
but I don't see the reason to keep the resources after the parser code has
finished.

>
> [..]
> > +
> > +static void mcb_pci_remove(struct pci_dev *pdev)
> > +{
> > +	struct priv *priv = pci_get_drvdata(pdev);
> > +
> > +	mcb_release_bus(bus);
> > +
> > +	pci_iounmap(pdev, priv->base);
> > +	pci_release_region(pdev, 0);
> > +	pci_disable_device(pdev);
> > +	pci_set_drvdata(pdev, NULL);
> > +}
> > +

It's actually a "double free" of the resources, isn't it. Needs to be fixed.

> > +static struct pci_device_id mcb_pci_tbl[] = {
>
> const?
>

Yup.

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

As with the other patch, probably on monday. Sorry for the inconvenience.

Johannes
