Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaJVSaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:30:20 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42665 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbaJVS3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:29:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: page-writeback: inline account_page_dirtied() into single caller
Date: Wed, 22 Oct 2014 14:29:27 -0400
Message-Id: <1414002568-21042-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A follow-up patch would have changed the call signature.  To save the
trouble, just fold it instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "3.17" <stable@kernel.org>
---
 include/linux/mm.h  |  1 -
 mm/page-writeback.c | 23 ++++-------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27eb1bfbe704..b46461116cd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1235,7 +1235,6 @@ int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
-void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ff24c9d83112..ff6a5b07211e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2116,23 +2116,6 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
- * Helper function for set_page_writeback family.
- *
- * The caller must hold mem_cgroup_begin/end_update_page_stat() lock
- * while calling this function.
- * See test_set_page_writeback for example.
- *
- * NOTE: Unlike account_page_dirtied this does not rely on being atomic
- * wrt interrupts.
- */
-void account_page_writeback(struct page *page)
-{
-	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
-	inc_zone_page_state(page, NR_WRITEBACK);
-}
-EXPORT_SYMBOL(account_page_writeback);
-
-/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -2410,8 +2393,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
-	if (!ret)
-		account_page_writeback(page);
+	if (!ret) {
+		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		inc_zone_page_state(page, NR_WRITEBACK);
+	}
 	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
 	return ret;
 
-- 
2.1.2

