Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbaAJOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:19:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57610 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752385AbaAJOQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:16:19 -0500
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
Subject: [PATCH 6/9] platform / x86: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:27:08 +0100
Message-ID: <1493412.bZ2k5bhngZ@vostro.rjw.lan>
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

Multiple race conditions are possible between the rfkill hotplug in
the asus-wmi and eeepc-laptop drivers and the generic PCI bus rescan
and device removal that can be triggered via sysfs.

To avoid those race conditions make asus-wmi and eeepc-laptop use
global PCI rescan-remove locking around the rfkill hotplug.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/platform/x86/asus-wmi.c     |    2 ++
 drivers/platform/x86/eeepc-laptop.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-pm/drivers/platform/x86/asus-wmi.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/asus-wmi.c
+++ linux-pm/drivers/platform/x86/asus-wmi.c
@@ -605,6 +605,7 @@ static void asus_rfkill_hotplug(struct a
 	mutex_unlock(&asus->wmi_lock);
 
 	mutex_lock(&asus->hotplug_lock);
+	pci_lock_rescan_remove();
 
 	if (asus->wlan.rfkill)
 		rfkill_set_sw_state(asus->wlan.rfkill, blocked);
@@ -655,6 +656,7 @@ static void asus_rfkill_hotplug(struct a
 	}
 
 out_unlock:
+	pci_unlock_rescan_remove();
 	mutex_unlock(&asus->hotplug_lock);
 }
 
Index: linux-pm/drivers/platform/x86/eeepc-laptop.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/eeepc-laptop.c
+++ linux-pm/drivers/platform/x86/eeepc-laptop.c
@@ -591,6 +591,7 @@ static void eeepc_rfkill_hotplug(struct
 		rfkill_set_sw_state(eeepc->wlan_rfkill, blocked);
 
 	mutex_lock(&eeepc->hotplug_lock);
+	pci_lock_rescan_remove();
 
 	if (eeepc->hotplug_slot) {
 		port = acpi_get_pci_dev(handle);
@@ -648,6 +649,7 @@ out_put_dev:
 	}
 
 out_unlock:
+	pci_unlock_rescan_remove();
 	mutex_unlock(&eeepc->hotplug_lock);
 }
 

