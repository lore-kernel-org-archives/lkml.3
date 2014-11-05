Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaKEV5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:57:22 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48609 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKEV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:57:18 -0500
Date: Wed, 5 Nov 2014 14:57:13 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, Chao Zhou <chao.zhou@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] PCI: fix sriov enabling with virtual bus
Message-ID: <20141105215713.GC6168@google.com>
References: <1414621570-20777-1-git-send-email-yinghai@kernel.org>
 <20141030170913.GA6982@google.com>
 <20141105202252.GB6168@google.com>
 <1808324.GlBOqbYcPz@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1808324.GlBOqbYcPz@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:44:25PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 05, 2014 01:22:52 PM Bjorn Helgaas wrote:
> > ...
> > The acpi_pci_get_bridge_handle(struct pci_bus *) interface niggles at me a
> > little because I don't think there's any concept of an ACPI device for a
> > PCI *bus*, so it doesn't seem like a very good fit to say "find the handle
> > for this bus".  But that's for later.
> 
> To me it does what it says: Get me the handle of the bridge leading to
> this bus.

Yeah, I know, it's a great name because it does *exactly* what the name
says.  I'm just wondering if there's a nicer way to express what the caller
needs.

Two of the three callers start with a pci_dev, look up a pci_bus to pass
in, and get back a handle corresponding to a pci_host_bridge or a pci_dev
(or a NULL).  It seems a little cluttered because the pci_bus is only
incidental and the caller doesn't care about it at all except for passing
it to acpi_pci_get_bridge_handle().

It's relatively common to start with a pci_dev and look for an ACPI handle
that corresponds to that device or the closest enclosing scope, so maybe
there should be a way to do that directly.

For pci_get_hp_params(), I think the current code is actually slightly
buggy because we don't look for _HPP/_HPX on the device itself; we only
look at the bridges upstream from it.

What I had in mind was something like the following (untested and not for
application).

Bjorn


diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 876ccc620440..5e95df56b8ae 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -116,20 +116,11 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
 	}
 
-	handle = ACPI_HANDLE(&pdev->dev);
-	if (!handle) {
-		/*
-		 * This hotplug controller was not listed in the ACPI name
-		 * space at all. Try to get acpi handle of parent pci bus.
-		 */
-		struct pci_bus *pbus;
-		for (pbus = pdev->bus; pbus; pbus = pbus->parent) {
-			handle = acpi_pci_get_bridge_handle(pbus);
-			if (handle)
-				break;
-		}
-	}
-
+	/*
+	 * We did not find _OSC on the host bridge, so look for any
+	 * enclosing device with an OSHP method.
+	 */
+	handle = pci_find_acpi_handle(pdev);
 	while (handle) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
 		dbg("Trying to get hotplug control for %s \n",
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 6ebf8edc5f3c..3b3f0720fff0 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -246,14 +246,8 @@ int pci_get_hp_params(struct pci_dev *dev, struct hotplug_params *hpp)
 {
 	acpi_status status;
 	acpi_handle handle, phandle;
-	struct pci_bus *pbus;
 
-	handle = NULL;
-	for (pbus = dev->bus; pbus; pbus = pbus->parent) {
-		handle = acpi_pci_get_bridge_handle(pbus);
-		if (handle)
-			break;
-	}
+	handle = pci_find_acpi_handle(dev);
 
 	/*
 	 * _HPP settings apply to all child buses, until another _HPP is
@@ -279,6 +273,33 @@ int pci_get_hp_params(struct pci_dev *dev, struct hotplug_params *hpp)
 }
 EXPORT_SYMBOL_GPL(pci_get_hp_params);
 
+/*
+ * Search for an ACPI handle.  The PCI device itself may have one, or an
+ * upstream device (either a PCI-to-PCI bridge or a PCI host bridge) may
+ * have one.
+ */
+acpi_handle pci_find_acpi_handle(struct pci_dev *pdev)
+{
+	struct device *dev;
+	acpi_handle handle;
+	struct pci_bus *bus;
+
+	dev = &pdev->dev;
+	handle = ACPI_HANDLE(dev);
+	while (!handle) {
+		pdev = pci_physfn(pdev);
+		bus = pdev->bus;
+		if (pci_is_root_bus(bus))
+			dev = bus->bridge;
+		else {
+			pdev = bus->self;
+			dev = &pdev->dev;
+		}
+		handle = ACPI_HANDLE(dev);
+	}
+	return handle;
+}
+
 /**
  * pci_acpi_wake_bus - Root bus wakeup notification fork function.
  * @work: Work item to handle.
