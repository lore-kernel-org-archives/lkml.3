Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaILSDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:13 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39394 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaILSDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:10 -0400
Subject: [PATCH v1 03/13] PCI: Add pci_configure_device() during enumeration
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:07 -0600
Message-ID: <20140912180307.1630.63799.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms can tell the OS how to configure PCI devices, e.g., how to
set cache line size, error reporting enables, etc.  ACPI defines _HPP and
_HPX methods for this purpose.

This configuration was previously done by some of the hotplug drivers using
pci_configure_slot().  But not all hotplug drivers did this, and per the
spec (ACPI rev 5.0, sec 6.2.7), we can also do it for "devices not
configured by the BIOS at system boot."

Move this configuration into the PCI core by adding pci_configure_device()
and calling it from pci_device_add(), so we do this for all devices as we
enumerate them.

This is based on pci_configure_slot(), which is used by hotplug drivers.
I omitted:

  - pcie_bus_configure_settings() because it configures MPS and MRRS, which
    requires global knowledge of the fabric and must be done later, and

  - configuration of subordinate devices; that will happen when we call
    pci_device_add() for those devices.

Because pci_configure_slot() was only done by hotplug drivers, this initial
version of pci_configure_device() only configures hot-added devices,
ignoring anything added during boot.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5d0cc646817a..93d2b41163fa 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1384,6 +1384,30 @@ void pci_configure_slot(struct pci_dev *dev)
 	}
 }
 EXPORT_SYMBOL_GPL(pci_configure_slot);
+
+static void pci_configure_device(struct pci_dev *dev)
+{
+	struct hotplug_params hpp;
+	int ret;
+
+	if (system_state == SYSTEM_BOOTING)
+		return;
+
+	if (!(dev->hdr_type == PCI_HEADER_TYPE_NORMAL ||
+			(dev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
+			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
+		return;
+
+	memset(&hpp, 0, sizeof(hpp));
+	ret = pci_get_hp_params(dev, &hpp);
+	if (ret)
+		return;
+
+	program_hpp_type2(dev, hpp.t2);
+	program_hpp_type1(dev, hpp.t1);
+	program_hpp_type0(dev, hpp.t0);
+}
+
 static void pci_release_capabilities(struct pci_dev *dev)
 {
 	pci_vpd_release(dev);
@@ -1521,6 +1545,8 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
 	int ret;
 
+	pci_configure_device(dev);
+
 	device_initialize(&dev->dev);
 	dev->dev.release = pci_release_dev;
 

