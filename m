Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3DXPcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:32:41 -0400
Received: from mail-pd0-f196.google.com ([209.85.192.196]:64537 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab3DXPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:32:40 -0400
From: "Zhang Yi" <wetpzy@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, <zhang.yi20@zte.com.cn>
Subject: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
Date: Wed, 24 Apr 2013 22:27:32 +0800
Message-ID: <000a01ce40f7$e9f4d700$bdde8500$@com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac5A99vA6WtbTvkoRKihXEqksCc9tg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I reworked the patch base on your advices.
For the line-wrapped bug before, I use this mailbox to send the mail .



Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>


diff -uprN orig/linux3.9-rc7/include/linux/futex.h new/linux3.9-rc7/include/linux/futex.h
--- orig/linux3.9-rc7/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000
+++ new/linux3.9-rc7/include/linux/futex.h	2013-04-19 16:33:58.725880000 +0000
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
+		long offset;
 	} shared;
 	struct {
 		unsigned long address;
 		struct mm_struct *mm;
-		int offset;
+		long offset;
 	} private;
 	struct {
 		unsigned long word;
 		void *ptr;
-		int offset;
+		long offset;
 	} both;
 };

diff -uprN orig/linux3.9-rc7/kernel/futex.c new/linux3.9-rc7/kernel/futex.c
--- orig/linux3.9-rc7/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000
+++ new/linux3.9-rc7/kernel/futex.c	2013-04-19 16:24:05.629143000 +0000
@@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
 	}
 }

+/*
+* Get subpage index in compound page, for futex_key.
+*/
+static inline int get_page_compound_index(struct page *page)
+{
+	struct page *head_page;
+	if (PageHead(page))
+		return 0;
+
+	head_page = compound_head(page);
+	if (compound_order(head_page) >= MAX_ORDER)
+		return page_to_pfn(page) - page_to_pfn(head_page);
+	else
+		return page - compound_head(page);
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
@@ -239,7 +256,7 @@ get_futex_key(u32 __user *uaddr, int fsh
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
-	int err, ro = 0;
+	int err, ro = 0, comp_idx = 0;

 	/*
 	 * The futex address must be "naturally" aligned.
@@ -299,6 +316,7 @@ again:
 			 * freed from under us.
 			 */
 			if (page != page_head) {
+				comp_idx = get_page_compound_index(page);
 				get_page(page_head);
 				put_page(page);
 			}
@@ -311,6 +329,7 @@ again:
 #else
 	page_head = compound_head(page);
 	if (page != page_head) {
+		comp_idx = get_page_compound_index(page);
 		get_page(page_head);
 		put_page(page);
 	}
@@ -363,7 +382,9 @@ again:
 		key->private.mm = mm;
 		key->private.address = address;
 	} else {
-		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
+		/* inode-based key */
+		key->both.offset |= ((long)comp_idx << PAGE_SHIFT)
+				   | FUT_OFF_INODE;
 		key->shared.inode = page_head->mapping->host;
 		key->shared.pgoff = page_head->index;
 	}


