Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965991AbaLLTMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:11727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965713AbaLLTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="428315362"
Subject: [RFC][PATCH 5/8] x86, mpx: Add temporary variable to reduce masking
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:20 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191220.B8944E5D@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

When we allocate a bounds table, we call mmap(), then add a
"valid" bit to the value before storing it in to the bounds
directory.

If we fail along the way, we go and mask that valid bit
_back_ out.  That seems a little silly, and this makes it
much more clear when we have a plain address versus an
actual table _entry_.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/mm/mpx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/mpx.c~mpx-remove-unnecessary-masking arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mpx-remove-unnecessary-masking	2014-12-12 11:11:40.599015745 -0800
+++ b/arch/x86/mm/mpx.c	2014-12-12 11:11:40.602015880 -0800
@@ -421,6 +421,7 @@ static int allocate_bt(long __user *bd_e
 	unsigned long expected_old_val = 0;
 	unsigned long actual_old_val = 0;
 	unsigned long bt_addr;
+	unsigned long bd_new_entry;
 	int ret = 0;
 
 	/*
@@ -433,7 +434,7 @@ static int allocate_bt(long __user *bd_e
 	/*
 	 * Set the valid flag (kinda like _PAGE_PRESENT in a pte)
 	 */
-	bt_addr = bt_addr | MPX_BD_ENTRY_VALID_FLAG;
+	bd_new_entry = bt_addr | MPX_BD_ENTRY_VALID_FLAG;
 
 	/*
 	 * Go poke the address of the new bounds table in to the
@@ -447,7 +448,7 @@ static int allocate_bt(long __user *bd_e
 	 * of the MPX code that have to pagefault_disable().
 	 */
 	ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
-					   expected_old_val, bt_addr);
+					   expected_old_val, bd_new_entry);
 	if (ret)
 		goto out_unmap;
 
@@ -477,7 +478,7 @@ static int allocate_bt(long __user *bd_e
 	}
 	return 0;
 out_unmap:
-	vm_munmap(bt_addr & MPX_BT_ADDR_MASK, MPX_BT_SIZE_BYTES);
+	vm_munmap(bt_addr, MPX_BT_SIZE_BYTES);
 	return ret;
 }
 
_
