Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3ENRJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:09:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11071 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3ENRJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:09:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,671,1363132800"; 
   d="scan'208";a="23983077"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-acpi@vger.kernel.org>, <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>,
        <linux-pm@lists.linux-foundation.org>,
        Liang Tang <liang.tang@oracle.com>
Subject: [PATCH 1/2] x86/acpi/sleep: Provide registration for acpi_suspend_lowlevel.
Date: Tue, 14 May 2013 13:09:16 -0400
Message-ID: <1368551357-3903-2-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368551357-3903-1-git-send-email-benjamin.guthro@citrix.com>
References: <1368551357-3903-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Which by default will be x86_acpi_suspend_lowlevel.
This registration allows us to register another callback
if there is a need to use another platform specific callback.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>
CC: x86@kernel.org
CC: Len Brown <len.brown@intel.com>
CC: Joseph Cihula <joseph.cihula@intel.com>
CC: Shane Wang <shane.wang@intel.com>
CC: linux-pm@lists.linux-foundation.org
CC: linux-acpi@vger.kernel.org
CC: Len Brown <len.brown@intel.com>
Signed-off-by: Liang Tang <liang.tang@oracle.com>
[v1: Fix when CONFIG_ACPI_SLEEP is not set]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Ben Guthro <benjamin.guthro@citrix.com>
Acked-by: "H. Peter Anvin" <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h  |    2 +-
 arch/x86/kernel/acpi/boot.c  |    7 +++++++
 arch/x86/kernel/acpi/sleep.c |    4 ++--
 arch/x86/kernel/acpi/sleep.h |    2 ++
 drivers/acpi/sleep.c         |    2 ++
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index b31bf97..2dfac58 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -111,7 +111,7 @@ static inline void acpi_disable_pci(void)
 }
 
 /* Low-level suspend routine. */
-extern int acpi_suspend_lowlevel(void);
+extern int (*acpi_suspend_lowlevel)(void);
 
 /* Physical address to resume after wakeup */
 #define acpi_wakeup_address ((unsigned long)(real_mode_header->wakeup_start))
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 230c8ea..d81a972 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -44,6 +44,7 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include "sleep.h" /* To include x86_acpi_suspend_lowlevel */
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 int acpi_disabled;
@@ -559,6 +560,12 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 			   int trigger, int polarity) = acpi_register_gsi_pic;
 
+#ifdef CONFIG_ACPI_SLEEP
+int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
+#else
+int (*acpi_suspend_lowlevel)(void);
+#endif
+
 /*
  * success: return IRQ number (>=0)
  * failure: return < 0
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index b44577b..2a34aaf 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -26,12 +26,12 @@ static char temp_stack[4096];
 #endif
 
 /**
- * acpi_suspend_lowlevel - save kernel state
+ * x86_acpi_suspend_lowlevel - save kernel state
  *
  * Create an identity mapped page table and copy the wakeup routine to
  * low memory.
  */
-int acpi_suspend_lowlevel(void)
+int x86_acpi_suspend_lowlevel(void)
 {
 	struct wakeup_header *header =
 		(struct wakeup_header *) __va(real_mode_header->wakeup_header);
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index 67f59f8..c9c2c98 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -15,3 +15,5 @@ extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
 
 extern void do_suspend_lowlevel(void);
+
+extern int x86_acpi_suspend_lowlevel(void);
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 9c1a435..187ab61 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -494,6 +494,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 		break;
 
 	case ACPI_STATE_S3:
+		if (!acpi_suspend_lowlevel)
+			return -ENOSYS;
 		error = acpi_suspend_lowlevel();
 		if (error)
 			return error;
-- 
1.7.9.5

