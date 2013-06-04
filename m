Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3FDRDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab3FDRDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 48/75] mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge
Date: Tue,  4 Jun 2013 09:55:32 -0700
Message-Id: <1370364959-9475-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 28ccddf7952c496df2a51ce5aee4f2a058a98bab upstream.

Commit 0c59b89c81ea ("mm: memcg: push down PageSwapCache check into
uncharge entry functions") added a VM_BUG_ON() on PageSwapCache in the
uncharge path after checking that page flag once, assuming that the
state is stable in all paths, but this is not the case and the condition
triggers in user environments.  An uncharge after the last page table
reference to the page goes away can race with reclaim adding the page to
swap cache.

Swap cache pages are usually uncharged when they are freed after
swapout, from a path that also handles swap usage accounting and memcg
lifetime management.  However, since the last page table reference is
gone and thus no references to the swap slot left, the swap slot will be
freed shortly when reclaim attempts to write the page to disk.  The
whole swap accounting is not even necessary.

So while the race condition for which this VM_BUG_ON was added is real
and actually existed all along, there are no negative effects.  Remove
the VM_BUG_ON again.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fbb60b1..fd7c0d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3936,8 +3936,6 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	VM_BUG_ON(PageSwapCache(page));
-
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
@@ -4033,6 +4031,18 @@ void mem_cgroup_uncharge_page(struct page *page)
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	/*
+	 * If the page is in swap cache, uncharge should be deferred
+	 * to the swap path, which also properly accounts swap usage
+	 * and handles memcg lifetime.
+	 *
+	 * Note that this check is not stable and reclaim may add the
+	 * page to swap cache at any time after this.  However, if the
+	 * page is not in swap cache by the time page->mapcount hits
+	 * 0, there won't be any page table references to the swap
+	 * slot, and reclaim will free it and not actually write the
+	 * page to disk.
+	 */
 	if (PageSwapCache(page))
 		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
-- 
1.8.1.2

