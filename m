Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaDRJnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45927 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/72] tipc: fix memory leak during module removal
Date: Fri, 18 Apr 2014 11:22:03 +0200
Message-Id: <140490bca84bceb627da429ffceb03fb88b208e3.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Hugne <erik.hugne@ericsson.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1bb8dce57f4d15233688c68990852a10eb1cd79f ]

When the TIPC module is removed, the tasklet handler is disabled
before all other subsystems. This will cause lingering publications
in the name table because the node_down tasklets responsible to
clean up publications from an unreachable node will never run.
When the name table is shut down, these publications are detected
and an error message is logged:
tipc: nametbl_stop(): orphaned hash chain detected
This is actually a memory leak, introduced with commit
993b858e37b3120ee76d9957a901cca22312ffaa ("tipc: correct the order
of stopping services at rmmod")

Instead of just logging an error and leaking memory, we free
the orphaned entries during nametable shutdown.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/name_table.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 09dcd54b04e1..299e45af7e4e 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -942,20 +942,51 @@ int tipc_nametbl_init(void)
 	return 0;
 }
 
+/**
+ * tipc_purge_publications - remove all publications for a given type
+ *
+ * tipc_nametbl_lock must be held when calling this function
+ */
+static void tipc_purge_publications(struct name_seq *seq)
+{
+	struct publication *publ, *safe;
+	struct sub_seq *sseq;
+	struct name_info *info;
+
+	if (!seq->sseqs) {
+		nameseq_delete_empty(seq);
+		return;
+	}
+	sseq = seq->sseqs;
+	info = sseq->info;
+	list_for_each_entry_safe(publ, safe, &info->zone_list, zone_list) {
+		tipc_nametbl_remove_publ(publ->type, publ->lower, publ->node,
+					 publ->ref, publ->key);
+	}
+}
+
 void tipc_nametbl_stop(void)
 {
 	u32 i;
+	struct name_seq *seq;
+	struct hlist_head *seq_head;
+	struct hlist_node *safe;
 
 	if (!table.types)
 		return;
 
-	/* Verify name table is empty, then release it */
+	/* Verify name table is empty and purge any lingering
+	 * publications, then release the name table
+	 */
 	write_lock_bh(&tipc_nametbl_lock);
 	for (i = 0; i < TIPC_NAMETBL_SIZE; i++) {
 		if (hlist_empty(&table.types[i]))
 			continue;
-		pr_err("nametbl_stop(): orphaned hash chain detected\n");
-		break;
+		seq_head = &table.types[i];
+		hlist_for_each_entry_safe(seq, safe, seq_head, ns_list) {
+			tipc_purge_publications(seq);
+		}
+		continue;
 	}
 	kfree(table.types);
 	table.types = NULL;
-- 
1.9.2

