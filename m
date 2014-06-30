Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaF3L60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52096 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/181] tipc: fix memory leak of publications
Date: Mon, 30 Jun 2014 13:50:29 +0200
Message-Id: <481956841e2e0f88b519267c91d86b7625e2a3af.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1621b94d2a655c8548ddbdfc8ccf907a5bbdc860 upstream.

Commit 1bb8dce57f4d15233688c68990852a10eb1cd79f ("tipc: fix memory
leak during module removal") introduced a memory leak issue: when
name table is stopped, it's forgotten that publication instances are
freed properly. Additionally the useless "continue" statement in
tipc_nametbl_stop() is removed as well.

Reported-by: Jason <huzhijiang@gmail.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Erik Hugne <erik.hugne@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/name_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 299e45af7e4e..ec2ecbd515ae 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -962,6 +962,7 @@ static void tipc_purge_publications(struct name_seq *seq)
 	list_for_each_entry_safe(publ, safe, &info->zone_list, zone_list) {
 		tipc_nametbl_remove_publ(publ->type, publ->lower, publ->node,
 					 publ->ref, publ->key);
+		kfree(publ);
 	}
 }
 
@@ -986,7 +987,6 @@ void tipc_nametbl_stop(void)
 		hlist_for_each_entry_safe(seq, safe, seq_head, ns_list) {
 			tipc_purge_publications(seq);
 		}
-		continue;
 	}
 	kfree(table.types);
 	table.types = NULL;
-- 
2.0.0

