Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaIZKCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:02:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaIZJqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/142] powerpc/pseries: Failure on removing device node
Date: Fri, 26 Sep 2014 11:44:21 +0200
Message-Id: <1eae3e47d2aa45ab90ea035ed7135d813e2309e4.1411724724.git.jslaby@suse.cz>
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

commit f1b3929c232784580e5d8ee324b6bc634e709575 upstream.

While running command "drmgr -c phb -r -s 'PHB 528'", following
backtrace jumped out because the target device node isn't marked
with OF_DETACHED by of_detach_node(), which caused by error
returned from memory hotplug related reconfig notifier when
disabling CONFIG_MEMORY_HOTREMOVE. The patch fixes it.

ERROR: Bad of_node_put() on /pci@800000020000210/ethernet@0
CPU: 14 PID: 2252 Comm: drmgr Tainted: G        W     3.16.0+ #427
Call Trace:
[c000000012a776a0] [c000000000013d9c] .show_stack+0x88/0x148 (unreliable)
[c000000012a77750] [c00000000083cd34] .dump_stack+0x7c/0x9c
[c000000012a777d0] [c0000000006807c4] .of_node_release+0x58/0xe0
[c000000012a77860] [c00000000038a7d0] .kobject_release+0x174/0x1b8
[c000000012a77900] [c00000000038a884] .kobject_put+0x70/0x78
[c000000012a77980] [c000000000681680] .of_node_put+0x28/0x34
[c000000012a77a00] [c000000000681ea8] .__of_get_next_child+0x64/0x70
[c000000012a77a90] [c000000000682138] .of_find_node_by_path+0x1b8/0x20c
[c000000012a77b40] [c000000000051840] .ofdt_write+0x308/0x688
[c000000012a77c20] [c000000000238430] .proc_reg_write+0xb8/0xd4
[c000000012a77cd0] [c0000000001cbeac] .vfs_write+0xec/0x1f8
[c000000012a77d70] [c0000000001cc3b0] .SyS_write+0x58/0xa0
[c000000012a77e30] [c00000000000a064] syscall_exit+0x0/0x98

Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 9a432de363b8..bebe64ed5dc3 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -158,7 +158,7 @@ static int pseries_remove_memory(struct device_node *np)
 static inline int pseries_remove_memblock(unsigned long base,
 					  unsigned int memblock_size)
 {
-	return -EOPNOTSUPP;
+	return 0;
 }
 static inline int pseries_remove_memory(struct device_node *np)
 {
-- 
2.1.0

