Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3HWUmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:42:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57853 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab3HWUmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:42:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Horman <nhorman@tuxdriver.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Fix osc flag setup ordering to allow pcie hotplug use when available
Date: Fri, 23 Aug 2013 22:53:20 +0200
Message-ID: <3958698.Gm9Wz19SSi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130823200511.GB632@hmsreliant.think-freely.org>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com> <2074111.WRY7FfU4Ni@vostro.rjw.lan> <20130823200511.GB632@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 23, 2013 04:05:11 PM Neil Horman wrote:
> On Fri, Aug 23, 2013 at 09:38:18PM +0200, Rafael J. Wysocki wrote:
> > [CCs added]
> > 
> > Please always send PCI-related material to linux-pci in the first place.
> > 
> Sorry, I ran get_maintainers and it seemed to think linux-acpi was sufficient.
> 
> > The change that broke things for you was actually intentional:
> > 
> > commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
> > Author: Bjorn Helgaas <bhelgaas@google.com>
> > Date:   Mon Apr 1 15:47:39 2013 -0600
> > 
> >     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
> >     
> >     This reverts commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6.
> > 
> > so I think we'll need to clean up the ASMP initialization after all.
> > 
> Crud.  Reading over the revert commit, it seems like the problem boils down to
> the odering of checking aspm_disabled.  It seems to me that the simple fix is to
> track the desire for acpi to disable aspm separately from the users desire to
> disable aspm (aspm_disabled).  Then we just turn the points where we check the
> aspm_disabled into the appropriate or of two variables, except for
> pcie_asmp_sanity_check, which remains sensitive to just the user disable option.
> 
> Or is there more to this?

No, I think you're right.

Bjorn, what do you think?

Rafael


> > On Friday, August 23, 2013 01:19:39 PM Neil Horman wrote:
> > > Somewhere between 3.9 and 3.10 it seems the order in which pcie and acpi probed
> > > slots for hotplug capabilites got reversed.  While this isn't a big deal, it did
> > > uncover a bug in the ACPI bus setup path.  Specifically, acpi_pci_root_add calls
> > > pci_acpi_scan_root before setting the osc flags for the device handle.
> > > pci_acpi_scan_root, among other things uses device_is_managed_by_native_pciehp()
> > > to determine if a given slot has pcie hotplug capabilties, whcih checks the
> > > devices OSC_PCI_EXPRESS_NATIVE_HP_CONTROL flag.  Since that flag is not set
> > > until after pci_acpi_scan_root_completes, the acpi code never sees that pcie
> > > slots are hotplug capable and configures them all to use acpi instead.
> > > 
> > > Fix is pretty simple, just defer the scan until after the osc flags have been
> > > set on the device.  Tested by myself and it seems to work well.
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > CC: Len Brown <lenb@kernel.org>
> > > CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > CC: linux-acpi@vger.kernel.org
> > > ---
> > >  drivers/acpi/pci_root.c | 41 ++++++++++++++++++++---------------------
> > >  1 file changed, 20 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > > index 5917839..a2c2661 100644
> > > --- a/drivers/acpi/pci_root.c
> > > +++ b/drivers/acpi/pci_root.c
> > > @@ -437,27 +437,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >  	flags = base_flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
> > >  	acpi_pci_osc_support(root, flags);
> > >  
> > > -	/*
> > > -	 * TBD: Need PCI interface for enumeration/configuration of roots.
> > > -	 */
> > > -
> > > -	/*
> > > -	 * Scan the Root Bridge
> > > -	 * --------------------
> > > -	 * Must do this prior to any attempt to bind the root device, as the
> > > -	 * PCI namespace does not get created until this call is made (and
> > > -	 * thus the root bridge's pci_dev does not exist).
> > > -	 */
> > > -	root->bus = pci_acpi_scan_root(root);
> > > -	if (!root->bus) {
> > > -		dev_err(&device->dev,
> > > -			"Bus %04x:%02x not present in PCI namespace\n",
> > > -			root->segment, (unsigned int)root->secondary.start);
> > > -		result = -ENODEV;
> > > -		goto end;
> > > -	}
> > > -
> > > -	/* Indicate support for various _OSC capabilities. */
> > >  	if (pci_ext_cfg_avail())
> > >  		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
> > >  	if (pcie_aspm_support_enabled()) {
> > > @@ -520,6 +499,26 @@ static int acpi_pci_root_add(struct acpi_device *device,
> > >  			 "(_OSC support mask: 0x%02x)\n", flags);
> > >  	}
> > >  
> > > +	/*
> > > +	 * TBD: Need PCI interface for enumeration/configuration of roots.
> > > +	 */
> > > +
> > > +	/*
> > > +	 * Scan the Root Bridge
> > > +	 * --------------------
> > > +	 * Must do this prior to any attempt to bind the root device, as the
> > > +	 * PCI namespace does not get created until this call is made (and
> > > +	 * thus the root bridge's pci_dev does not exist).
> > > +	 */
> > > +	root->bus = pci_acpi_scan_root(root);
> > > +	if (!root->bus) {
> > > +		dev_err(&device->dev,
> > > +			"Bus %04x:%02x not present in PCI namespace\n",
> > > +			root->segment, (unsigned int)root->secondary.start);
> > > +		result = -ENODEV;
> > > +		goto end;
> > > +	}
> > > +
> > >  	pci_acpi_add_bus_pm_notifier(device, root->bus);
> > >  	if (device->wakeup.flags.run_wake)
> > >  		device_set_run_wake(root->bus->bridge, true);
> > > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
