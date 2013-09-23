Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3IWI4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:56:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36237 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:56:29 -0400
Message-ID: <52400221.6040306@huawei.com>
Date: Mon, 23 Sep 2013 16:56:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH v6 2/5] memcg: convert to use cgroup id
References: <524001F8.6070205@huawei.com>
In-Reply-To: <524001F8.6070205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cgroup id instead of css id. This is a preparation to kill css id.

Note, as memcg treat 0 as an invalid id, while cgroup id starts with 0,
we define memcg_id == cgroup_id + 1.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9117249..6719e2c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -498,6 +498,23 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 	return (memcg == root_mem_cgroup);
 }
 
+static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+{
+	/*
+	 * The ID of the root cgroup is 0, but memcg treat 0 as an
+	 * invalid ID, so we return (cgroup_id + 1).
+	 */
+	return memcg->css.cgroup->id + 1;
+}
+
+static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+{
+	struct cgroup_subsys_state *css;
+
+	css = css_from_id(id - 1, &mem_cgroup_subsys);
+	return mem_cgroup_from_css(css);
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 
@@ -2850,15 +2867,10 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
  */
 static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
 {
-	struct cgroup_subsys_state *css;
-
 	/* ID 0 is unused ID */
 	if (!id)
 		return NULL;
-	css = css_lookup(&mem_cgroup_subsys, id);
-	if (!css)
-		return NULL;
-	return mem_cgroup_from_css(css);
+	return mem_cgroup_from_id(id);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
@@ -4368,7 +4380,7 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 	 * css_get() was called in uncharge().
 	 */
 	if (do_swap_account && swapout && memcg)
-		swap_cgroup_record(ent, css_id(&memcg->css));
+		swap_cgroup_record(ent, mem_cgroup_id(memcg));
 }
 #endif
 
@@ -4420,8 +4432,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 {
 	unsigned short old_id, new_id;
 
-	old_id = css_id(&from->css);
-	new_id = css_id(&to->css);
+	old_id = mem_cgroup_id(from);
+	new_id = mem_cgroup_id(to);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
@@ -6571,7 +6583,7 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 	}
 	/* There is a swap entry and a page doesn't exist or isn't charged */
 	if (ent.val && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup_id(ent)) {
+	    mem_cgroup_id(mc.from) == lookup_swap_cgroup_id(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
 			target->ent = ent;
-- 
1.8.0.2

