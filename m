Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaGGERz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:17:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:17623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbaGGERv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:17:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="558140278"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 7/7] ACPI: Add support to force header inclusion rules for <acpi/acpi.h>.
Date: Mon,  7 Jul 2014 12:17:48 +0800
Message-Id: <cc97bdcabb45cb4021512da65868041b1ce26d5f.1404706299.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404706298.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is only CONFIG_ACPI=n processing in the <linux/acpi.h>, it is not
safe to include <acpi/acpi.h> directly for source out of Linux ACPI
subsystems.

This patch adds error messaging to warn developers of such wrong
inclusions.

In order not to be bisected and reverted as a wrong commit, warning
messages are carefully split into a seperate patch other than the wrong
inclusion cleanups.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/Makefile    |    2 +-
 include/acpi/platform/aclinux.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 8bb43f0..87a24ac 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -2,7 +2,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os
+ccflags-y			:= -Os -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index d63a54b4..6107483 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -44,6 +44,16 @@
 #ifndef __ACLINUX_H__
 #define __ACLINUX_H__
 
+#ifdef __KERNEL__
+
+/* ACPICA external files should not include ACPICA headers directly. */
+
+#if !defined(BUILDING_ACPICA) && !defined(_LINUX_ACPI_H)
+#error "Please don't include <acpi/acpi.h> directly, include <linux/acpi.h> instead."
+#endif
+
+#endif
+
 /* Common (in-kernel/user-space) ACPICA configuration */
 
 #define ACPI_USE_SYSTEM_CLIBRARY
-- 
1.7.10

