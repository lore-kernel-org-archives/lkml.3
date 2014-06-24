Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaFXUcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:32:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaFXUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:32:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 40/65] mm/memory-failure.c: fix memory leak by race between poison and unpoison
Date: Tue, 24 Jun 2014 13:30:00 -0700
Message-Id: <1403641825-12825-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

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
[ kamal: backport to 3.8-stable: no renamed mce_bad_pages ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memory-failure.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 12b57b7..d3ed748 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1124,6 +1124,8 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
+		atomic_long_sub(nr_pages, &mce_bad_pages);
+		put_page(hpage);
 		res = 0;
 		goto out;
 	}
-- 
1.9.1

