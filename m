Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab3FEV6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:58:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab3FEVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 052/127] mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge
Date: Wed,  5 Jun 2013 14:33:39 -0700
Message-Id: <20130605213223.918778105@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3991,8 +3991,6 @@ __mem_cgroup_uncharge_common(struct page
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	VM_BUG_ON(PageSwapCache(page));
-
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
@@ -4088,6 +4086,18 @@ void mem_cgroup_uncharge_page(struct pag
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


