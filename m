Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3AKWmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:42:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38483 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3AKWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 10/22] ACPI: Introduce a new acpi handle to determine HID match.
Date: Fri, 11 Jan 2013 14:40:37 -0800
Message-Id: <1357944049-29620-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

We need to find out if one handle is for root bridge, and install notify
handler for it to handle pci root bus hot add.
At that time, root bridge acpi device is not created yet.

So acpi_match_device_ids() will not work.

This patch add a function to check if new acpi handle's HID matches a list
of IDs.  The new api use acpi_device_info instead acpi_device.

-v2: updated changelog, also check length for string info...
     change checking sequence by moving string comaring close to for loop.
					- Yinghai
-v3: change to _GPL according to Rafael

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/scan.c     |   33 +++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |    2 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index db7664e..8883539 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -470,6 +470,39 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+int acpi_match_object_info_ids(struct acpi_device_info *info,
+			       const struct acpi_device_id *ids)
+{
+	const struct acpi_device_id *id;
+	char *str;
+	u32 len;
+	int i;
+
+	len = info->hardware_id.length;
+	if (len) {
+		str = info->hardware_id.string;
+		if (str)
+			for (id = ids; id->id[0]; id++)
+				if (!strcmp((char *)id->id, str))
+					return 0;
+	}
+
+	for (i = 0; i < info->compatible_id_list.count; i++) {
+		len = info->compatible_id_list.ids[i].length;
+		if (!len)
+			continue;
+		str = info->compatible_id_list.ids[i].string;
+		if (!str)
+			continue;
+		for (id = ids; id->id[0]; id++)
+			if (!strcmp((char *)id->id, str))
+				return 0;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(acpi_match_object_info_ids);
+
 static void acpi_free_ids(struct acpi_device *device)
 {
 	struct acpi_hardware_id *id, *tmp;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a9e1421..2246ba9 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -355,6 +355,8 @@ int acpi_bus_trim(struct acpi_device *start, int rmdevice);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
+int acpi_match_object_info_ids(struct acpi_device_info *info,
+			       const struct acpi_device_id *ids);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
-- 
1.7.10.4

