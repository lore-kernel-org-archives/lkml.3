Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbbA0Mjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:39:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbbA0MSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 055/126] ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.
Date: Tue, 27 Jan 2015 12:16:00 +0000
Message-Id: <1422361031-19364-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit c12f07d17c12193256a99e20c9a0f130fb8f7be8 upstream.

ACPICA commit c49dbfed2bc069d0038ea7e1294409bfde7c2c8c

Some potential callers of acpi_setup_gpe_for_wake may know in advance that
there won't be any notify handlers installed for device wake notifications
from the given GPE (one example is a button GPE in Linux). For these cases,
acpi_mark_gpe_for_wake should be used instead of acpi_setup_gpe_for_wake.
This will set the ACPI_GPE_CAN_WAKE flag for the GPE without trying to
setup implicit wake notification for it (since there's no handler method).
Rafael Wysocki.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpica/evxfgpe.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h         |  4 ++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index cb534faf5369..e5e21b24bb2a 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -179,6 +179,53 @@ ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_mark_gpe_for_wake
+ *
+ * PARAMETERS:  gpe_device          - Parent GPE Device. NULL for GPE0/GPE1
+ *              gpe_number          - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Mark a GPE as having the ability to wake the system. Simply
+ *              sets the ACPI_GPE_CAN_WAKE flag.
+ *
+ * Some potential callers of acpi_setup_gpe_for_wake may know in advance that
+ * there won't be any notify handlers installed for device wake notifications
+ * from the given GPE (one example is a button GPE in Linux). For these cases,
+ * acpi_mark_gpe_for_wake should be used instead of acpi_setup_gpe_for_wake.
+ * This will set the ACPI_GPE_CAN_WAKE flag for the GPE without trying to
+ * setup implicit wake notification for it (since there's no handler method).
+ *
+ ******************************************************************************/
+acpi_status acpi_mark_gpe_for_wake(acpi_handle gpe_device, u32 gpe_number)
+{
+	struct acpi_gpe_event_info *gpe_event_info;
+	acpi_status status = AE_BAD_PARAMETER;
+	acpi_cpu_flags flags;
+
+	ACPI_FUNCTION_TRACE(acpi_mark_gpe_for_wake);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	/* Ensure that we have a valid GPE number */
+
+	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
+	if (gpe_event_info) {
+
+		/* Mark the GPE as a possible wake event */
+
+		gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
+		status = AE_OK;
+	}
+
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_mark_gpe_for_wake)
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_setup_gpe_for_wake
  *
  * PARAMETERS:  wake_device         - Device associated with the GPE (via _PRW)
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 35b525c19711..6c77a132b53b 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -658,6 +658,10 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 						u32 gpe_number))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_mark_gpe_for_wake(acpi_handle gpe_device,
+						       u32 gpe_number))
+
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_setup_gpe_for_wake(acpi_handle
 							parent_device,
 							acpi_handle gpe_device,
-- 
2.1.4

