Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaDVGfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:35:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:27133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaDVGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="517067412"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Resend Patch 3/9] ACPI: Add acpi_bus_attach_private_data() to facilitate to attach data to ACPI handle
Date: Tue, 22 Apr 2014 14:24:09 +0800
Message-Id: <1398147855-9868-4-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already acpi_bus_get_private_data() to get ACPI handle data
which is associated with acpi_bus_private_data_handler(). This patch
is to add acpi_bus_attach_private_data() to make a pair and facilitate
to attach and get data to/from ACPI handle.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/bus.c      | 18 +++++++++++++++++-
 include/acpi/acpi_bus.h |  1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index e7e5844..4ed8d48 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -132,6 +132,22 @@ void acpi_bus_private_data_handler(acpi_handle handle,
 }
 EXPORT_SYMBOL(acpi_bus_private_data_handler);
 
+int acpi_bus_attach_private_data(acpi_handle handle, void *data)
+{
+	acpi_status status;
+
+	status = acpi_attach_data(handle,
+			acpi_bus_private_data_handler, data);
+	if (ACPI_FAILURE(status)) {
+		ACPI_ERROR((AE_INFO, "Error attaching device[%p] data\n",
+				handle));
+		return -ENODEV;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(acpi_bus_attach_private_data);
+
 int acpi_bus_get_private_data(acpi_handle handle, void **data)
 {
 	acpi_status status;
@@ -141,7 +157,7 @@ int acpi_bus_get_private_data(acpi_handle handle, void **data)
 
 	status = acpi_get_data(handle, acpi_bus_private_data_handler, data);
 	if (ACPI_FAILURE(status) || !*data) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
+		ACPI_ERROR((AE_INFO, "No context for object [%p]\n",
 				handle));
 		return -ENODEV;
 	}
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 84a2e29..a1f6fec 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -406,6 +406,7 @@ extern struct kobject *acpi_kobj;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 void acpi_bus_private_data_handler(acpi_handle, void *);
 int acpi_bus_get_private_data(acpi_handle, void **);
+int acpi_bus_attach_private_data(acpi_handle, void *);
 void acpi_bus_no_hotplug(acpi_handle handle);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

