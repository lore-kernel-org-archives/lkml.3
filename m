Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaFEOkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:40:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaFEOkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:40:05 -0400
Date: Thu, 5 Jun 2014 07:39:11 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-40814f6805a524130a5ec313871147f7aa9b5318@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        hughd@google.com, dvlasenk@redhat.com, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        acme@kernel.org, srikar@linux.vnet.ibm.com, dvlasenk@redhat.com,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140519184136.GB6750@redhat.com>
References: <20140519184136.GB6750@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Teach copy_insn() to support tmpfs
Git-Commit-ID: 40814f6805a524130a5ec313871147f7aa9b5318
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40814f6805a524130a5ec313871147f7aa9b5318
Gitweb:     http://git.kernel.org/tip/40814f6805a524130a5ec313871147f7aa9b5318
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 19 May 2014 20:41:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:11 +0200

uprobes: Teach copy_insn() to support tmpfs

tmpfs is widely used but as Denys reports shmem_aops doesn't have
->readpage() and thus you can't probe a binary on this filesystem.

As Hugh suggested we can use shmem_read_mapping_page() in this case,
just we need to check shmem_mapping() if ->readpage == NULL.

Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140519184136.GB6750@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

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
