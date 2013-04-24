Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3DXOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:21:20 -0400
Received: from [220.181.13.134] ([220.181.13.134]:59923 "EHLO m13-134.163.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab3DXOVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:21:19 -0400
X-Greylist: delayed 1208 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 10:21:17 EDT
X-Originating-IP: [182.151.54.154]
Date: Wed, 24 Apr 2013 21:58:59 +0800 (CST)
From: "Zhang Yi" <wetpzy@163.com>
To: linux-kernel@vger.kernel.org
Cc: dvhart@linux.intel.com, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com,
        "zhang.yi20@zte.com.cn" <zhang.yi20@zte.com.cn>
Subject: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20130412(21945.5326.5325) Copyright (c) 2002-2013 www.mailtech.cn 163com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7ac104d6.211db.13e3c5710c9.Coremail.wetpzy@163.com>
X-CM-TRANSID: hsGowEA52EMj5XdRDdolAA--.1211W
X-CM-SenderInfo: hzhw16r16rljoofrz/1tbiFhsJSVEAC8mrdAABsA
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I reworked the patch base on your advices。
For the line-wrapped bug before, I use this mailbox to send the mail .


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>

diff -uprN orig/linux3.9-rc7/include/linux/futex.h new/linux3.9-rc7/include/linux/futex.h--- orig/linux3.9-rc7/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000+++ new/linux3.9-rc7/include/linux/futex.h	2013-04-19 16:33:58.725880000 +0000@@ -19,7 +19,7 @@ handle_futex_death(u32 __user *uaddr, st  * The key type depends on whether it's a shared or private mapping.  * Don't rearrange members without looking at hash_futex().  *- * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.+ * There are three cmponents in offset:  * We use the two low order bits of offset to tell what is the kind of key :  *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)  *       (no reference on an inode or mm)@@ -27,6 +27,9 @@ handle_futex_death(u32 __user *uaddr, st  *	mapped on a file (reference on the underlying inode)  *  10 : Shared futex (PTHREAD_PROCESS_SHARED)  *       (but private mapping on an mm, and reference taken on it)+ * Bits 2 to (PAGE_SHIFT-1) indicates the offset of futex in its page.+ * The rest hign order bits indicates the index if the page is a+ * subpage of a compound page. */  #define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */@@ -36,17 +39,17 @@ union futex_key { 	struct { 		unsigned long pgoff; 		struct inode *inode;-		int offset;+		long offset; 	} shared; 	struct { 		unsigned long address; 		struct mm_struct *mm;-		int offset;+		long offset; 	} private; 	struct { 		unsigned long word; 		void *ptr;-		int offset;+		long offset; 	} both; }; diff -uprN orig/linux3.9-rc7/kernel/futex.c new/linux3.9-rc7/kernel/futex.c--- orig/linux3.9-rc7/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000+++ new/linux3.9-rc7/kernel/futex.c	2013-04-19 16:24:05.629143000 +0000@@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu 	} } +/*+* Get subpage index in compound page, for futex_key.+*/+static inline int get_page_compound_index(struct page *page)+{+	struct page *head_page;+	if (PageHead(page))+		return 0;++	head_page = compound_head(page);+	if (compound_order(head_page) >= MAX_ORDER)+		return page_to_pfn(page) - page_to_pfn(head_page);+	else+		return page - compound_head(page);+}+ /**  * get_futex_key() - Get parameters which are the keys for a futex  * @uaddr:	virtual address of the futex@@ -228,7 +244,8 @@ static void drop_futex_key_refs(union fu  * The key words are stored in *key on success.  *  * For shared mappings, it's (page->index, file_inode(vma->vm_file),- * offset_within_page).  For private mappings, it's (uaddr, current->mm).+ * page_compound_index and offset_within_page).+ * For private mappings, it's (uaddr, current->mm).  * We can usually work out the index without swapping in the page.  *  * lock_page() might sleep, the caller should not hold a spinlock.@@ -239,7 +256,7 @@ get_futex_key(u32 __user *uaddr, int fsh 	unsigned long address = (unsigned long)uaddr; 	struct mm_struct *mm = current->mm; 	struct page *page, *page_head;-	int err, ro = 0;+	int err, ro = 0, comp_idx = 0;  	/* 	 * The futex address must be "naturally" aligned.@@ -299,6 +316,7 @@ again: 			 * freed from under us. 			 */ 			if (page != page_head) {+				comp_idx = get_page_compound_index(page); 				get_page(page_head); 				put_page(page); 			}@@ -311,6 +329,7 @@ again: #else 	page_head = compound_head(page); 	if (page != page_head) {+		comp_idx = get_page_compound_index(page); 		get_page(page_head); 		put_page(page); 	}@@ -363,7 +382,9 @@ again: 		key->private.mm = mm; 		key->private.address = address; 	} else {-		key->both.offset |= FUT_OFF_INODE; /* inode-based key */+		/* inode-based key */+		key->both.offset |= ((long)comp_idx << PAGE_SHIFT)+				   | FUT_OFF_INODE; 		key->shared.inode = page_head->mapping->host; 		key->shared.pgoff = page_head->index; 	}
