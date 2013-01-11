Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3AKWoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:44:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22864 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3AKWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:20 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 17/22] PCI, ACPI: Add alloc_acpi_hp_work()
Date: Fri, 11 Jan 2013 14:40:44 -0800
Message-Id: <1357944049-29620-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use it with acpiphp and pci_root_hp events handling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/osl.c      |   21 +++++++++++++++++++++
 include/acpi/acpiosxf.h |    9 +++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3ff2678..e6539a3 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1778,3 +1778,24 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 {
 	__acpi_os_prepare_sleep = func;
 }
+
+void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
+			void (*func)(struct work_struct *work))
+{
+	struct acpi_hp_work *hp_work;
+	int ret;
+
+	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
+	if (!hp_work)
+		return;
+
+	hp_work->handle = handle;
+	hp_work->type = type;
+	hp_work->context = context;
+
+	INIT_WORK(&hp_work->work, func);
+	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
+	if (!ret)
+		kfree(hp_work);
+}
+EXPORT_SYMBOL(alloc_acpi_hp_work);
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 4315274..2a64da5 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -195,6 +195,15 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
  */
 extern struct workqueue_struct *kacpi_hotplug_wq;
 
+struct acpi_hp_work {
+	struct work_struct work;
+	acpi_handle handle;
+	u32 type;
+	void *context;
+};
+void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
+			void (*func)(struct work_struct *work));
+
 acpi_thread_id acpi_os_get_thread_id(void);
 
 acpi_status
-- 
1.7.10.4

