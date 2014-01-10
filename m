Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaAJOSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:18:44 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53881 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752727AbaAJOQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:16:20 -0500
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
Subject: [PATCH 4/9] PCMCIA / cardbus: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:25:34 +0100
Message-ID: <2463755.ZN6tpTxA86@vostro.rjw.lan>
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

Multiple race conditions are possible between the cardbus PCI
device addition and removal and the generic PCI bus rescan and device
removal that can be triggered via sysfs.

To avoid those race conditions make the cardbus code use global
PCI rescan-remove locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pcmcia/cardbus.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-pm/drivers/pcmcia/cardbus.c
===================================================================
--- linux-pm.orig/drivers/pcmcia/cardbus.c
+++ linux-pm/drivers/pcmcia/cardbus.c
@@ -70,6 +70,8 @@ int __ref cb_alloc(struct pcmcia_socket
 	struct pci_dev *dev;
 	unsigned int max, pass;
 
+	pci_lock_rescan_remove();
+
 	s->functions = pci_scan_slot(bus, PCI_DEVFN(0, 0));
 	pci_fixup_cardbus(bus);
 
@@ -93,6 +95,7 @@ int __ref cb_alloc(struct pcmcia_socket
 
 	pci_bus_add_devices(bus);
 
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -115,6 +118,10 @@ void cb_free(struct pcmcia_socket *s)
 	if (!bus)
 		return;
 
+	pci_lock_rescan_remove();
+
 	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list)
 		pci_stop_and_remove_bus_device(dev);
+
+	pci_unlock_rescan_remove();
 }

