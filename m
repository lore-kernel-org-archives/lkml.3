Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaJASvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaJASvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:51:06 -0400
Message-ID: <1412189463.7360.241.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: add kernel parameter to override devid<->driver
 mapping.
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcel Apfelbaum <marcel.a@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-pci@vger.kernel.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org, marcel@redhat.com
Date: Wed, 01 Oct 2014 12:51:03 -0600
In-Reply-To: <1412149836.2772.15.camel@localhost.localdomain>
References: <1412095115-28982-1-git-send-email-marcel.a@redhat.com>
	 <20141001065227.GB31859@redhat.com>
	 <1412147206.2772.8.camel@localhost.localdomain>
	 <20141001073008.GC31859@redhat.com>
	 <1412149836.2772.15.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 10:50 +0300, Marcel Apfelbaum wrote:
> On Wed, 2014-10-01 at 10:30 +0300, Michael S. Tsirkin wrote:
> > On Wed, Oct 01, 2014 at 10:06:46AM +0300, Marcel Apfelbaum wrote:
> > > On Wed, 2014-10-01 at 09:52 +0300, Michael S. Tsirkin wrote:
> > > > On Tue, Sep 30, 2014 at 07:38:35PM +0300, Marcel Apfelbaum wrote:
> > > > > Scanning a lot of devices during boot requires a lot of time.
> > > > > On other scenarios there is a need to bind a driver to a specific slot.
> > > > > 
> > > > > Binding devices to pci-stub driver does not work,
> > > > > as it will not differentiate between devices of the
> > > > > same type. Using some start scripts is error prone.
> > > > > 
> > > > > The solution leverages driver_override functionality introduced by
> > > > > 
> > > > > 	commit: 782a985d7af26db39e86070d28f987cad21313c0
> > > > > 	Author: Alex Williamson <alex.williamson@redhat.com>
> > > > > 	Date:   Tue May 20 08:53:21 2014 -0600
> > > > > 
> > > > >     	PCI: Introduce new device binding path using pci_dev.driver_override
> > > > > 
> > > > > In order to bind PCI slot 0001:02:03.4 to pci-stub use:
> > > > > 	driver[0001:02:03.4]=pci-stub
> > > > > 
> > > > > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > > > > ---
> > > > > Notes:
> > > > >  - For the moment only 32 slots can be assigned specific driver.
> > > > >  - I have further ideas on top of this patch based on your reviews.
> > > > >    I thought of:
> > > > >    - Use wildcards to specify entire buses/devices, something like:
> > > > >      	driver[0001:02:*.*]=pci-stub
> > > > >    - Use comma to separate several devices:
> > > > >      	driver[0001:02:03.4,0001:02:04.0,...]=pci-stub
> > > > >    - Make domain optional:
> > > > >    	driver[00:03.0]=pci-stub
> > > > > 
> > > > > Comments will be appreciated,
> > > > > Thanks,
> > > > > Marcel
> > > > > 
> > > > > Documentation/kernel-parameters.txt |  4 +++
> > > > >  drivers/pci/bus.c                   |  1 +
> > > > >  drivers/pci/pci.c                   | 61 +++++++++++++++++++++++++++++++++++++
> > > > >  drivers/pci/pci.h                   |  1 +
> > > > >  4 files changed, 67 insertions(+)
> > > > > 
> > > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > > index 5ae8608..c1cbb4c 100644
> > > > > --- a/Documentation/kernel-parameters.txt
> > > > > +++ b/Documentation/kernel-parameters.txt
> > > > > @@ -2631,6 +2631,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> > > > >  		pcie_scan_all	Scan all possible PCIe devices.  Otherwise we
> > > > >  				only look for one device below a PCIe downstream
> > > > >  				port.
> > > > > +		driver		Provide an override to the devid<->driver mapping
> > > > > +				for a specific slot.
> > > > > +				Bind PCI slot 0001:02:03.4 to pci-stub by:
> > > > > +					driver[0001:02:03.4]=pci-stub
> > > > >  
> > > > >  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
> > > > >  			Management.
> > > > > diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> > > > > index 73aef51..7a7ed85 100644
> > > > > --- a/drivers/pci/bus.c
> > > > > +++ b/drivers/pci/bus.c
> > > > > @@ -245,6 +245,7 @@ void pci_bus_add_device(struct pci_dev *dev)
> > > > >  	 * are not assigned yet for some devices.
> > > > >  	 */
> > > > >  	pci_fixup_device(pci_fixup_final, dev);
> > > > > +	pci_device_setup_driver_override(dev);
> > > > >  	pci_create_sysfs_dev_files(dev);
> > > > >  	pci_proc_attach_device(dev);
> > > > >  
> > > > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > > > index b7678be..0a3e07c 100644
> > > > > --- a/drivers/pci/pci.c
> > > > > +++ b/drivers/pci/pci.c
> > > > > @@ -4426,6 +4426,65 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
> > > > >  }
> > > > >  EXPORT_SYMBOL(pci_fixup_cardbus);
> > > > >  
> > > > > +#define DRIVER_OVERRIDE_NAME_LENGTH 64
> > > > > +#define DRIVER_OVERRIDE_MAP_SIZE 32
> > > > > +
> > > > > +struct driver_override_entry {
> > > > > +	unsigned int domain;
> > > > > +	unsigned char bus;
> > > > > +	unsigned int devfn;
> > > > > +	char driver_name[DRIVER_OVERRIDE_NAME_LENGTH];
> > > > > +};
> > > > > +
> > > > > +static struct driver_override_entry __initdata
> > > > > +	driver_override_map[DRIVER_OVERRIDE_MAP_SIZE];
> > > > > +static int driver_override_num_entries __initdata;
> > > > > +
> > > > > +void pci_device_setup_driver_override(struct pci_dev *dev)
> > > > > +{
> > > > > +	int i;
> > > > > +
> > > > > +	for (i = 0; i < driver_override_num_entries; i++) {
> > > > > +		if (pci_domain_nr(dev->bus) != driver_override_map[i].domain ||
> > > > > +		    dev->bus->number != driver_override_map[i].bus ||
> > > > > +		    dev->devfn != driver_override_map[i].devfn)
> > > > > +			continue;
> > > > > +
> > > > > +		dev->driver_override = kstrndup(driver_override_map[i].driver_name,
> > > > > +						DRIVER_OVERRIDE_NAME_LENGTH,
> > > > > +						GFP_KERNEL);
> > > > 
> > > > 
> > > Hi,
> > > 
> > > > You allocate this entry but never free it?
> > > Is being freed in pci_release_dev function.
> > > 
> > > > Shouldn't allocation failure be handled in some way?
> > > I thought about it, but in my opinion there is no need for error
> > > handling in this situation.
> > > - On the worst case scenario it will load the regular driver, no harm done.
> > >   (kstrndup will return NULL)
> > > - It is used in pci_bus_add_device workflow that has no error flow
> > >   that I am aware of, and even if it were an error flow, in my opinion
> > >   this is not enough to stop system boot.
> > > But thinking of this again, maybe a pr_err message?
> > > 
> > > Your review is most appreciated.
> > > Thanks,
> > > Marcel
> > > 
> > > 
> > 
> > Thinking more about it, how about just using strstr to search a string
> > of overrides?  This will completely remove the artificial
> > DRIVER_OVERRIDE_MAP_SIZE as well.
> I'll try it, thanks, hope it will not be too ugly.
> 
> I will still need to reserve a COMMAND_LINE_SIZE string for "string of overrides", right?
> Or can I dynamically allocate a buffer to hold the string so early in boot process?
> If I can, it will be no problem to create a dynamic sized driver_override_map.

I think Michael is suggesting searching the existing commandline on each
pass so that you don't need to allocate any memory at all.  Thanks,

Alex

> > > > 
> > > > > +		break;
> > > > > +	}
> > > > > +}
> > > > > +
> > > > > +static void __init pci_parse_driver_override(char *str)
> > > > > +{
> > > > > +	unsigned int domain, bus, dev, fn;
> > > > > +	char driver_name[DRIVER_OVERRIDE_NAME_LENGTH];
> > > > > +	int ret, next_entry;
> > > > > +	char format[] = "[%4x:%2x:%2x.%2x]=%%%ds";
> > > > > +
> > > > > +	sprintf(format + 18, "%%%ds", DRIVER_OVERRIDE_NAME_LENGTH);
> > > > > +	ret = sscanf(str, format, &domain, &bus, &dev, &fn, driver_name);
> > > > > +
> > > > > +	if (ret != 5) {
> > > > > +		pr_err("PCI: Invalid command line: driver%s\n", str);
> > > > > +		return;
> > > > > +	}
> > > > > +
> > > > > +	if (driver_override_num_entries == DRIVER_OVERRIDE_MAP_SIZE) {
> > > > > +		pr_err("PCI: Driver map overflow - ignoring driver%s\n", str);
> > > > > +		return;
> > > > > +	}
> > > > > +
> > > > > +	next_entry = driver_override_num_entries++;
> > > > > +	driver_override_map[next_entry].domain = domain;
> > > > > +	driver_override_map[next_entry].bus = bus && 0xff;
> > > > > +	driver_override_map[next_entry].devfn = ((dev & 0x1f) << 3) | (fn & 0x7);
> > > > > +	memcpy(driver_override_map[next_entry].driver_name,
> > > > > +	       driver_name, sizeof(driver_name));
> > > > > +}
> > > > > +
> > > > >  static int __init pci_setup(char *str)
> > > > >  {
> > > > >  	while (str) {
> > > > > @@ -4468,6 +4527,8 @@ static int __init pci_setup(char *str)
> > > > >  				pcie_bus_config = PCIE_BUS_PEER2PEER;
> > > > >  			} else if (!strncmp(str, "pcie_scan_all", 13)) {
> > > > >  				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
> > > > > +			} else if (!strncmp(str, "driver", 6)) {
> > > > > +				pci_parse_driver_override(str + 6);
> > > > >  			} else {
> > > > >  				printk(KERN_ERR "PCI: Unknown option `%s'\n",
> > > > >  						str);
> > > > > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> > > > > index 0601890..023d78b 100644
> > > > > --- a/drivers/pci/pci.h
> > > > > +++ b/drivers/pci/pci.h
> > > > > @@ -197,6 +197,7 @@ enum pci_bar_type {
> > > > >  bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
> > > > >  				int crs_timeout);
> > > > >  int pci_setup_device(struct pci_dev *dev);
> > > > > +void pci_device_setup_driver_override(struct pci_dev *dev);
> > > > >  int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
> > > > >  		    struct resource *res, unsigned int reg);
> > > > >  int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
> > > > > -- 
> > > > > 1.8.3.1
> > > 
> > > 
> 
> 
> 



