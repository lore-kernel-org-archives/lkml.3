Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3AUVXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:23:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38498 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3AUVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 08/11] PCI, ACPI: debug print for installation of acpi root bridge's notifier
Date: Mon, 21 Jan 2013 13:20:49 -0800
Message-Id: <1358803252-20639-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

acpi_install_notify_handler() could fail. So check the exit status
and give a better debug info.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index a2d2c4c..417487a 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -751,6 +751,7 @@ static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 static acpi_status __init
 find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
+	acpi_status status;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
@@ -763,9 +764,14 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
-	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				handle_hotplug_event_root, NULL);
-	printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
+	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					handle_hotplug_event_root, NULL);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG "acpi root: %s notify handler is not installed, exit status: %u\n",
+				  objname, (unsigned int)status);
+	else
+		printk(KERN_DEBUG "acpi root: %s notify handler is installed\n",
+				 objname);
 
 	return AE_OK;
 }
-- 
1.7.10.4

