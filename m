Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3ENQyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:54:03 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:48594 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab3ENQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [RFC PATCH v2, part 2 18/18] PCI, asus-wmi: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:52:02 +0800
Message-Id: <1368550322-1045-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance asus-wmi drvier to use hotplug-safe iterators to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: acpi4asus-user@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/platform/x86/asus-wmi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c11b242..f92db4c 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -596,7 +596,7 @@ static bool asus_wlan_rfkill_blocked(struct asus_wmi *asus)
 static void asus_rfkill_hotplug(struct asus_wmi *asus)
 {
 	struct pci_dev *dev;
-	struct pci_bus *bus;
+	struct pci_bus *bus = NULL;
 	bool blocked;
 	bool absent;
 	u32 l;
@@ -611,7 +611,7 @@ static void asus_rfkill_hotplug(struct asus_wmi *asus)
 		rfkill_set_sw_state(asus->wlan.rfkill, blocked);
 
 	if (asus->hotplug_slot) {
-		bus = pci_find_bus(0, 1);
+		bus = pci_get_bus(0, 1);
 		if (!bus) {
 			pr_warn("Unable to find PCI bus 1?\n");
 			goto out_unlock;
@@ -657,6 +657,7 @@ static void asus_rfkill_hotplug(struct asus_wmi *asus)
 
 out_unlock:
 	mutex_unlock(&asus->hotplug_lock);
+	pci_bus_put(bus);
 }
 
 static void asus_rfkill_notify(acpi_handle handle, u32 event, void *data)
@@ -748,7 +749,7 @@ static void asus_hotplug_work(struct work_struct *work)
 static int asus_setup_pci_hotplug(struct asus_wmi *asus)
 {
 	int ret = -ENOMEM;
-	struct pci_bus *bus = pci_find_bus(0, 1);
+	struct pci_bus *bus = pci_get_bus(0, 1);
 
 	if (!bus) {
 		pr_err("Unable to find wifi PCI bus\n");
@@ -782,6 +783,7 @@ static int asus_setup_pci_hotplug(struct asus_wmi *asus)
 		pr_err("Unable to register hotplug slot - %d\n", ret);
 		goto error_register;
 	}
+	pci_bus_put(bus);
 
 	return 0;
 
@@ -793,6 +795,7 @@ error_info:
 error_slot:
 	destroy_workqueue(asus->hotplug_workqueue);
 error_workqueue:
+	pci_bus_put(bus);
 	return ret;
 }
 
-- 
1.8.1.2

