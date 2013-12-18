Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3LRJHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:07:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:45788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab3LRJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:06:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="446200403"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 07/15] ACPICA: OSL: Add configurability mechanism for external APIs.
Date: Wed, 18 Dec 2013 17:06:32 +0800
Message-Id: <7a34a516c788198e290cad55e5904bb39c16590b.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSPMs like Linux trend to include all header files but leave empty inline
stub functions for a feature that is not configured during build.
This patch adds wrappers mechanism to be used around ACPICA external
interfaces to facilitate OSPM with such configurability.
This patch doesn't include code for Linux to use this mechanism.

Note that in order to the reduce the difficulties caused by the source code
differences between Linux and ACPICA upstream of maintaining large
ACPI_EXTERNAL_RETURN_x macro updates, actual ACPI_EXTERNAL_RETURN_x macro
usages are done and split into other commits.

ACPICA commits will be linuxized by the scripts. If there were divergences
in the middle of a diff block, the linuxized diff block should require
human intervention to be performed to make it possible to apply the
linuxized commit into Linux source tree.  Sometime such human intervention
will be very difficult as the linuxized commits will be messed up in
addition to the normal line offsettings by the patch/diff based utilities.
Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpixf.h           |   33 ++++++++++++++++++++++++++++++---
 include/acpi/platform/aclinux.h |   13 +++++++++++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 08a1fdb..ed6c53b 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -95,6 +95,33 @@ extern u32 acpi_rsdt_forced;
 
 #endif
 
+/* ACPICA prototypes */
+
+#ifndef ACPI_EXTERNAL_RETURN_STATUS
+#define ACPI_EXTERNAL_RETURN_STATUS(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_OK
+#define ACPI_EXTERNAL_RETURN_OK(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_VOID
+#define ACPI_EXTERNAL_RETURN_VOID(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_UINT32
+#define ACPI_EXTERNAL_RETURN_UINT32(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_PTR
+#define ACPI_EXTERNAL_RETURN_PTR(prototype) \
+	prototype;
+#endif
+
 /* Public globals, available from outside ACPICA subsystem */
 
 /*****************************************************************************
@@ -215,11 +242,11 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_no_resource_disassembly, FALSE)
  */
 #if (!ACPI_REDUCED_HARDWARE)
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_STATUS(prototype)
 #define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_OK(prototype)
 #define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_VOID(prototype)
 #else
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
 	static ACPI_INLINE prototype {return(AE_NOT_CONFIGURED);}
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 45df524..12ef8be 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -100,6 +100,19 @@
 #define ACPI_INIT_GLOBAL(t,a,b)
 #define ACPI_GLOBAL_FADT
 
+/* External interface for __KERNEL__, stub is needed */
+
+#define ACPI_EXTERNAL_RETURN_STATUS(prototype) \
+	static ACPI_INLINE prototype {return(AE_NOT_CONFIGURED);}
+#define ACPI_EXTERNAL_RETURN_OK(prototype) \
+	static ACPI_INLINE prototype {return(AE_OK);}
+#define ACPI_EXTERNAL_RETURN_VOID(prototype) \
+	static ACPI_INLINE prototype {return;}
+#define ACPI_EXTERNAL_RETURN_UINT32(prototype) \
+	static ACPI_INLINE prototype {return(0);}
+#define ACPI_EXTERNAL_RETURN_PTR(prototype) \
+	static ACPI_INLINE prototype {return(NULL);}
+
 /* Immediates to protect global variables accesses */
 
 #define acpi_current_gpe_count              0
-- 
1.7.10.4

