Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3G3MZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:25:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10356 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3G3MZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,778,1367971200"; 
   d="scan'208";a="40169449"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH v8 1/3] x86/acpi: Introduce acpi_os_prepare_extended_sleep callback for extended sleep path
Date: Tue, 30 Jul 2013 08:24:52 -0400
Message-ID: <1375187094-19357-2-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
References: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like acpi_os_prepare_sleep, register a callback for use in systems like
tboot, and xen, which have system specific requirements outside of acpica.
This mirrors the functionality in acpi_os_prepare_sleep(), called from
acpi_hw_sleep()

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
---
 drivers/acpi/acpica/hwesleep.c |    9 +++++++++
 drivers/acpi/osl.c             |   24 ++++++++++++++++++++++++
 include/linux/acpi.h           |    7 +++++++
 3 files changed, 40 insertions(+)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 5e5f762..4140768 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -43,6 +43,7 @@
  */
 
 #include <acpi/acpi.h>
+#include <linux/acpi.h>
 #include "accommon.h"
 
 #define _COMPONENT          ACPI_HARDWARE
@@ -128,6 +129,14 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	ACPI_FLUSH_CPU_CACHE();
 
+	status = acpi_os_prepare_extended_sleep(sleep_state,
+						acpi_gbl_sleep_type_a,
+						acpi_gbl_sleep_type_b);
+	if (ACPI_SKIP(status))
+		return_ACPI_STATUS(AE_OK);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
 	/*
 	 * Set the SLP_TYP and SLP_EN bits.
 	 *
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..a934950 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -79,6 +79,8 @@ extern char line_buf[80];
 
 static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
 				      u32 pm1b_ctrl);
+static int (*__acpi_os_prepare_extended_sleep)(u8 sleep_state, u32 val_a,
+				      u32 val_b);
 
 static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
@@ -1779,6 +1781,28 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 	__acpi_os_prepare_sleep = func;
 }
 
+acpi_status acpi_os_prepare_extended_sleep(u8 sleep_state, u32 val_a,
+				  u32 val_b)
+{
+	int rc = 0;
+	if (__acpi_os_prepare_extended_sleep)
+		rc = __acpi_os_prepare_extended_sleep(sleep_state,
+					     val_a, val_b);
+	if (rc < 0)
+		return AE_ERROR;
+	else if (rc > 0)
+		return AE_CTRL_SKIP;
+
+	return AE_OK;
+}
+
+void acpi_os_set_prepare_extended_sleep(int (*func)(u8 sleep_state,
+			       u32 val_a, u32 val_b))
+{
+	__acpi_os_prepare_extended_sleep = func;
+}
+
+
 void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
 			void (*func)(struct work_struct *work))
 {
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 353ba25..a5db4ae 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -481,6 +481,13 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 
 acpi_status acpi_os_prepare_sleep(u8 sleep_state,
 				  u32 pm1a_control, u32 pm1b_control);
+
+void acpi_os_set_prepare_extended_sleep(int (*func)(u8 sleep_state,
+				        u32 val_a,  u32 val_b));
+
+acpi_status acpi_os_prepare_extended_sleep(u8 sleep_state,
+					   u32 val_a, u32 val_b);
+
 #ifdef CONFIG_X86
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
-- 
1.7.9.5

