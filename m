Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3GCSyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:54:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3GCSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:56 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=7I8dHhyUxckA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kbDewj_maSEA:10 a=ufHFDILaAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=DiArgG5M_sMAB-upweoA:9 a=l7ZknGph1ugA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=nQfWUNNfRg8TnU3F:21 a=JYFdXw-Kgd-3O0i-:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184049.426738235@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [029/141] mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in
 uncharge
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0029-mm-memcg-remove-incorrect-VM_BUG_ON-for-swap-cache-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 28ccddf7952c496df2a51ce5aee4f2a058a98bab ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/memcontrol.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a6e2f81..a2c673a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3030,8 +3030,6 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	VM_BUG_ON(PageSwapCache(page));
-
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
@@ -3127,6 +3125,18 @@ void mem_cgroup_uncharge_page(struct page *page)
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
1.7.10.4


