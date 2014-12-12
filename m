Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965878AbaLLTMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:23464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771AbaLLTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="636810383"
Subject: [RFC][PATCH 7/8] x86, mpx: do 32-bit-only cmpxchg for 32-bit apps
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:22 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191222.FFAA67EB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

user_atomic_cmpxchg_inatomic() actually looks at sizeof(*ptr) to
figure out how many bytes to copy.  If we run it on a 64-bit
kernel with a 64-bit pointer, it will copy a 64-bit bounds
directory entry.  That's fine, except when we have 32-bit
programs with 32-bit bounds directory entries and we only *want*
32-bits.

This patch breaks the cmpxchg operation out in to its own
function and performs the 32-bit type swizzling in there.

Note, the "64-bit" version of this code _would_ work on a
32-bit-only kernel.  The issue this patch addresses is only for
when the kernel's 'long' is mismatched from the size of the
bounds directory entry of the process we are working on.

The new helper modifies 'actual_old_val' or returns an error.
But gcc doesn't know this, so it warns about 'actual_old_val'
being unused.  Shut it up with an uninitialized_var().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/mm/mpx.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/mpx.c~mpx-variable-sized-userspace-pokes arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mpx-variable-sized-userspace-pokes	2014-12-12 11:11:41.385051197 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-12 11:11:41.388051332 -0800
@@ -411,6 +411,35 @@ int mpx_disable_management(struct task_s
 	return 0;
 }
 
+static int mpx_cmpxchg_bd_entry(struct mm_struct *mm,
+		unsigned long *actual_old_val_ptr, long __user *bd_entry_addr,
+		unsigned long expected_old_val, unsigned long new_bd_entry)
+{
+	int ret;
+	/*
+	 * user_atomic_cmpxchg_inatomic() actually uses sizeof()
+	 * the pointer thatt we pass to it to figure out how much
+	 * data to cmpxchg.  We have to be careful here not to
+	 * pass a pointer to a 64-bit data type when we only want
+	 * a 32-bit copy.
+	 */
+	if (is_64bit_mm(mm)) {
+		ret = user_atomic_cmpxchg_inatomic(actual_old_val_ptr,
+				bd_entry_addr, expected_old_val, new_bd_entry);
+	} else {
+		u32 uninitialized_var(actual_old_val_32);
+		u32 expected_old_val_32 = expected_old_val;
+		u32 new_bd_entry_32 = new_bd_entry;
+		u32 __user *bd_entry_32 = (u32 __user *)bd_entry_addr;
+		ret = user_atomic_cmpxchg_inatomic(&actual_old_val_32,
+				bd_entry_32, expected_old_val_32,
+				new_bd_entry_32);
+		if (!ret)
+			*actual_old_val_ptr = actual_old_val_32;
+	}
+	return ret;
+}
+
 /*
  * With 32-bit mode, MPX_BT_SIZE_BYTES is 4MB, and the size of each
  * bounds table is 16KB. With 64-bit mode, MPX_BT_SIZE_BYTES is 2GB,
@@ -418,6 +447,7 @@ int mpx_disable_management(struct task_s
  */
 static int allocate_bt(long __user *bd_entry)
 {
+	struct mm_struct *mm = current->mm;
 	unsigned long expected_old_val = 0;
 	unsigned long actual_old_val = 0;
 	unsigned long bt_addr;
@@ -447,8 +477,8 @@ static int allocate_bt(long __user *bd_e
 	 * mmap_sem at this point, unlike some of the other part
 	 * of the MPX code that have to pagefault_disable().
 	 */
-	ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
-					   expected_old_val, bd_new_entry);
+	ret = mpx_cmpxchg_bd_entry(mm, &actual_old_val,	bd_entry,
+				   expected_old_val, bd_new_entry);
 	if (ret)
 		goto out_unmap;
 
@@ -700,15 +730,16 @@ static int unmap_single_bt(struct mm_str
 		long __user *bd_entry, unsigned long bt_addr)
 {
 	unsigned long expected_old_val = bt_addr | MPX_BD_ENTRY_VALID_FLAG;
-	unsigned long actual_old_val = 0;
+	unsigned long uninitialized_var(actual_old_val);
 	int ret;
 
 	while (1) {
 		int need_write = 1;
+		unsigned long cleared_bd_entry = 0;
 
 		pagefault_disable();
-		ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
-						   expected_old_val, 0);
+		ret = mpx_cmpxchg_bd_entry(mm, &actual_old_val,
+				bd_entry, bt_addr, cleared_bd_entry);
 		pagefault_enable();
 		if (!ret)
 			break;
_
