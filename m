Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaBKCwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:52:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:64070 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaBKCvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:51:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,822,1384329600"; 
   d="scan'208";a="453229969"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 2/2] ACPICA: acpidump: Remove translation protection on integer types.
Date: Tue, 11 Feb 2014 10:51:43 +0800
Message-Id: <55e016394ee9d4291e8c42e00383c93a3ace4b0b.1392086457.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1392086457.git.lv.zheng@intel.com>
References: <cover.1392086457.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove translation protection for applications as Linux tools folder will
start to use such types.

In Linux kernel source tree, after removing this translation protection,
the u8/u16/u32/u64/s32/s64 typedefs are exposed for both __KERNEL__ builds
and !__KERNEL__ builds (tools/power/acpi) and the original definitions of
ACPI_UINT8/16/32/64_MAX are changed.

For !__KERNEL__ builds, this kind of defintions should already been tested
by the distribution vendors that are distributing binary ACPICA package and
we've achieved the successful built/run test result in the kernel source
tree.

For __KERNEL__ builds, there are 2 things affected:
1. u8/u16/u32/u64/s32/s64 type definitions:
   Since Linux has already type defined u8/u16/u32/u64/s32/s64 in
   include/uapi/asm-generic/int-ll64.h for __KERNEL__.  In order not to
   introduce build regressions where the 2 typedefs are differed,
   ACPI_USE_SYSTEM_INTTYPES is introduced to mask out ACPICA's typedefs.
   It must be defined for Linux __KERNEL__ builds.
2. ACPI_UINT8/16/32/64_MAX definitions:
   Before applying this change:
     ACPI_UINT8_MAX: sizeof (UINT8)
      UINT8: unsigned char
     ACPI_UINT16_MAX: sizeof (UINT16)
      UINT16: unsigned short
     ACPI_UINT32_MAX: sizeof (UINT32)
      INT32: int
      UINT32: unsigned int
     ACPI_UINT64_MAX: sizeof (UINT64)
      INT64: COMPILER_DEPENDENT_INT64
       COMPILER_DEPENDENT_INT64: signed long (IA64) or
                                 signed long long (IA32)
      UINT64: COMPILER_DEPENDENT_UINT64
       COMPILER_DEPENDENT_UINT64: unsigned long (IA64) or
                                  unsigned long long (IA32)
   After applying this change:
     ACPI_UINT8_MAX: sizeof (u8)
      u8: unsigned char
      UINT8: (removed from actypes.h)
     ACPI_UINT16_MAX: sizeof (u16)
      u16: unsigned short
      UINT16: (removed from actypes.h)
     ACPI_UINT32_MAX: sizeof (u32)
      INT32/UINT32: (removed from actypes.h)
      s32: signed int
      u32: unsigned int
     ACPI_UINT64_MAX: sizeof (u64)
      INT64/UINT64: (removed from actypes.h)
      u64: unsigned long long
      s64: signed long long
      COMPILER_DEPENDENT_INT64: signed long (IA64) (not used any more)
                                signed long long (IA32) (not used any more)
      COMPILER_DEPENDENT_UINT64: unsigned long (IA64) (not used any more)
                                 unsigned long long (IA32) (not used any more)
   All definitions are equal except ACPI_UINT64_MAX for CONFIG_IA64.  It
   is changed from sizeof(unsigned long) to sizeof(unsigned long long).
   By investigation, 64bit Linux kernel build is LP64 compliant, i.e.,
   sizeof(long) and (pointer) are 64.  As sizeof(unsigned long) equals to
   sizeof(unsigned long long) on IA64 platform where CONFIG_64BIT cannot be
   disabled, this change actually will not affect the value of
   ACPI_UINT64_MAX on IA64 platforms.

This patch is generated as linuxized acpidump is failed to be compiled due
to lacking in u8/u16/u32/u64/s32/s64 definitions.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 include/acpi/actypes.h          |   64 +++++++++++++++++++--------------------
 include/acpi/platform/aclinux.h |    2 ++
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 68a3ada..86e9f13 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -55,18 +55,16 @@
 #error ACPI_MACHINE_WIDTH not defined
 #endif
 
-/*! [Begin] no source code translation */
-
 /*
  * Data type ranges
  * Note: These macros are designed to be compiler independent as well as
  * working around problems that some 32-bit compilers have with 64-bit
  * constants.
  */
