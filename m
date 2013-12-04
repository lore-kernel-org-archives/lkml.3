Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3LDAlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:41:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:19455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3LDAlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:41:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="444154797"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Peter Jones <pjones@redhat.com>
Subject: [RFC PATCH 3/3] ACPI/IBFT: Fix wrong <acpi/acpi.h> inclusion in iSCSI boot firmware module.
Date: Wed,  4 Dec 2013 08:38:34 +0800
Message-Id: <34affbf336457b582869b83aed979a9522d9bc3f.1386116927.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1386116927.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386116927.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
all external modules should depend on CONFIG_ACPI rather than using ACPICA
header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
dependent modules.

One of the build breakage is:
drivers/firmware/iscsi_ibft_find.c: In function 'find_ibft_region':
drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type
drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type
drivers/firmware/iscsi_ibft_find.c:106:12: error: dereferencing pointer to incomplete type

The root cause of this breakage is:
1. iBFT locating is implemented by looking up it in the memory.  This is
   based on the specification.  Specification doesn't mention if it can
   appear on a non-ACPI platforms but mentions it is defined in ACPI 3.0b.
   The current CONFIG_ISCSI_IBFT_FIND doesn't use ACPI table APIs to locate
   the table, thus it doesn't rely on CONFIG_ACPI.

Since ACPI iSCSI Boot Firmware is an ACPI-based mechanism (please refer to
the Doclink below), we can make CONFIG_ISCSI_IBFT_FIND dependent on
CONFIG_ACPI though the locating mechanism can be implemented without using
ACPI table APIs.  But please let me know if this is wrong.

Doclink: http://www.microsoft.com/whdc/system/platform/firmware/ibft.mspx
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/firmware/Kconfig   |    2 +-
 include/linux/iscsi_ibft.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 0747872..a6ef6ac 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -110,7 +110,7 @@ config DMI_SYSFS
 
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
-	depends on X86
+	depends on X86 && ACPI
 	default n
 	help
 	  This option enables the kernel to find the region of memory
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index 82f9673..605cc5c 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -21,7 +21,7 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
+#include <linux/acpi.h>
 
 /*
  * Logical location of iSCSI Boot Format Table.
-- 
1.7.10

