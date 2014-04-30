Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaD3CEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:04:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:20435 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaD3CEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="531005102"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 11/27] ACPICA: OSL: Add configurability for memory allocation macros.
Date: Wed, 30 Apr 2014 10:04:42 +0800
Message-Id: <e6fdf9c843dbb870f9f90511ab8ddf8485557075.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSPMs like Linux trend to include all header files but leave empty stub
macros for a feature that is not configured during build.

For macros defined without other symbols referencesd it is safe to leave
them without protections.

By investigation, there are only the following internal/external
symbols referenced by the ACPICA macros:
1. C library symbols, including string, ctype, stdarg APIs.  Since such
   symbols are always accessbile in the kernel source tree, it is safe to
   leave macros referencing them without protected for Linux.
2. ACPICA OSL symbols, such symbols are designed to be used only by ACPICA
   internal APIs.  And there are macros directly referencing mutex and
   memory allocation OSL symbols.  We need to examine the external usages
   of such macros.
   For macros referencing the mutex OSL symbols, fortunately, there is no
   external user directly invoking such macros.
   ========================================================================
   !! IMPORTANT !!
   ========================================================================
   For macros referencing memory allocation OSL symbols -
    1. 'free' - ACPI_FREE
    2. 'alloc' - ACPI_ALLOCATE, ACPI_ALLOCATE_ZEROED, ACPI_ALLOCATE_BUFFER,
                 ACPI_ALLOCATE_LOCAL_BUFFER
   there are external users directly invoking 'alloc' macros.  And the more
   complicated situation is the reversals of such macros are not ACPI_FREE
   but acpi_os_free (or kfree) in Linux.  Though we can define such macros
   into no-op, we in fact cannot define their reversals into no-op.
   This patch adds mechanism to protect ACPICA memory allocation APIs for
   Linux so that acpi_os_free (or kfree) invoked in Linux can have a zero
   address returned by 'alloc' macros to free.  In this
   way, acpi_os_free (or kfree) can be converted into no-op.
   ========================================================================
3. ACPI_OFFSET and other macros that would access structure members, we
   need to check if such structure members are not accessible under a
   specific configuration.  Fortunately, currently Linux doesn't use such
   structure members when CONFIG_ACPI is disabled.

This patch thus only adds mechanism useful for implementing stubs for
ACPICA provided macros - the configurability of memory allocation APIs.

This patch doesn't include code for Linux to use this new mechanism, thus
no functional changes.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 include/acpi/actypes.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index e763565..19b26bb 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -329,6 +329,15 @@ typedef u32 acpi_physical_address;
  *
  ******************************************************************************/
 
+#ifdef ACPI_NO_MEM_ALLOCATIONS
+
+#define ACPI_ALLOCATE(a)                NULL
+#define ACPI_ALLOCATE_ZEROED(a)         NULL
+#define ACPI_FREE(a)
+#define ACPI_MEM_TRACKING(a)
+
+#else				/* ACPI_NO_MEM_ALLOCATIONS */
+
 #ifdef ACPI_DBG_TRACK_ALLOCATIONS
 /*
  * Memory allocation tracking (used by acpi_exec to detect memory leaks)
@@ -350,6 +359,8 @@ typedef u32 acpi_physical_address;
 
 #endif				/* ACPI_DBG_TRACK_ALLOCATIONS */
 
+#endif				/* ACPI_NO_MEM_ALLOCATIONS */
+
 /******************************************************************************
  *
  * ACPI Specification constants (Do not change unless the specification changes)
@@ -928,9 +939,19 @@ struct acpi_object_list {
  * Miscellaneous common Data Structures used by the interfaces
  */
 #define ACPI_NO_BUFFER              0
+
+#ifdef ACPI_NO_MEM_ALLOCATIONS
+
+#define ACPI_ALLOCATE_BUFFER        (acpi_size) (0)
+#define ACPI_ALLOCATE_LOCAL_BUFFER  (acpi_size) (0)
+
+#else				/* ACPI_NO_MEM_ALLOCATIONS */
+
 #define ACPI_ALLOCATE_BUFFER        (acpi_size) (-1)	/* Let ACPICA allocate buffer */
 #define ACPI_ALLOCATE_LOCAL_BUFFER  (acpi_size) (-2)	/* For internal use only (enables tracking) */
 
+#endif				/* ACPI_NO_MEM_ALLOCATIONS */
+
 struct acpi_buffer {
 	acpi_size length;	/* Length in bytes of the buffer */
 	void *pointer;		/* pointer to buffer */
-- 
1.7.10

