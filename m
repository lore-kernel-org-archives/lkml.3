Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3FZOHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:07:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61743 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3FZOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:06:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,944,1363132800"; 
   d="scan'208";a="31945186"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
Date: Wed, 26 Jun 2013 10:06:13 -0400
Message-ID: <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
reduced hardware sleep support, and the two changes didn't get
synchronized: The new code doesn't call the hook function (if so
requested). Fix this, requiring a parameter to be added to the
hook function to distinguish "extended" from "legacy" sleep.

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Rafaell J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/acpica/hwesleep.c |    8 ++++++++
 drivers/acpi/acpica/hwsleep.c  |    2 +-
 drivers/acpi/osl.c             |   16 ++++++++--------
 include/linux/acpi.h           |   10 +++++-----
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 5e5f762..6834dd7 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -43,6 +43,7 @@
  */
 
 #include <acpi/acpi.h>
+#include <linux/acpi.h>
 #include "accommon.h"
 
 #define _COMPONENT          ACPI_HARDWARE
@@ -128,6 +129,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	ACPI_FLUSH_CPU_CACHE();
 
+	status = acpi_os_prepare_sleep(sleep_state, acpi_gbl_sleep_type_a,
+				       acpi_gbl_sleep_type_b, true);
+	if (ACPI_SKIP(status))
+		return_ACPI_STATUS(AE_OK);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
 	/*
 	 * Set the SLP_TYP and SLP_EN bits.
 	 *
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index e3828cc..a93c299 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -153,7 +153,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 	ACPI_FLUSH_CPU_CACHE();
 
 	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
-				       pm1b_control);
+				       pm1b_control, false);
 	if (ACPI_SKIP(status))
 		return_ACPI_STATUS(AE_OK);
 	if (ACPI_FAILURE(status))
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e721863..3fc2801 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
 extern char line_buf[80];
 #endif				/*ENABLE_DEBUGGER */
 
-static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
-				      u32 pm1b_ctrl);
+static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 val_a, u32 val_b,
+				      u8 extended);
 
 static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
@@ -1757,13 +1757,13 @@ acpi_status acpi_os_terminate(void)
 	return AE_OK;
 }
 
-acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
-				  u32 pm1b_control)
+acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
+				  u8 extended)
 {
 	int rc = 0;
 	if (__acpi_os_prepare_sleep)
-		rc = __acpi_os_prepare_sleep(sleep_state,
-					     pm1a_control, pm1b_control);
+		rc = __acpi_os_prepare_sleep(sleep_state, val_a, val_b,
+					     extended);
 	if (rc < 0)
 		return AE_ERROR;
 	else if (rc > 0)
@@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
 	return AE_OK;
 }
 
-void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
-			       u32 pm1a_ctrl, u32 pm1b_ctrl))
+void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
+					   u32 val_b, u8 extended))
 {
 	__acpi_os_prepare_sleep = func;
 }
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 17b5b59..de99022 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -477,11 +477,11 @@ static inline bool acpi_driver_match_device(struct device *dev,
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI
-void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
-			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
+void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
+					   u32 val_b, u8 extended));
 
-acpi_status acpi_os_prepare_sleep(u8 sleep_state,
-				  u32 pm1a_control, u32 pm1b_control);
+acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
+				  u8 extended);
 #ifdef CONFIG_X86
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
@@ -491,7 +491,7 @@ static inline void arch_reserve_mem_area(acpi_physical_address addr,
 }
 #endif /* CONFIG_X86 */
 #else
-#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
+#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { } while (0)
 #endif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
-- 
1.7.9.5

