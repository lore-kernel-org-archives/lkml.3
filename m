Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbaIWVzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:55:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44098 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbaIWVzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:55:15 -0400
Date: Tue, 23 Sep 2014 14:55:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rajat Jain <rajatjain@juniper.net>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "rajatxjain@gmail.com" <rajatxjain@gmail.com>
Subject: Re: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Message-ID: <20140923215509.GB15481@roeck-us.net>
References: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
 <580c2c85f8424369910b69a8f871f82e@DM2PR05MB671.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580c2c85f8424369910b69a8f871f82e@DM2PR05MB671.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:20:41PM +0000, Rajat Jain wrote:
> Hello Bjorn,
> 
> I think this patch needs to be applied to all -stable branches (all the way back to 3.2).
> 
> I encounter this same issue on my platform that is running 3.14.y. 
> 
Bjorn,

can you send this to -stable, or is it ok if I do it ?

Thanks,
Guenter

> Thanks,
> 
> Rajat
> 
> > -----Original Message-----
> > From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> > owner@vger.kernel.org] On Behalf Of Andreas Noever
> > Sent: Monday, June 09, 2014 2:04 PM
> > To: linux-kernel@vger.kernel.org; Bjorn Helgaas; linux-pci@vger.kernel.org
> > Cc: Andreas Noever
> > Subject: [PATCH] PCI: Prevent NULL dereference during pciehp probe
> > 
> > pciehp assumes that dev->subordinate exists. But we do not assign a bus if
> > we run out of bus numbers during enumeration. This leads to a NULL
> > dereference in init_slot (and other places).
> > 
> > Change pciehp_probe to return -ENODEV when no subordinate bus is
> > present.
> > 
> > Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> > ---
> >  drivers/pci/hotplug/pciehp_core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/pci/hotplug/pciehp_core.c
> > b/drivers/pci/hotplug/pciehp_core.c
> > index 0e0a2ff..e5abcaf 100644
> > --- a/drivers/pci/hotplug/pciehp_core.c
> > +++ b/drivers/pci/hotplug/pciehp_core.c
> > @@ -255,6 +255,13 @@ static int pciehp_probe(struct pcie_device *dev)
> >  	else if (pciehp_acpi_slot_detection_check(dev->port))
> >  		goto err_out_none;
> > 
> > +	if (!dev->port->subordinate) {
> > +		/* Can happen if we run out of bus numbers during probe */
> > +		dev_err(&dev->device,
> > +			"Hotplug bridge without secondary bus, ignoring\n");
> > +		goto err_out_none;
> > +	}
> > +
> >  	ctrl = pcie_init(dev);
> >  	if (!ctrl) {
> >  		dev_err(&dev->device, "Controller initialization failed\n");
> > --
> > 2.0.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in the
> > body of a message to majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
