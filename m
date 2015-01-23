Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbbAWApe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:45:34 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64834 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbbAWApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:45:11 -0500
From: al.stone@linaro.org
To: tony.luck@intel.com, fenghua.yu@intel.com, rjw@rjwysocki.net,
        catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        robert.moore@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@acpica.org, linaro-acpi@lists.linaro.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: [PATCH 7/7] ACPI: use Linux as ACPI_OS_NAME for _OS on ARM64
Date: Thu, 22 Jan 2015 17:44:44 -0700
Message-Id: <1421973884-13029-8-git-send-email-al.stone@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421973884-13029-1-git-send-email-al.stone@linaro.org>
References: <1421973884-13029-1-git-send-email-al.stone@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

ACPI_OS_NAME is globally defined as "Microsoft Windows NT" for now.
That doesn't make much sense in the ARM context, so set it to "Linux"
when CONFIG_ARM64.

If it is necessary to change the return value from \_OS_ (that is, return
some value other than the default in ACPI_OS_NAME), use the kernel parameter
"acpi_os_name=<string>".

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/Kconfig              | 1 +
 drivers/acpi/Kconfig            | 8 ++++++++
 include/acpi/acconfig.h         | 2 ++
 include/acpi/platform/aclinux.h | 4 ++++
 4 files changed, 15 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 915aa16..20677d1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,5 +1,6 @@
 config ARM64
 	def_bool y
+	select ACPI_OS_NAME_LINUX if ACPI
 	select ACPI_REDUCED_HARDWARE_ONLY if ACPI
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 3e3bd35..024c5f0 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -369,6 +369,14 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	  If you are unsure what to do, do not enable this option.
 
+config ACPI_OS_NAME_LINUX
+	bool "Using Linux for _OS method" if EXPERT
+	def_bool n
+	  When used, this option makes sure the _OS method returns
+	  the value "Linux".
+
+	  If you are unsure what to do, do not enable this option.
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/include/acpi/acconfig.h b/include/acpi/acconfig.h
index 5a0a3e5..1980bf4 100644
--- a/include/acpi/acconfig.h
+++ b/include/acpi/acconfig.h
@@ -69,7 +69,9 @@
  * code that will not execute the _OSI method unless _OS matches the string
  * below.  Therefore, change this string at your own risk.
  */
+#ifndef ACPI_OS_NAME
 #define ACPI_OS_NAME                    "Microsoft Windows NT"
+#endif
 
 /* Maximum objects in the various object caches */
 
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 1ba7c19..a8a7ee3 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -69,6 +69,10 @@
 #define ACPI_REDUCED_HARDWARE 1
 #endif
 
+#ifdef CONFIG_ACPI_OS_NAME_LINUX
+#define ACPI_OS_NAME "Linux"
+#endif
+
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-- 
2.1.0

