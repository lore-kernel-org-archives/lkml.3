Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbaGPI7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:59:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:5713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbaGPI7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="544083688"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 6/7] ACPI: Add support to force header inclusion rules for <acpi/acpi.h>.
Date: Wed, 16 Jul 2014 16:58:53 +0800
Message-Id: <83e64d3b252019ce4b13fa46244a5c9a63bfc69f.1405500886.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405500886.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1405500886.git.lv.zheng@intel.com>
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
index 6b9ec23..4be4cc94 100644
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
index dfba354..1ba7c19 100644
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

