Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaESSmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaESSmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:42:36 -0400
Date: Mon, 19 May 2014 20:41:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Teach copy_insn() to support tmpfs
Message-ID: <20140519184136.GB6750@redhat.com>
References: <20140519184054.GA6750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519184054.GA6750@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmpfs is widely used but as Denys reports shmem_aops doesn't have
->readpage() and thus you can't probe a binary on this filesystem.

As Hugh suggested we can use shmem_read_mapping_page() in this case,
just we need to check shmem_mapping() if ->readpage == NULL.

Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c56b13e..6bfb671 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -36,6 +36,7 @@
 #include "../../mm/internal.h"	/* munlock_vma_page */
 #include <linux/percpu-rwsem.h>
 #include <linux/task_work.h>
+#include <linux/shmem_fs.h>
 
 #include <linux/uprobes.h>
 
@@ -537,10 +538,14 @@ static int __copy_insn(struct address_space *mapping, struct file *filp,
 {
 	struct page *page;
 	/*
-	 * Ensure that the page that has the original instruction is
-	 * populated and in page-cache.
+	 * Ensure that the page that has the original instruction is populated
+	 * and in page-cache. If ->readpage == NULL it must be shmem_mapping(),
+	 * see uprobe_register().
 	 */
-	page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
+	if (mapping->a_ops->readpage)
+		page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
+	else
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
@@ -876,8 +881,8 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->ret_handler)
 		return -EINVAL;
 
-	/* copy_insn()->read_mapping_page() needs ->readpage() */
-	if (!inode->i_mapping->a_ops->readpage)
+	/* copy_insn() uses read_mapping_page() or shmem_read_mapping_page() */
+	if (!inode->i_mapping->a_ops->readpage && !shmem_mapping(inode->i_mapping))
 		return -EIO;
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
-- 
1.5.5.1


