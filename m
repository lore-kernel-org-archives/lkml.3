Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaJGPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:14:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaJGPOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:14:44 -0400
Message-ID: <1412694831.16569.3.camel@localhost.localdomain>
Subject: Re: [PATCH v3] PCI: add kernel parameter to override devid<->driver
 mapping.
From: Marcel Apfelbaum <marcel.a@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, marcel@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 07 Oct 2014 18:13:51 +0300
In-Reply-To: <20141007150209.GB7876@redhat.com>
References: <1412693312-2449-1-git-send-email-marcel.a@redhat.com>
	 <20141007150209.GB7876@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 18:02 +0300, Michael S. Tsirkin wrote:
> On Tue, Oct 07, 2014 at 05:48:32PM +0300, Marcel Apfelbaum wrote:
> > Scanning a lot of devices during boot requires a lot of time.
> > On other scenarios there is a need to bind a driver to a specific slot.
> > 
> > Binding devices to pci-stub driver does not work,
> > as it will not differentiate between devices of the
> > same type. Using some start scripts is error prone.
> > 
> > The solution leverages driver_override functionality introduced by
> > 
> > 	commit: 782a985d7af26db39e86070d28f987cad21313c0
> > 	Author: Alex Williamson <alex.williamson@redhat.com>
> > 	Date:   Tue May 20 08:53:21 2014 -0600
> > 
> >     	PCI: Introduce new device binding path using pci_dev.driver_override
> > 
> > In order to bind PCI slots to specific drivers use:
> > 	pci=driver[xxxx:xx:xx.x]=foo,driver[xxxx:xx:xx.x]=bar,...
> > 
> > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > ---
> > v2 -> v3:
> >  - Corrected subject line
> > v1 -> v2:
> >  - Addressed Michael S. Tsirkin comments
> >    - Removed 32 slots limitation
> >    - Better handling of memory allocation failures
> >      (preferred BUG_ON over error messages)
> >  - Addressed Alex Williamson's comments:
> >    - Modified commit message to show parameter usage more clear.
> >  - I preferred to re-use parse_args instead of manually using
> >    strstr in order to better comply with command line parsing
> >    rules.
> >  - I didn't use any locking when parsing the command line args
> >    (see parse_done usage) assuming that first call will be
> >    early in system boot and no race can occur. Please correct
> >    me if I am wrong.
> > 
> > Notes:
> >  - I have further ideas on top of this patch based on your reviews.
> >    I thought of:
> >    - Use wildcards to specify entire buses/devices, something like:
> >      	driver[0001:02:*.*]=pci-stub
> >    - Use comma to separate several devices:
> >      	driver[0001:02:03.4,0001:02:04.0,...]=pci-stub
> >    - Make domain optional:
> >    	driver[00:03.0]=pci-stub
> > 
> > Comments will be appreciated,
> > Thanks,
> > Marcel
> >  Documentation/kernel-parameters.txt |  4 ++
> >  drivers/pci/bus.c                   | 86 +++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.c                   |  2 +
> >  3 files changed, 92 insertions(+)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 5ae8608..c1cbb4c 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2631,6 +2631,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  		pcie_scan_all	Scan all possible PCIe devices.  Otherwise we
> >  				only look for one device below a PCIe downstream
> >  				port.
> > +		driver		Provide an override to the devid<->driver mapping
> > +				for a specific slot.
> > +				Bind PCI slot 0001:02:03.4 to pci-stub by:
> > +					driver[0001:02:03.4]=pci-stub
> >  
> >  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
> >  			Management.
> > diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> > index 73aef51..d2c0721 100644
> > --- a/drivers/pci/bus.c
> > +++ b/drivers/pci/bus.c
> > @@ -230,6 +230,91 @@ EXPORT_SYMBOL(pci_bus_alloc_resource);
> >  
> >  void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
> >  
> > +#define DRIVER_OVERRIDE_NAME_LENGTH 64
> 
> Do we know all drivers have shorter names?
Hi Michael,

