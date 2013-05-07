Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab3EGMoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:44:10 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:46106 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3EGMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:44:08 -0400
From: "Zhang Yi" <wetpzy@gmail.com>
To: "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, <zhang.yi20@zte.com.cn>,
        <wetpzy@163.com>
Subject: RE: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
Date: Tue, 7 May 2013 20:43:57 +0800
Message-ID: <000301ce4b20$8fc56c80$af504580$@com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac5LIIqUPGJOWhxXSdatu0nthJYApg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The futex-keys of processes share futex determined by page-offset,
mapping-host, and mapping-index of the user space address. User
appications using hugepage for futex may lead to futex-key conflict.

Assume there are two or more futexes in diffrent normal pages of the
hugepage, and each futex has the same offset in its normal page,
causing all the futexes have the same futex-key.


Steps to reproduce the bug:
1. The 1st thread map a file of hugetlbfs, and use the return address
as the 1st mutex's address, and use the return address with PAGE_SIZE
added as the 2nd mutex's address.
2. The 1st thread initialize the two mutexes with pshared attribute,
and lock the two mutexes.
3. The 1st thread create the 2nd thread, and the 2nd thread block on
the 1st mutex.
4. The 1st thread create the 3rd thread, and the 3rd thread block on
the 2nd mutex.
5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take
the 2nd mutex, and may block forever.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>


diff -uprN linux3.9-orig/include/linux/futex.h linux3.9/include/linux/futex.h
--- linux3.9-orig/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000
+++ linux3.9/include/linux/futex.h	2013-04-27 08:59:58.932078000 +0000
@@ -19,7 +19,7 @@ handle_futex_death(u32 __user *uaddr, st
  * The key type depends on whether it's a shared or private mapping.
  * Don't rearrange members without looking at hash_futex().
  *
- * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
+ * There are three cmponents in offset:
  * We use the two low order bits of offset to tell what is the kind of key :
  *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
  *       (no reference on an inode or mm)
@@ -27,6 +27,9 @@ handle_futex_death(u32 __user *uaddr, st
  *	mapped on a file (reference on the underlying inode)
  *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
  *       (but private mapping on an mm, and reference taken on it)
+ * Bits 2 to (PAGE_SHIFT-1) indicates the offset of futex in its page.
+ * The rest hign order bits indicates the index if the page is a
+ * subpage of a compound page.
 */

 #define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
@@ -36,17 +39,17 @@ union futex_key {
 	struct {
 		unsigned long pgoff;
 		struct inode *inode;
-		int offset;
+		unsigned long offset;
 	} shared;
 	struct {
 		unsigned long address;
 		struct mm_struct *mm;
-		int offset;
+		unsigned long offset;
 	} private;
 	struct {
 		unsigned long word;
 		void *ptr;
-		int offset;
+		unsigned long offset;
 	} both;
 };

diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
--- linux3.9-orig/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000
+++ linux3.9/kernel/futex.c	2013-05-06 16:24:40.403525000 +0000
@@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
 	}
 }

+/*
+* Get subpage index in compound page, and add it into futex_key.
+*/
+static void key_add_compound_idx(union futex_key *key,
+				 struct page *head_page, struct page *page)
+{
+	int compound_idx;
+
+	if (compound_order(head_page) >= MAX_ORDER)
+		compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
+	else
+		compound_idx = page - head_page;
+
+	key->both.offset |= compound_idx << PAGE_SHIFT;
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -228,7 +244,8 @@ static void drop_futex_key_refs(union fu
  * The key words are stored in *key on success.
  *
  * For shared mappings, it's (page->index, file_inode(vma->vm_file),
- * offset_within_page).  For private mappings, it's (uaddr, current->mm).
+ * page_compound_index and offset_within_page).
+ * For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
  * lock_page() might sleep, the caller should not hold a spinlock.
@@ -366,6 +383,8 @@ again:
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.inode = page_head->mapping->host;
 		key->shared.pgoff = page_head->index;
+		if (page != page_head)
+			key_add_compound_idx(key, page_head, page);
 	}

 	get_futex_key_refs(key);



