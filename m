Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3AKWlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:41:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38478 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3AKWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 19/22] PCI, pci_root_hp: Use acpi_hp_work
Date: Fri, 11 Jan 2013 14:40:46 -0800
Message-Id: <1357944049-29620-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove local copy: acpi_root_hp_work

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c |   34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8a0e2e2..e3774b2 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -685,34 +685,6 @@ int __init acpi_pci_root_init(void)
 
 #define ACPI_STA_FUNCTIONING	(0x00000008)
 
-struct acpi_root_hp_work {
-	struct work_struct work;
-	acpi_handle handle;
-	u32 type;
-	void *context;
-};
-
-static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
-					void *context,
-					void (*func)(struct work_struct *work))
-{
-	struct acpi_root_hp_work *hp_work;
-	int ret;
-
-	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
-	if (!hp_work)
-		return;
-
-	hp_work->handle = handle;
-	hp_work->type = type;
-	hp_work->context = context;
-
-	INIT_WORK(&hp_work->work, func);
-	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
-	if (!ret)
-		kfree(hp_work);
-}
-
 static void handle_root_bridge_insertion(acpi_handle handle)
 {
 	struct acpi_device *device, *pdevice;
@@ -770,11 +742,11 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_root_hp_work *hp_work;
+	struct acpi_hp_work *hp_work;
 	acpi_handle handle;
 	u32 type;
 
-	hp_work = container_of(work, struct acpi_root_hp_work, work);
+	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
 
@@ -819,7 +791,7 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 					void *context)
 {
-	alloc_acpi_root_hp_work(handle, type, context,
+	alloc_acpi_hp_work(handle, type, context,
 				_handle_hotplug_event_root);
 }
 
-- 
1.7.10.4

