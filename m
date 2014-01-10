Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbaAJORl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:17:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55467 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752827AbaAJOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:16:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>,
        Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/9] ACPI / PCI: Use global PCI rescan-remove locking in PCI root hotplug
Date: Fri, 10 Jan 2014 15:23:14 +0100
Message-ID: <3089678.gd7W8nYHSz@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Multiple race conditions are possible between the addition and
removal of PCI devices during ACPI PCI host bridge hotplug and the
generic PCI bus rescan and device removal that can be triggered via
sysfs.

To avoid those race conditions make the ACPI PCI host bridge addition
and removal code use global PCI rescan-remove locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -604,7 +604,9 @@ static int acpi_pci_root_add(struct acpi
 		pci_assign_unassigned_root_bus_resources(root->bus);
 	}
 
+	pci_lock_rescan_remove();
 	pci_bus_add_devices(root->bus);
+	pci_unlock_rescan_remove();
 	return 1;
 
 end:
@@ -616,6 +618,8 @@ static void acpi_pci_root_remove(struct
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
+	pci_lock_rescan_remove();
+
 	pci_stop_root_bus(root->bus);
 
 	device_set_run_wake(root->bus->bridge, false);
@@ -623,6 +627,8 @@ static void acpi_pci_root_remove(struct
 
 	pci_remove_root_bus(root->bus);
 
+	pci_unlock_rescan_remove();
+
 	kfree(root);
 }
 

