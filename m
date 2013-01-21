Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3AUK43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:56:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3AUK42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:56:28 -0500
Date: Mon, 21 Jan 2013 11:56:24 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Zhouping Liu <zliu@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20130121105624.GF7798@dhcp22.suse.cz>
References: <4FEE7665.6020409@jp.fujitsu.com>
 <389106003.8637801.1358757547754.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <389106003.8637801.1358757547754.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-01-13 03:39:07, Zhouping Liu wrote:
> 
> 
> ----- Original Message -----
> > From: "Kamezawa Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
> > To: "Tejun Heo" <tj@kernel.org>
> > Cc: "David Rientjes" <rientjes@google.com>, "Michal Hocko" <mhocko@suse.cz>, "Zhouping Liu" <zliu@redhat.com>,
> > linux-mm@kvack.org, "Li Zefan" <lizefan@huawei.com>, "CAI Qian" <caiqian@redhat.com>, "LKML"
> > <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
> > Sent: Saturday, June 30, 2012 11:45:41 AM
> > Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
> > 
> > (2012/06/29 3:31), Tejun Heo wrote:
> > > Hello, KAME.
> > >
> > > On Thu, Jun 28, 2012 at 01:04:16PM +0900, Kamezawa Hiroyuki wrote:
> > >>> I still wish it's folded into CONFIG_MEMCG and conditionalized
> > >>> just on
> > >>> CONFIG_SWAP tho.
> > >>>
> > >>
> > >> In old days, memsw controller was not very stable. So, we devided
> > >> the config.
> > >> And, it makes size of memory for swap-device double (adds 2bytes
> > >> per swapent.)
> > >> That is the problem.
> > >
> > > I see.  Do you think it's now reasonable to drop the separate
> > > config
> > > option?  Having memcg enabled but swap unaccounted sounds
> > > half-broken
> > > to me.
> > >
> > 
> > Hmm. Maybe it's ok if we can keep boot option. I'll cook a patch in
> > the next week.
> 
> Hello Kame and All,
> 
> Sorry for so delay to open the thread. (please open the link https://lkml.org/lkml/2012/6/26/547 if you don't remember the topic)
> 
> do you have any updates for the issue?
> 
> I checked the latest version, if we don't open CONFIG_MEMCG_SWAP_ENABLED(commit c255a458055e changed
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED as CONFIG_MEMCG_SWAP_ENABLED), the issue still exist:
> 
> [root@dhcp-8-128 ~] cat .config  | grep -i memcg
> CONFIG_MEMCG=y
> CONFIG_MEMCG_SWAP=y
> # CONFIG_MEMCG_SWAP_ENABLED is not set
> CONFIG_MEMCG_KMEM=y
> [root@dhcp-8-128 ~] uname -r
> 3.8.0-rc4+
> [root@dhcp-8-128 ~] cat memory.memsw.*
> cat: memory.memsw.failcnt: Operation not supported
> cat: memory.memsw.limit_in_bytes: Operation not supported
> cat: memory.memsw.max_usage_in_bytes: Operation not supported
> cat: memory.memsw.usage_in_bytes: Operation not supported

Ohh, this one got lost. I thought Kame was working on that.
Anyway the patch bellow should work:
---
>From 5f8141bf7d27014cfbc7b450f13f6146b5ab099d Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 21 Jan 2013 11:33:26 +0100
Subject: [PATCH] memcg: Do not create memsw files if swap accounting is
 disabled

Zhouping Liu has reported that memsw files are exported even though
swap accounting is runtime disabled if CONFIG_MEMCG_SWAP is enabled.
This behavior has been introduced by af36f906 (memcg: always create
memsw files if CONFIG_CGROUP_MEM_RES_CTLR_SWAP) and it causes any
attempt to open the file to return EOPNOTSUPP. Although EOPNOTSUPP
should say be clear that memsw operations are not supported in the given
configuration it is fair to say that this behavior could be quite
confusing.

Let's tear memsw files out of default cgroup files and add
them only if the swap accounting is really enabled (either by
CONFIG_MEMCG_SWAP_ENABLED or swapaccount=1 boot parameter). We can
hook into mem_cgroup_init which is called when the memcg subsystem is
initialized and which happens after boot command line is processed.

Reported-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   94 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3817460..a2800db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5988,33 +5988,6 @@ static struct cftype mem_cgroup_files[] = {
 		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_MEMCG_SWAP
-	{
-		.name = "memsw.usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
-		.read = mem_cgroup_read,
-		.register_event = mem_cgroup_usage_register_event,
-		.unregister_event = mem_cgroup_usage_unregister_event,
-	},
-	{
-		.name = "memsw.max_usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
-		.read = mem_cgroup_read,
-	},
-	{
-		.name = "memsw.limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
-		.write_string = mem_cgroup_write,
-		.read = mem_cgroup_read,
-	},
-	{
-		.name = "memsw.failcnt",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
-		.read = mem_cgroup_read,
-	},
-#endif
 #ifdef CONFIG_MEMCG_KMEM
 	{
 		.name = "kmem.limit_in_bytes",
@@ -6057,6 +6030,36 @@ static struct cftype mem_cgroup_files[] = {
 	{ },	/* terminate */
 };
 
+#ifdef CONFIG_MEMCG_SWAP
+static struct cftype memsw_cgroup_files[] = {
+	{
+		.name = "memsw.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
+		.read = mem_cgroup_read,
+		.register_event = mem_cgroup_usage_register_event,
+		.unregister_event = mem_cgroup_usage_unregister_event,
+	},
+	{
+		.name = "memsw.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.failcnt",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+	{ },	/* terminate */
+};
+#endif
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -6959,19 +6962,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.use_id = 1,
 };
 
-/*
- * The rest of init is performed during ->css_alloc() for root css which
- * happens before initcalls.  hotcpu_notifier() can't be done together as
- * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
- * dependency.  Do it from a subsys_initcall().
- */
-static int __init mem_cgroup_init(void)
-{
-	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
-	return 0;
-}
-subsys_initcall(mem_cgroup_init);
-
 #ifdef CONFIG_MEMCG_SWAP
 static int __init enable_swap_account(char *s)
 {
@@ -6984,4 +6974,28 @@ static int __init enable_swap_account(char *s)
 }
 __setup("swapaccount=", enable_swap_account);
 
+static void __init memsw_file_init(void)
+{
+	if (really_do_swap_account)
+		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
+					memsw_cgroup_files));
+}
+#else
+static void __init memsw_file_init(void)
+{
+}
 #endif
+
+/*
+ * The rest of init is performed during ->css_alloc() for root css which
+ * happens before initcalls.  hotcpu_notifier() can't be done together as
+ * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
+ * dependency.  Do it from a subsys_initcall().
+ */
+static int __init mem_cgroup_init(void)
+{
+	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
+	memsw_file_init();
+	return 0;
+}
+subsys_initcall(mem_cgroup_init);
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