I saw this assumption in at least one place (sadly I don't remember where)
and I chose to follow it. It seems a reasonable one in my opinion.

Thanks,
Marcel
> 
> > +
> > +struct driver_override_entry {
> > +	unsigned int domain;
> > +	unsigned char bus;
> > +	unsigned int devfn;
> > +	char driver_name[DRIVER_OVERRIDE_NAME_LENGTH];
> > +	struct list_head list;
> > +};
> > +
> > +static LIST_HEAD(driver_override_entries);
> > +
> > +static int pci_device_parse_driver_override(char *param, char *val,
> > +					    const char *unused)
> > +{
> > +	unsigned int domain, bus, dev, fn;
> > +	char driver_name[DRIVER_OVERRIDE_NAME_LENGTH];
> > +	char format[] = "[%4x:%2x:%2x.%2x]=%%%ds";
> > +	struct driver_override_entry *entry;
> > +	int ret;
> > +
> > +	while (val) {
> > +		char *k = strchr(val, ',');
> > +
> > +		if (k)
> > +			*k++ = 0;
> > +
> > +		if (strncmp(val, "driver", 6)) {
> > +			val = k;
> > +			continue;
> > +		}
> > +
> > +		sprintf(format + 18, "%%%ds", DRIVER_OVERRIDE_NAME_LENGTH);
> > +		ret = sscanf(val + 6, format, &domain, &bus, &dev, &fn,
> > +			     driver_name);
> > +		if (ret != 5) {
> > +			pr_err("PCI: Invalid command line: %s\n", val);
> > +			val = k;
> > +			continue;
> > +		}
> > +
> > +		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> > +		BUG_ON(!entry);
> > +
> > +		INIT_LIST_HEAD(&entry->list);
> > +		entry->domain = domain;
> > +		entry->bus = bus && 0xff;
> > +		entry->devfn = ((dev & 0x1f) << 3) | (fn & 0x7);
> > +		memcpy(entry->driver_name, driver_name, sizeof(driver_name));
> > +
> > +		list_add_tail(&entry->list, &driver_override_entries);
> > +		val = k;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void pci_device_setup_driver_override(struct pci_dev *dev)
> > +{
> > +	static int parse_done;
> > +	struct driver_override_entry *entry;
> > +
> > +	if (!parse_done) {
> > +		char *cmdline = kstrdup(saved_command_line, GFP_KERNEL);
> > +
> > +		BUG_ON(!cmdline);
> > +
> > +		parse_args("pci", cmdline, NULL,
> > +			   0, 0, 0, &pci_device_parse_driver_override);
> > +		kfree(cmdline);
> > +		parse_done = 1;
> > +	}
> > +
> > +	list_for_each_entry(entry, &driver_override_entries, list) {
> > +		if (pci_domain_nr(dev->bus) != entry->domain ||
> > +		    dev->bus->number != entry->bus ||
> > +		    dev->devfn != entry->devfn)
> > +			continue;
> > +
> > +		dev->driver_override = kstrdup(entry->driver_name, GFP_KERNEL);
> > +		BUG_ON(!dev->driver_override);
> > +		break;
> > +	}
> > +}
> > +
> >  /**
> >   * pci_bus_add_device - start driver for a single device
> >   * @dev: device to add
> > @@ -245,6 +330,7 @@ void pci_bus_add_device(struct pci_dev *dev)
> >  	 * are not assigned yet for some devices.
> >  	 */
> >  	pci_fixup_device(pci_fixup_final, dev);
> > +	pci_device_setup_driver_override(dev);
> >  	pci_create_sysfs_dev_files(dev);
> >  	pci_proc_attach_device(dev);
> >  
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index b7678be..6bd7844 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -4468,6 +4468,8 @@ static int __init pci_setup(char *str)
> >  				pcie_bus_config = PCIE_BUS_PEER2PEER;
> >  			} else if (!strncmp(str, "pcie_scan_all", 13)) {
> >  				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
> > +			} else if (!strncmp(str, "driver", 6)) {
> > +				/* lazy evaluation by the pci subsystem */
> >  			} else {
> >  				printk(KERN_ERR "PCI: Unknown option `%s'\n",
> >  						str);
> > -- 
> > 1.8.3.1



