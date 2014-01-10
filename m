Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaAJOQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:16:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51028 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752109AbaAJOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:16:18 -0500
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
Subject: [PATCH 9/9] Xen / PCI: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:29:19 +0100
Message-ID: <2217895.SUZgMb7DfC@vostro.rjw.lan>
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

Multiple race conditions are possible between the Xen pcifront
device addition and removal and the generic PCI device addition
and removal that can be triggered via sysfs.

To avoid those race conditions make the Xen pcifront code use global
PCI rescan-remove locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/xen-pcifront.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-pm/drivers/pci/xen-pcifront.c
===================================================================
--- linux-pm.orig/drivers/pci/xen-pcifront.c
+++ linux-pm/drivers/pci/xen-pcifront.c
@@ -471,12 +471,15 @@ static int pcifront_scan_root(struct pci
 	}
 	pcifront_init_sd(sd, domain, bus, pdev);
 
+	pci_lock_rescan_remove();
+
 	b = pci_scan_bus_parented(&pdev->xdev->dev, bus,
 				  &pcifront_bus_ops, sd);
 	if (!b) {
 		dev_err(&pdev->xdev->dev,
 			"Error creating PCI Frontend Bus!\n");
 		err = -ENOMEM;
+		pci_unlock_rescan_remove();
 		goto err_out;
 	}
 
@@ -494,6 +497,7 @@ static int pcifront_scan_root(struct pci
 	/* Create SysFS and notify udev of the devices. Aka: "going live" */
 	pci_bus_add_devices(b);
 
+	pci_unlock_rescan_remove();
 	return err;
 
 err_out:
@@ -556,6 +560,7 @@ static void pcifront_free_roots(struct p
 
 	dev_dbg(&pdev->xdev->dev, "cleaning up root buses\n");
 
+	pci_lock_rescan_remove();
 	list_for_each_entry_safe(bus_entry, t, &pdev->root_buses, list) {
 		list_del(&bus_entry->list);
 
@@ -568,6 +573,7 @@ static void pcifront_free_roots(struct p
 
 		kfree(bus_entry);
 	}
+	pci_unlock_rescan_remove();
 }
 
 static pci_ers_result_t pcifront_common_process(int cmd,
@@ -1043,8 +1049,10 @@ static int pcifront_detach_devices(struc
 				domain, bus, slot, func);
 			continue;
 		}
+		pci_lock_rescan_remove();
 		pci_stop_and_remove_bus_device(pci_dev);
 		pci_dev_put(pci_dev);
+		pci_unlock_rescan_remove();
 
 		dev_dbg(&pdev->xdev->dev,
 			"PCI device %04x:%02x:%02x.%d removed.\n",

