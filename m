Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3AKWnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:43:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38450 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3AKWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 11/22] PCI: correctly detect ACPI PCI host bridge objects
Date: Fri, 11 Jan 2013 14:40:38 -0800
Message-Id: <1357944049-29620-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The code in pci_root_hp.c depends on function acpi_is_root_bridge()
to check whether an ACPI object is a PCI host bridge or not.
If an ACPI device hasn't been created for the ACPI object yet,
function acpi_is_root_bridge() will return false even if the object
is a PCI host bridge object. That behavior will cause two issues:
1) No ACPI notification handler installed for PCI host bridges absent
   at startup, so hotplug events for those bridges won't be handled.
2) rescan_root_bridge() can't reenumerate offlined PCI host bridges
   because the ACPI devices have been already destroyed.

So use acpi_match_object_info_ids() to correctly detect PCI host bridges.

-v2: update to use acpi_match_object_info_ids() from Tang Chen  - Yinghai
-v3: drop the PNP0A008, according to Bjorn.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5ae36d8..d30fb94 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -923,6 +923,23 @@ static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 				_handle_hotplug_event_root);
 }
 
+static bool acpi_is_root_bridge_object(acpi_handle handle)
+{
+	struct acpi_device_info *info = NULL;
+	acpi_status status;
+	bool ret;
+
+	status = acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	ret = !acpi_match_object_info_ids(info, root_device_ids);
+
+	kfree(info);
+
+	return ret;
+}
+
 static acpi_status __init
 find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
@@ -931,7 +948,7 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 				      .pointer = objname };
 	int *count = (int *)context;
 
-	if (!acpi_is_root_bridge(handle))
+	if (!acpi_is_root_bridge_object(handle))
 		return AE_OK;
 
 	(*count)++;
-- 
1.7.10.4

