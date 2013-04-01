Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3DAXxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:53:05 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56627 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab3DAXxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:53:01 -0400
Date: Mon, 1 Apr 2013 17:52:56 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
Message-ID: <20130401235256.GA31966@google.com>
References: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
 <CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
 <CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
 <CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
 <CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
 <20130329032200.GA11990@google.com>
 <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:04:48AM -0700, Yinghai Lu wrote:
> attatched -v3 again
> 
> On Fri, Mar 29, 2013 at 11:02 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Mar 29, 2013 at 5:24 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>
> >> Half of your v1 patch (removing the pcie_aspm_sanity_check() test)
> >> *might* be the right thing, but only if you can clearly explain why
> >> that will not reintroduce the bug Matthew fixed with c9651e70.
> >>
> >> I think we also need to fix the PCI_FIXUP_FINAL quirk regression, but
> >> that's a separate issue and should be a separate patch.
> >
> >
> > First commit from Matthew
> >  0ae5eaf10     PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
> >     Right now we won't touch ASPM state if ASPM is disabled, except in the case
> >     where we find a device that appears to be too old to reliably support ASPM.
> >     Right now we'll clear it in that case, which is almost certainly the wrong
> >     thing to do
> >
> > Try to not touch pre-1.1 ASPM for all, and it causes lots of regression.
> >
> > So second commit
> >
> > cdb0f9a1ad2e ASPM: Fix pcie devices with non-pcie children
> >     Since 3.2.12 and 3.3, some systems are failing to boot with a BUG_ON.
> >     Some other systems using the pata_jmicron driver fail to boot because no
> >     disks are detected.  Passing pcie_aspm=force on the kernel command line
> >     works around it.
> >
> > move the check aspm_disabled down.
> >
> > but ath5 and etc (pre-1.1) really need to aspm_disable to change their
> > hw setting.
> >
> > So the right solution would be dropping pcie_aspm_sanity_check()
> > change -in v2 should make all both happy, as quirk and disable that in
> > driver for ath5 are calling
> > pcie_disable_aspm_state explicitly.
> >
> > In v2, we already removed pcie_clear_aspm() that is calling
> > pcie_disable_aspm_state.
> >
> >
> > Please check attached -v3.

It's getting late in the v3.9 cycle already, and while your v3 patch
probably fixes Roman's problem, I can't convince myself that it is
safe in general.

I think the safest thing to do at this point is to revert 8c33f51df
("PCI/ACPI: Request _OSC control before scanning PCI root bus") with a
patch like the one below.

That does mean the booting path and hotplug paths will be different (we set
aspm_disabled after boot but before hotplug), but it was that way for a
long time before 8c33f51df.  I think it's more important to fix this recent
ath5k regression than to fix a long-standing hotplug bug that nobody ever
complained about.

Obviously, I think we should fix the hotplug bug and clean up the ASPM
mess, too.  But we need to do that when we have more time to do it right
and test it.

Bjorn


commit 96e5d01cd536458435ef0678d9fa3dc542afb41f
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Mon Apr 1 15:47:39 2013 -0600

    Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
    
    This reverts commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6.
    
    Conflicts:
    	drivers/acpi/pci_root.c
    
    Reference: https://bugzilla.kernel.org/show_bug.cgi?id=55211
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 0ac546d..c740364 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -415,7 +415,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	struct acpi_pci_root *root;
 	struct acpi_pci_driver *driver;
 	u32 flags, base_flags;
-	bool is_osc_granted = false;
 
 	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
 	if (!root)
@@ -476,6 +475,30 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	flags = base_flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
 	acpi_pci_osc_support(root, flags);
 
+	/*
+	 * TBD: Need PCI interface for enumeration/configuration of roots.
+	 */
+
+	mutex_lock(&acpi_pci_root_lock);
+	list_add_tail(&root->node, &acpi_pci_roots);
+	mutex_unlock(&acpi_pci_root_lock);
+
+	/*
+	 * Scan the Root Bridge
+	 * --------------------
+	 * Must do this prior to any attempt to bind the root device, as the
+	 * PCI namespace does not get created until this call is made (and
+	 * thus the root bridge's pci_dev does not exist).
+	 */
+	root->bus = pci_acpi_scan_root(root);
+	if (!root->bus) {
+		printk(KERN_ERR PREFIX
+			    "Bus %04x:%02x not present in PCI namespace\n",
+			    root->segment, (unsigned int)root->secondary.start);
+		result = -ENODEV;
+		goto out_del_root;
+	}
+
 	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail())
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
@@ -494,6 +517,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 			flags = base_flags;
 		}
 	}
+
 	if (!pcie_ports_disabled
 	    && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
 		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
@@ -514,54 +538,28 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		status = acpi_pci_osc_control_set(device->handle, &flags,
 				       OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
 		if (ACPI_SUCCESS(status)) {
-			is_osc_granted = true;
 			dev_info(&device->dev,
 				"ACPI _OSC control (0x%02x) granted\n", flags);
+			if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
+				/*
+				 * We have ASPM control, but the FADT indicates
+				 * that it's unsupported. Clear it.
+				 */
+				pcie_clear_aspm(root->bus);
+			}
 		} else {
-			is_osc_granted = false;
 			dev_info(&device->dev,
 				"ACPI _OSC request failed (%s), "
 				"returned control mask: 0x%02x\n",
 				acpi_format_exception(status), flags);
+			pr_info("ACPI _OSC control for PCIe not granted, "
+				"disabling ASPM\n");
+			pcie_no_aspm();
 		}
 	} else {
 		dev_info(&device->dev,
-			"Unable to request _OSC control "
-			"(_OSC support mask: 0x%02x)\n", flags);
-	}
-
-	/*
-	 * TBD: Need PCI interface for enumeration/configuration of roots.
-	 */
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_add_tail(&root->node, &acpi_pci_roots);
-	mutex_unlock(&acpi_pci_root_lock);
-
-	/*
-	 * Scan the Root Bridge
-	 * --------------------
-	 * Must do this prior to any attempt to bind the root device, as the
-	 * PCI namespace does not get created until this call is made (and 
-	 * thus the root bridge's pci_dev does not exist).
-	 */
-	root->bus = pci_acpi_scan_root(root);
-	if (!root->bus) {
-		printk(KERN_ERR PREFIX
-			    "Bus %04x:%02x not present in PCI namespace\n",
-			    root->segment, (unsigned int)root->secondary.start);
-		result = -ENODEV;
-		goto out_del_root;
-	}
-
-	/* ASPM setting */
-	if (is_osc_granted) {
-		if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM)
-			pcie_clear_aspm(root->bus);
-	} else {
-		pr_info("ACPI _OSC control for PCIe not granted, "
-			"disabling ASPM\n");
-		pcie_no_aspm();
+			 "Unable to request _OSC control "
+			 "(_OSC support mask: 0x%02x)\n", flags);
 	}
 
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
