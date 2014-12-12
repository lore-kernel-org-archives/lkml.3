Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbaLLTMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:53374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934931AbaLLTMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497949475"
Subject: [RFC][PATCH 6/8] x86, mpx: new directory entry to addr helper
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:21 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191221.6BB20D20@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Currently, to get from a bounds directory entry to the virtual
address of a bounds table, we simply mask off a few low bits.
However, the set of bits we mask off is different for 32 and
64-bit binaries.

This breaks the operation out in to a helper function and also
adds a temporary variable to store the result until we are
sure we are returning one.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/mpx.h |    1 -
 b/arch/x86/mm/mpx.c          |   41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 8 deletions(-)

diff -puN arch/x86/include/asm/mpx.h~mpx-new-entry-to-addr-helper arch/x86/include/asm/mpx.h
--- a/arch/x86/include/asm/mpx.h~mpx-new-entry-to-addr-helper	2014-12-12 11:11:40.986033200 -0800
+++ b/arch/x86/include/asm/mpx.h	2014-12-12 11:11:40.991033426 -0800
@@ -45,7 +45,6 @@
 #define MPX_BNDSTA_TAIL		2
 #define MPX_BNDCFG_TAIL		12
 #define MPX_BNDSTA_ADDR_MASK	(~((1UL<<MPX_BNDSTA_TAIL)-1))
-#define MPX_BT_ADDR_MASK	(~((1UL<<MPX_BD_ENTRY_TAIL)-1))
 
 #define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
 #define MPX_BNDSTA_ERROR_CODE	0x3
diff -puN arch/x86/mm/mpx.c~mpx-new-entry-to-addr-helper arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mpx-new-entry-to-addr-helper	2014-12-12 11:11:40.988033290 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-12 11:11:40.992033471 -0800
@@ -567,29 +567,55 @@ static int mpx_resolve_fault(long __user
 	return 0;
 }
 
+static unsigned long mpx_bd_entry_to_bt_addr(struct mm_struct *mm,
+		unsigned long bd_entry)
+{
+	unsigned long bt_addr = bd_entry;
+	int align_to_bytes;
+	/*
+	 * Bit 0 in a bt_entry is always the valid bit.
+	 */
+	bt_addr &= ~MPX_BD_ENTRY_VALID_FLAG;
+	/*
+	 * Tables are naturally aligned at 8-byte boundaries
+	 * on 64-bit and 4-byte boundaries on 32-bit.  The
+	 * documentation makes it appear that the low bits
+	 * are ignored by the hardware, so we do the same.
+	 */
+	if (is_64bit_mm(mm))
+		align_to_bytes = 8;
+	else
+		align_to_bytes = 4;
+	bt_addr &= ~(align_to_bytes-1);
+	return bt_addr;
+}
+
 /*
  * Get the base of bounds tables pointed by specific bounds
  * directory entry.
  */
 static int get_bt_addr(struct mm_struct *mm,
-			long __user *bd_entry, unsigned long *bt_addr)
+			long __user *bd_entry_ptr,
+			unsigned long *bt_addr_result)
 {
 	int ret;
 	int valid_bit;
+	unsigned long bd_entry;
+	unsigned long bt_addr;
 
-	if (!access_ok(VERIFY_READ, (bd_entry), sizeof(*bd_entry)))
+	if (!access_ok(VERIFY_READ, (bd_entry_ptr), sizeof(*bd_entry_ptr)))
 		return -EFAULT;
 
 	while (1) {
 		int need_write = 0;
 
 		pagefault_disable();
-		ret = get_user(*bt_addr, bd_entry);
+		ret = get_user(bd_entry, bd_entry_ptr);
 		pagefault_enable();
 		if (!ret)
 			break;
 		if (ret == -EFAULT)
-			ret = mpx_resolve_fault(bd_entry, need_write);
+			ret = mpx_resolve_fault(bd_entry_ptr, need_write);
 		/*
 		 * If we could not resolve the fault, consider it
 		 * userspace's fault and error out.
@@ -598,8 +624,8 @@ static int get_bt_addr(struct mm_struct
 			return ret;
 	}
 
-	valid_bit = *bt_addr & MPX_BD_ENTRY_VALID_FLAG;
-	*bt_addr &= MPX_BT_ADDR_MASK;
+	valid_bit = bd_entry & MPX_BD_ENTRY_VALID_FLAG;
+	bt_addr = mpx_bd_entry_to_bt_addr(mm, bd_entry);
 
 	/*
 	 * When the kernel is managing bounds tables, a bounds directory
@@ -608,7 +634,7 @@ static int get_bt_addr(struct mm_struct
 	 * data in the address field, we know something is wrong. This
 	 * -EINVAL return will cause a SIGSEGV.
 	 */
-	if (!valid_bit && *bt_addr)
+	if (!valid_bit && bt_addr)
 		return -EINVAL;
 	/*
 	 * Do we have an completely zeroed bt entry?  That is OK.  It
@@ -619,6 +645,7 @@ static int get_bt_addr(struct mm_struct
 	if (!valid_bit)
 		return -ENOENT;
 
+	*bt_addr_result = bt_addr;
 	return 0;
 }
 
_
