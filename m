Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab3HGUky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60708 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:51 -0400
Message-ID: <201308072040.r77Keoli016113@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 11:55:35 -0400
Subject: [PATCH] tile: improve big-endian support
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, fix a bug in asm/unaligned.h; we need to just use the asm-generic
unaligned.h so we properly choose endian-correct flavors.

Second, keep the hv/hypervisor.h ABI fully "native" in the sense that
we don't have __BIG_ENDIAN__ ifdefs there.  Instead, we use macros in
the head_NN.S assembly code to properly extract two 32-bit structure
members from a 64-bit register holding the structure.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/unaligned.h | 14 +++++++++-----
 arch/tile/include/hv/hypervisor.h | 16 ----------------
 arch/tile/kernel/head_64.S        | 24 ++++++++++++++----------
 3 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/arch/tile/include/asm/unaligned.h b/arch/tile/include/asm/unaligned.h
index 37dfbe5..5a58a0d 100644
--- a/arch/tile/include/asm/unaligned.h
+++ b/arch/tile/include/asm/unaligned.h
@@ -15,11 +15,15 @@
 #ifndef _ASM_TILE_UNALIGNED_H
 #define _ASM_TILE_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+/*
+ * We could implement faster get_unaligned_[be/le]64 using the ldna
+ * instruction on tilegx; however, we need to either copy all of the
+ * other generic functions to here (which is pretty ugly) or else
+ * modify both the generic code and other arch code to allow arch
+ * specific unaligned data access functions.  Given these functions
+ * are not often called, we'll stick with the generic version.
+ */
+#include <asm-generic/unaligned.h>
 
 /*
  * Is the kernel doing fixups of unaligned accesses?  If <0, no kernel
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index f882ebc..0971ebb 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -564,16 +564,11 @@ int hv_confstr(HV_ConfstrQuery query, HV_VirtAddr buf, int len);
 /** Tile coordinate */
 typedef struct
 {
-#ifndef __BIG_ENDIAN__
   /** X coordinate, relative to supervisor's top-left coordinate */
   int x;
 
   /** Y coordinate, relative to supervisor's top-left coordinate */
   int y;
-#else
-  int y;
-  int x;
-#endif
 } HV_Coord;
 
 
@@ -1119,13 +1114,8 @@ HV_VirtAddrRange hv_inquire_virtual(int idx);
 /** A range of ASID values. */
 typedef struct
 {
-#ifndef __BIG_ENDIAN__
   HV_ASID start;        /**< First ASID in the range. */
   unsigned int size;    /**< Number of ASIDs. Zero for an invalid range. */
-#else
-  unsigned int size;    /**< Number of ASIDs. Zero for an invalid range. */
-  HV_ASID start;        /**< First ASID in the range. */
-#endif
 } HV_ASIDRange;
 
 /** Returns information about a range of ASIDs.
@@ -1449,7 +1439,6 @@ typedef enum
 /** Message recipient. */
 typedef struct
 {
-#ifndef __BIG_ENDIAN__
   /** X coordinate, relative to supervisor's top-left coordinate */
   unsigned int x:11;
 
@@ -1458,11 +1447,6 @@ typedef struct
 
   /** Status of this recipient */
   HV_Recip_State state:10;
-#else //__BIG_ENDIAN__
-  HV_Recip_State state:10;
-  unsigned int y:11;
-  unsigned int x:11;
-#endif
 } HV_Recipient;
 
 /** Send a message to a set of recipients.
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index e23e5f7..ed51320 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -25,6 +25,15 @@
 #include <arch/chip.h>
 #include <arch/spr_def.h>
 
+/* Extract two 32-bit bit values that were read into one register. */
+#ifdef __BIG_ENDIAN__
+#define GET_FIRST_INT(rd, rs) shrsi rd, rs, 32
+#define GET_SECOND_INT(rd, rs) addxi rd, rs, 0
+#else
+#define GET_FIRST_INT(rd, rs) addxi rd, rs, 0
+#define GET_SECOND_INT(rd, rs) shrsi rd, rs, 32
+#endif
+
 /*
  * This module contains the entry code for kernel images. It performs the
  * minimal setup needed to call the generic C routines.
@@ -61,7 +70,7 @@ ENTRY(_start)
 	 * other CPUs should see a properly-constructed page table.
 	 */
 	{
-	  v4int_l r2, zero, r0    /* ASID for hv_install_context */
+	  GET_FIRST_INT(r2, r0)    /* ASID for hv_install_context */
 	  moveli r4, hw1_last(swapper_pgprot - PAGE_OFFSET)
 	}
 	{
@@ -131,19 +140,14 @@ ENTRY(_start)
 	shl16insli r0, r0, hw0(MEM_SV_START)
 	mtspr SPR_INTERRUPT_VECTOR_BASE_K, r0
 
-	/*
-	 * Get our processor number and save it away in SAVE_K_0.
-	 * Extract stuff from the topology structure: r4 = y, r6 = x,
-	 * r5 = width.  FIXME: consider whether we want to just make these
-	 * 64-bit values (and if so fix smp_topology write below, too).
-	 */
+	/* Get our processor number and save it away in SAVE_K_0. */
 	jal hv_inquire_topology
 	{
-	  v4int_l r5, zero, r1    /* r5 = width */
-	  shrui r4, r0, 32        /* r4 = y */
+	  GET_FIRST_INT(r5, r1)   /* r5 = width */
+	  GET_SECOND_INT(r4, r0)  /* r4 = y */
 	}
 	{
-	  v4int_l r6, zero, r0    /* r6 = x */
+	  GET_FIRST_INT(r6, r0)   /* r6 = x */
 	  mul_lu_lu r4, r4, r5
 	}
 	{
-- 
1.8.3.1

