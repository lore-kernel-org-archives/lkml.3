Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaE0R23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:28:29 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54628 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaE0R2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:28:25 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 3/6] ACPI: sleep: Update acpi_set_firmware_waking_vector() invocations to favor 32-bit firmware waking vector.
Date: Wed, 28 May 2014 01:28:06 +0800
Message-Id: <a77ef53a18f1b6d1823531f4f9cc60e280ba5f52.1401210685.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1401210684.git.lv.zheng@intel.com>
References: <38907770.bupFXhytsS@vostro.rjw.lan> <cover.1401210684.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

This patch updates acpi_set_firmware_waking_vector() invocations in order
to keep 32-bit firmware waking vector favor for Linux.

64-bit firmware waking vector has never been enabled by Linux.  The
(acpi_physical_address)0 for 64-bit address can be used to force ACPICA to
set only 32-bit firmware waking vector for Linux.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Oswald Buddenhagen <ossi@kde.org>
---
 arch/ia64/include/asm/acpi.h |    1 +
 arch/x86/include/asm/acpi.h  |    3 ++-
 drivers/acpi/sleep.c         |    8 ++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index 75dc59a..45e45ec 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -75,6 +75,7 @@ int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 extern int acpi_suspend_lowlevel(void);
 
 extern unsigned long acpi_wakeup_address;
+#define acpi_wakeup_address64	((acpi_physical_address)0)
 
 /*
  * Record the cpei override flag and current logical cpu. This is
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index e06225e..46a7dd8 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -71,7 +71,8 @@ static inline void acpi_disable_pci(void)
 extern int (*acpi_suspend_lowlevel)(void);
 
 /* Physical address to resume after wakeup */
-#define acpi_wakeup_address ((unsigned long)(real_mode_header->wakeup_start))
+#define acpi_wakeup_address	((acpi_physical_address)(real_mode_header->wakeup_start))
+#define acpi_wakeup_address64	((acpi_physical_address)(0))
 
 /*
  * Check if the CPU can handle C2 and deeper
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index c11e379..5ca7ab0 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -23,6 +23,8 @@
 #include "internal.h"
 #include "sleep.h"
 
+#define ACPI_NO_WAKING_VECTOR		((acpi_physical_address)0)
+
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
@@ -59,7 +61,8 @@ static int acpi_sleep_prepare(u32 acpi_state)
 	if (acpi_state == ACPI_STATE_S3) {
 		if (!acpi_wakeup_address)
 			return -EFAULT;
-		acpi_set_firmware_waking_vector(acpi_wakeup_address);
+		acpi_set_firmware_waking_vector(acpi_wakeup_address,
+						acpi_wakeup_address64);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
@@ -403,7 +406,8 @@ static void acpi_pm_finish(void)
 	acpi_leave_sleep_state(acpi_state);
 
 	/* reset firmware waking vector */
-	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+	acpi_set_firmware_waking_vector(ACPI_NO_WAKING_VECTOR,
+					ACPI_NO_WAKING_VECTOR);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
 
-- 
1.7.10

