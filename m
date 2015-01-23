Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbbAWWD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:03:27 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37656 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbAWWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:03:25 -0500
Date: Fri, 23 Jan 2015 14:03:20 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH] PCI: keystone: fix incorrect annotations on probe and
 remove
Message-ID: <20150123220320.GB4688@dtor-ws>
References: <20150108221736.GA39839@dtor-ws>
 <20150123213412.GK29776@google.com>
 <20150123214726.GA4688@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123214726.GA4688@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 01:47:26PM -0800, Dmitry Torokhov wrote:
> Hi Bjorn,
> 
> On Fri, Jan 23, 2015 at 03:34:12PM -0600, Bjorn Helgaas wrote:
> > [+cc Fabio]
> > 
> > On Thu, Jan 08, 2015 at 02:17:36PM -0800, Dmitry Torokhov wrote:
> > > Even though platform bus is not hot-pluggable, devices on it can be unbound
> > > from the driver and bound back to it via sysfs, so we should not be using
> > > __init annotations on probe() and __exit annotations on remove() methods.
> > 
> > I don't completely understand this problem.  Does this mean there should be
> > no __init/__exit annotations in these drivers at all?  If other PCI host
> > bridge drivers have the same problem, I'd like to fix them all at once.

By the way I think only keystone in drivers/pci has this issue. My
script to find potential issues is:

#!/bin/bash
for i in `grep -rl '__exit\(_p\| \).*remove' $*`; do grep -L platform_driver_probe $i; done

it is not 100% correct and generates both false positives and false
negatives but still fains a few offenders in the tree.

> 
> Basically they should not use __init/__exit, unless you take explicit
> steps to make sure that devices can't be unbound and bound again later
> via sysfs by setting driver->suppress_bind_attrs and/or using
> platform_driver_probe(). Note that if you use platform_driver_probe()
> then your driver can't cope with -EPROBE_DEFER reported by any of the
> subsystems it might be using.
> 
> > 
> > For example, after applying this patch, ks_pcie_probe() is non-__init, but
> > it calls ks_add_pcie_port(), which is still __init.  I thought that was
> > illegal.
> 
> My bad, I missed that. The __init marking on ks_add_pcie_port() shoudl
> be removed as well.
> 
> > 
> > I'm not sure about module_platform_driver_probe() either; it generates
> > __init and __exit functions.  Should those annotations be removed, too?
> 
> module_platform_driver_probe() does internally platform_driver_probe()
> so it is OK for that probe function be __init (because we'd suppress
> sysfs bind/unbind and deferred probing so discaring init section is
> safe).
> 
> Note that above applied to driver's ->probe() and ->remove() code paths
> only.  Marking module init/exit code as __init and __exit is still right
> thing to do.
> 
> Thanks.
> 
> > 
> > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > ---
> > > 
> > > Not tested, found by casual code inspection.
> > > 
> > >  drivers/pci/host/pci-keystone.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
> > > index 1b893bc..7b84e1d 100644
> > > --- a/drivers/pci/host/pci-keystone.c
> > > +++ b/drivers/pci/host/pci-keystone.c
> > > @@ -332,7 +332,7 @@ static const struct of_device_id ks_pcie_of_match[] = {
> > >  };
> > >  MODULE_DEVICE_TABLE(of, ks_pcie_of_match);
> > >  
> > > -static int __exit ks_pcie_remove(struct platform_device *pdev)
> > > +static int ks_pcie_remove(struct platform_device *pdev)
> > >  {
> > >  	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
> > >  
> > > @@ -341,7 +341,7 @@ static int __exit ks_pcie_remove(struct platform_device *pdev)
> > >  	return 0;
> > >  }
> > >  
> > > -static int __init ks_pcie_probe(struct platform_device *pdev)
> > > +static int ks_pcie_probe(struct platform_device *pdev)
> > >  {
> > >  	struct device *dev = &pdev->dev;
> > >  	struct keystone_pcie *ks_pcie;
> > > @@ -398,9 +398,9 @@ fail_clk:
> > >  	return ret;
> > >  }
> > >  
> > > -static struct platform_driver ks_pcie_driver __refdata = {
> > > +static struct platform_driver ks_pcie_driver = {
> > >  	.probe  = ks_pcie_probe,
> > > -	.remove = __exit_p(ks_pcie_remove),
> > > +	.remove = ks_pcie_remove,
> > >  	.driver = {
> > >  		.name	= "keystone-pcie",
> > >  		.owner	= THIS_MODULE,
> > > -- 
> > > 2.2.0.rc0.207.ga3a616c
> > > 
> > > 
> > > -- 
> > > Dmitry
> 
> -- 
> Dmitry

-- 
Dmitry
