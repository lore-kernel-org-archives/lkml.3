Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaIZKCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:02:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaIZJqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/142] powerpc/pseries: Avoid deadlock on removing ddw
Date: Fri, 26 Sep 2014 11:44:22 +0200
Message-Id: <6c4e48e6c27362946f36151350f26ca0e6be8437.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5efbabe09d986f25c02d19954660238fcd7f008a upstream.

Function remove_ddw() could be called in of_reconfig_notifier and
we potentially remove the dynamic DMA window property, which invokes
of_reconfig_notifier again. Eventually, it leads to the deadlock as
following backtrace shows.

The patch fixes the above issue by deferring releasing the dynamic
DMA window property while releasing the device node.

=============================================
[ INFO: possible recursive locking detected ]
3.16.0+ #428 Tainted: G        W
---------------------------------------------
drmgr/2273 is trying to acquire lock:
 ((of_reconfig_chain).rwsem){.+.+..}, at: [<c000000000091890>] \
 .__blocking_notifier_call_chain+0x40/0x78

but task is already holding lock:
 ((of_reconfig_chain).rwsem){.+.+..}, at: [<c000000000091890>] \
 .__blocking_notifier_call_chain+0x40/0x78

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((of_reconfig_chain).rwsem);
  lock((of_reconfig_chain).rwsem);
 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by drmgr/2273:
 #0:  (sb_writers#4){.+.+.+}, at: [<c0000000001cbe70>] \
      .vfs_write+0xb0/0x1f8
 #1:  ((of_reconfig_chain).rwsem){.+.+..}, at: [<c000000000091890>] \
      .__blocking_notifier_call_chain+0x40/0x78

stack backtrace:
CPU: 17 PID: 2273 Comm: drmgr Tainted: G        W     3.16.0+ #428
Call Trace:
[c0000000137e7000] [c000000000013d9c] .show_stack+0x88/0x148 (unreliable)
[c0000000137e70b0] [c00000000083cd34] .dump_stack+0x7c/0x9c
[c0000000137e7130] [c0000000000b8afc] .__lock_acquire+0x128c/0x1c68
[c0000000137e7280] [c0000000000b9a4c] .lock_acquire+0xe8/0x104
[c0000000137e7350] [c00000000083588c] .down_read+0x4c/0x90
[c0000000137e73e0] [c000000000091890] .__blocking_notifier_call_chain+0x40/0x78
[c0000000137e7490] [c000000000091900] .blocking_notifier_call_chain+0x38/0x48
[c0000000137e7520] [c000000000682a28] .of_reconfig_notify+0x34/0x5c
[c0000000137e75b0] [c000000000682a9c] .of_property_notify+0x4c/0x54
[c0000000137e7650] [c000000000682bf0] .of_remove_property+0x30/0xd4
[c0000000137e76f0] [c000000000052a44] .remove_ddw+0x144/0x168
[c0000000137e7790] [c000000000053204] .iommu_reconfig_notifier+0x30/0xe0
[c0000000137e7820] [c00000000009137c] .notifier_call_chain+0x6c/0xb4
[c0000000137e78c0] [c0000000000918ac] .__blocking_notifier_call_chain+0x5c/0x78
[c0000000137e7970] [c000000000091900] .blocking_notifier_call_chain+0x38/0x48
[c0000000137e7a00] [c000000000682a28] .of_reconfig_notify+0x34/0x5c
[c0000000137e7a90] [c000000000682e14] .of_detach_node+0x44/0x1fc
[c0000000137e7b40] [c0000000000518e4] .ofdt_write+0x3ac/0x688
[c0000000137e7c20] [c000000000238430] .proc_reg_write+0xb8/0xd4
[c0000000137e7cd0] [c0000000001cbeac] .vfs_write+0xec/0x1f8
[c0000000137e7d70] [c0000000001cc3b0] .SyS_write+0x58/0xa0
[c0000000137e7e30] [c00000000000a064] syscall_exit+0x0/0x98

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/pseries/iommu.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 0307901e4132..261c5095d5d3 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -731,13 +731,13 @@ static inline void __remove_ddw(struct device_node *np, const u32 *ddw_avail, u6
 			np->full_name, ret, ddw_avail[2], liobn);
 }
 
-static void remove_ddw(struct device_node *np)
+static void remove_ddw(struct device_node *np, bool remove_prop)
 {
 	struct dynamic_dma_window_prop *dwp;
 	struct property *win64;
 	const u32 *ddw_avail;
 	u64 liobn;
-	int len, ret;
+	int len, ret = 0;
 
 	ddw_avail = of_get_property(np, "ibm,ddw-applicable", &len);
 	win64 = of_find_property(np, DIRECT64_PROPNAME, NULL);
@@ -763,7 +763,8 @@ static void remove_ddw(struct device_node *np)
 	__remove_ddw(np, ddw_avail, liobn);
 
 delprop:
-	ret = of_remove_property(np, win64);
+	if (remove_prop)
+		ret = of_remove_property(np, win64);
 	if (ret)
 		pr_warning("%s: failed to remove direct window property: %d\n",
 			np->full_name, ret);
@@ -835,7 +836,7 @@ static int find_existing_ddw_windows(void)
 		 * can clear the table or find the holes. To that end,
 		 * first, remove any existing DDW configuration.
 		 */
-		remove_ddw(pdn);
+		remove_ddw(pdn, true);
 
 		/*
 		 * Second, if we are running on a new enough level of
@@ -1125,7 +1126,7 @@ out_free_window:
 	kfree(window);
 
 out_clear_window:
-	remove_ddw(pdn);
+	remove_ddw(pdn, true);
 
 out_free_prop:
 	kfree(win64->name);
@@ -1337,7 +1338,14 @@ static int iommu_reconfig_notifier(struct notifier_block *nb, unsigned long acti
 
 	switch (action) {
 	case OF_RECONFIG_DETACH_NODE:
-		remove_ddw(np);
+		/*
+		 * Removing the property will invoke the reconfig
+		 * notifier again, which causes dead-lock on the
+		 * read-write semaphore of the notifier chain. So
+		 * we have to remove the property when releasing
+		 * the device node.
+		 */
+		remove_ddw(np, false);
 		if (pci && pci->iommu_table)
 			iommu_free_table(pci->iommu_table, np->full_name);
 
-- 
2.1.0

