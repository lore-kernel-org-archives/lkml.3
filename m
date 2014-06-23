Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaFWIjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:39:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55613 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/111] mm/memory-failure.c: fix memory leak by race between poison and unpoison
Date: Mon, 23 Jun 2014 10:30:55 +0200
Message-Id: <191df2f25cf91a4e3adeb3e230d3323e7f1b6606.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3e030ecc0fc7de10fd0da10c1c19939872a31717 upstream.

When a memory error happens on an in-use page or (free and in-use)
hugepage, the victim page is isolated with its refcount set to one.

When you try to unpoison it later, unpoison_memory() calls put_page()
for it twice in order to bring the page back to free page pool (buddy or
free hugepage list).  However, if another memory error occurs on the
page which we are unpoisoning, memory_failure() returns without
releasing the refcount which was incremented in the same call at first,
which results in memory leak and unconsistent num_poisoned_pages
statistics.  This patch fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/memory-failure.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 9f1b0ff6cb65..ecfbfe520342 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1157,6 +1157,8 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
+		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		put_page(hpage);
 		res = 0;
 		goto out;
 	}
-- 
2.0.0

