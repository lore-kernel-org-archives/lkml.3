Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597Ab3GQW4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934485Ab3GQW4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 078/145] netfilter: nfnetlink_acct: fix incomplete dumping of objects
Date: Wed, 17 Jul 2013 15:46:50 -0700
Message-Id: <1374101277-7915-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 991a6b735ff47710769545b11e481bb140b2e6f7 upstream.

Fix broken incomplete object dumping if the list of objects does not
fit into one single netlink message.

Reported-by: Gabriel Lazar <Gabriel.Lazar@com.utcluj.ro>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nfnetlink_acct.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 589d686..125bd35 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -147,9 +147,12 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &nfnl_acct_list, head) {
-		if (last && cur != last)
-			continue;
+		if (last) {
+			if (cur != last)
+				continue;
 
+			last = NULL;
+		}
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-- 
1.8.1.2

