Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaGXBQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:16:34 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52680 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaGXBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:16:32 -0400
Date: Wed, 23 Jul 2014 18:16:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 1/3] mm, oom: ensure memoryless node zonelist always includes
 zones
Message-ID: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With memoryless node support being worked on, it's possible that for 
optimizations that a node may not have a non-NULL zonelist.  When CONFIG_NUMA is 
enabled and node 0 is memoryless, this means the zonelist for first_online_node 
may become NULL.

The oom killer requires a zonelist that includes all memory zones for the sysrq 
trigger and pagefault out of memory handler.

Ensure that a non-NULL zonelist is always passed to the oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/tty/sysrq.c      |  2 +-
 include/linux/nodemask.h | 10 +++++++++-
 mm/oom_kill.c            |  2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -355,7 +355,7 @@ static struct sysrq_key_op sysrq_term_op = {
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(first_online_node, GFP_KERNEL), GFP_KERNEL,
+	out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL), GFP_KERNEL,
 		      0, NULL, true);
 }
 
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -430,7 +430,15 @@ static inline int num_node_state(enum node_states state)
 	for_each_node_mask((__node), node_states[__state])
 
 #define first_online_node	first_node(node_states[N_ONLINE])
-#define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
+#define first_memory_node	first_node(node_states[N_MEMORY])
+static inline int next_online_node(int nid)
+{
+	return next_node(nid, node_states[N_ONLINE]);
+}
+static inline int next_memory_node(int nid)
+{
+	return next_node(nid, node_states[N_MEMORY]);
+}
 
 extern int nr_node_ids;
 extern int nr_online_nodes;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -694,7 +694,7 @@ void pagefault_out_of_memory(void)
 	if (mem_cgroup_oom_synchronize(true))
 		return;
 
-	zonelist = node_zonelist(first_online_node, GFP_KERNEL);
+	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
 	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
 		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_zonelist_oom(zonelist, GFP_KERNEL);
