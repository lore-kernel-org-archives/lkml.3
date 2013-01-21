Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3AULMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:12:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab3AULMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:12:10 -0500
Date: Mon, 21 Jan 2013 12:12:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Zhouping Liu <zliu@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20130121111206.GG7798@dhcp22.suse.cz>
References: <4FEE7665.6020409@jp.fujitsu.com>
 <389106003.8637801.1358757547754.JavaMail.root@redhat.com>
 <20130121105624.GF7798@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121105624.GF7798@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And we can put another clean up patch on top of the fix:
---
>From a81d36002e7dbd976b617d5eadf32265f36038a4 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 21 Jan 2013 12:05:29 +0100
Subject: [PATCH] memcg: clean up swap accounting initialization code

Memcg swap accounting is currently enabled by enable_swap_cgroup when
the root cgroup is created. mem_cgroup_init acts as a memcg subsystem
initializer which sounds like a much better place for enable_swap_cgroup
as well. We already register memsw files from there so it makes a lot of
sense to merge those two into a single enable_swap_cgroup function.

This patch doesn't introduce any semantical changes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2800db..878d62c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6221,18 +6221,6 @@ struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-#ifdef CONFIG_MEMCG_SWAP
-static void __init enable_swap_cgroup(void)
-{
-	if (!mem_cgroup_disabled() && really_do_swap_account)
-		do_swap_account = 1;
-}
-#else
-static void __init enable_swap_cgroup(void)
-{
-}
-#endif
-
 static int mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
@@ -6286,7 +6274,6 @@ mem_cgroup_css_alloc(struct cgroup *cont)
 	/* root ? */
 	if (cont->parent == NULL) {
 		int cpu;
-		enable_swap_cgroup();
 		parent = NULL;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
@@ -6976,12 +6963,19 @@ __setup("swapaccount=", enable_swap_account);
 
 static void __init memsw_file_init(void)
 {
-	if (really_do_swap_account)
-		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
-					memsw_cgroup_files));
+	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, memsw_cgroup_files));
+}
+
+static void __init enable_swap_cgroup(void)
+{
+	if (!mem_cgroup_disabled() && really_do_swap_account) {
+		do_swap_account = 1;
+		memsw_file_init();
+	}
 }
+
 #else
-static void __init memsw_file_init(void)
+static void __init enable_swap_cgroup(void)
 {
 }
 #endif
@@ -6995,7 +6989,7 @@ static void __init memsw_file_init(void)
 static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
-	memsw_file_init();
+	enable_swap_cgroup();
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