-#define ACPI_UINT8_MAX                  (UINT8) (~((UINT8)  0))	/* 0xFF               */
-#define ACPI_UINT16_MAX                 (UINT16)(~((UINT16) 0))	/* 0xFFFF             */
-#define ACPI_UINT32_MAX                 (UINT32)(~((UINT32) 0))	/* 0xFFFFFFFF         */
-#define ACPI_UINT64_MAX                 (UINT64)(~((UINT64) 0))	/* 0xFFFFFFFFFFFFFFFF */
+#define ACPI_UINT8_MAX                  (u8) (~((u8)  0))	/* 0xFF               */
+#define ACPI_UINT16_MAX                 (u16)(~((u16) 0))	/* 0xFFFF             */
+#define ACPI_UINT32_MAX                 (u32)(~((u32) 0))	/* 0xFFFFFFFF         */
+#define ACPI_UINT64_MAX                 (u64)(~((u64) 0))	/* 0xFFFFFFFFFFFFFFFF */
 #define ACPI_ASCII_MAX                  0x7F
 
 /*
@@ -77,18 +75,18 @@
  *
  * 1) The following types are of fixed size for all targets (16/32/64):
  *
- * BOOLEAN      Logical boolean
+ * u8           Logical boolean
  *
- * UINT8        8-bit  (1 byte) unsigned value
- * UINT16       16-bit (2 byte) unsigned value
- * UINT32       32-bit (4 byte) unsigned value
- * UINT64       64-bit (8 byte) unsigned value
+ * u8           8-bit  (1 byte) unsigned value
+ * u16          16-bit (2 byte) unsigned value
+ * u32          32-bit (4 byte) unsigned value
+ * u64          64-bit (8 byte) unsigned value
  *
- * INT16        16-bit (2 byte) signed value
- * INT32        32-bit (4 byte) signed value
- * INT64        64-bit (8 byte) signed value
+ * s16          16-bit (2 byte) signed value
+ * s32          32-bit (4 byte) signed value
+ * s64          64-bit (8 byte) signed value
  *
- * COMPILER_DEPENDENT_UINT64/INT64 - These types are defined in the
+ * COMPILER_DEPENDENT_UINT64/s64 - These types are defined in the
  * compiler-dependent header(s) and were introduced because there is no common
  * 64-bit integer type across the various compilation models, as shown in
  * the table below.
@@ -110,11 +108,11 @@
  * usually used for memory allocation, efficient loop counters, and array
  * indexes. The types are similar to the size_t type in the C library and are
  * required because there is no C type that consistently represents the native
- * data width. ACPI_SIZE is needed because there is no guarantee that a
+ * data width. acpi_size is needed because there is no guarantee that a
  * kernel-level C library is present.
  *
- * ACPI_SIZE        16/32/64-bit unsigned value
- * ACPI_NATIVE_INT  16/32/64-bit signed value
+ * acpi_size        16/32/64-bit unsigned value
+ * acpi_native_int  16/32/64-bit signed value
  */
 
 /*******************************************************************************
@@ -123,13 +121,15 @@
  *
  ******************************************************************************/
 
-typedef unsigned char BOOLEAN;
-typedef unsigned char UINT8;
-typedef unsigned short UINT16;
-typedef COMPILER_DEPENDENT_UINT64 UINT64;
-typedef COMPILER_DEPENDENT_INT64 INT64;
+#ifndef ACPI_USE_SYSTEM_INTTYPES
+
+typedef unsigned char u8;
+typedef unsigned char u8;
+typedef unsigned short u16;
+typedef COMPILER_DEPENDENT_UINT64 u64;
+typedef COMPILER_DEPENDENT_INT64 s64;
 
-/*! [End] no source code translation !*/
+#endif				/* ACPI_USE_SYSTEM_INTTYPES */
 
 /*
  * Value returned by acpi_os_get_thread_id. There is no standard "thread_id"
@@ -149,12 +149,12 @@ typedef COMPILER_DEPENDENT_INT64 INT64;
 
 #if ACPI_MACHINE_WIDTH == 64
 
-/*! [Begin] no source code translation (keep the typedefs as-is) */
+#ifndef ACPI_USE_SYSTEM_INTTYPES
 
-typedef unsigned int UINT32;
-typedef int INT32;
+typedef unsigned int u32;
+typedef int s32;
 
-/*! [End] no source code translation !*/
+#endif				/* ACPI_USE_SYSTEM_INTTYPES */
 
 typedef s64 acpi_native_int;
 
@@ -188,12 +188,12 @@ typedef u64 acpi_physical_address;
 
 #elif ACPI_MACHINE_WIDTH == 32
 
-/*! [Begin] no source code translation (keep the typedefs as-is) */
+#ifndef ACPI_USE_SYSTEM_INTTYPES
 
-typedef unsigned int UINT32;
-typedef int INT32;
+typedef unsigned int u32;
+typedef int s32;
 
-/*! [End] no source code translation !*/
+#endif				/* ACPI_USE_SYSTEM_INTTYPES */
 
 typedef s32 acpi_native_int;
 
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f41f59b..a24c8f0 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -58,6 +58,8 @@
 #define ACPI_REDUCED_HARDWARE 1
 #endif
 
+#define ACPI_USE_SYSTEM_INTTYPES
+
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
-- 
1.7.10

