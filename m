Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3KLARE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:17:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:54478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab3KLAQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:16:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407152574"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Olof Johansson <olof@lixom.net>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC PATCH 3/3] x86, boot: Change the BIOS corruption checker to scan 640K
Date: Mon, 11 Nov 2013 16:16:47 -0800
Message-Id: <1384215407-22288-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Change the BIOS corruption checker to scan 640K if enabled.  This is
the normal amount that we otherwise would reserve with the new default
settings; change the Kconfig help message to indicate that this is now
intended as a diagnostic tool when one is considering enabling any
chunk of low memory.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Olof Johansson <olof@lixom.net>
Link: http://lkml.kernel.org/r/528168CB.7070602@linux.intel.com
---
 arch/x86/Kconfig        | 25 +++++++++++--------------
 arch/x86/kernel/check.c | 10 +++++-----
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7631122..554aedd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1384,24 +1384,21 @@ config HIGHPTE
 config X86_CHECK_BIOS_CORRUPTION
 	bool "Check for low memory corruption"
 	---help---
-	  Periodically check for memory corruption in low memory, which
-	  is suspected to be caused by BIOS.  Even when enabled in the
-	  configuration, it is disabled at runtime.  Enable it by
-	  setting "memory_corruption_check=1" on the kernel command
-	  line.  By default it scans the low 64k of memory every 60
-	  seconds; see the memory_corruption_check_size and
+	  Periodically check for memory corruption in low memory,
+	  which is suspected to be caused by BIOS.  Even when enabled
+	  in the configuration, it is disabled at runtime.  Enable it
+	  by setting "memory_corruption_check=1" on the kernel command
+	  line.  By default it reserves and scans the low 640K of
+	  memory every 60 seconds; see the
+	  memory_corruption_check_size and
 	  memory_corruption_check_period parameters in
 	  Documentation/kernel-parameters.txt to adjust this.
 
-	  When enabled with the default parameters, this option has
-	  almost no overhead, as it reserves a relatively small amount
-	  of memory and scans it infrequently.  It both detects corruption
-	  and prevents it from affecting the running system.
-
-	  It is, however, intended as a diagnostic tool; if repeatable
+	  It is intended as a diagnostic tool; if repeatable
 	  BIOS-originated corruption always affects the same memory,
-	  you can use memmap= to prevent the kernel from using that
-	  memory.
+	  you should use the memmap= or reservelow= runtime options or
+	  the CONFIG_X86_RESERVE_LOW compile time option to prevent
+	  the kernel from using that memory.
 
 config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
 	bool "Set the default setting of memory_corruption_check"
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index e2dbcb7..c00182d 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -7,16 +7,16 @@
 #include <asm/proto.h>
 
 /*
- * Some BIOSes seem to corrupt the low 64k of memory during events
- * like suspend/resume and unplugging an HDMI cable.  Reserve all
- * remaining free memory in that area and fill it with a distinct
- * pattern.
+ * Some BIOSes and even some hardware devices seem to corrupt the low
+ * 640K of memory during events like suspend/resume and unplugging an
+ * HDMI cable.  Reserve all remaining free memory in that area and
+ * fill it with a distinct pattern.
  */
 #define MAX_SCAN_AREAS	8
 
 static int __read_mostly memory_corruption_check = -1;
 
-static unsigned __read_mostly corruption_check_size = 64*1024;
+static unsigned __read_mostly corruption_check_size = 640*1024;
 static unsigned __read_mostly corruption_check_period = 60; /* seconds */
 
 static struct scan_area {
-- 
1.8.3.1

