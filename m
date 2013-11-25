Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3KYABw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:01:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61809 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752092Ab3KYABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:01:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 2/4] PCI / ACPI: Use acpi_find_child_device() for child devices lookup
Date: Mon, 25 Nov 2013 01:12:10 +0100
Message-ID: <1827111.PaqOm34rfO@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2610478.KxPMyuOMok@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It is much more efficient to use acpi_find_child_device()
for child devices lookup in acpi_pci_find_device() and pass
ACPI_COMPANION(dev->parent) to it directly instead of obtaining
ACPI_HANDLE() of ACPI_COMPANION(dev->parent) and passing it to
acpi_find_child() which has to run acpi_bus_get_device() to
obtain ACPI_COMPANION(dev->parent) from that again.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-acpi.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -309,7 +309,8 @@ void acpi_pci_remove_bus(struct pci_bus
 static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	bool is_bridge;
+	struct acpi_device *adev;
+	bool check_children;
 	u64 addr;
 
 	/*
@@ -317,14 +318,17 @@ static int acpi_pci_find_device(struct d
 	 * is set only after acpi_pci_find_device() has been called for the
 	 * given device.
 	 */
-	is_bridge = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
+	check_children = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
 			|| pci_dev->hdr_type == PCI_HEADER_TYPE_CARDBUS;
 	/* Please ref to ACPI spec for the syntax of _ADR */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
-	*handle = acpi_find_child(ACPI_HANDLE(dev->parent), addr, is_bridge);
-	if (!*handle)
-		return -ENODEV;
-	return 0;
+	adev = acpi_find_child_device(ACPI_COMPANION(dev->parent), addr,
+				      check_children);
+	if (adev) {
+		*handle = adev->handle;
+		return 0;
+	}
+	return -ENODEV;
 }
 
 static void pci_acpi_setup(struct device *dev)

