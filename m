Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082Ab3GQXII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:08:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934517Ab3GQW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/145] netfilter: nfnetlink_cttimeout: fix incomplete dumping of objects
Date: Wed, 17 Jul 2013 15:46:49 -0700
Message-Id: <1374101277-7915-78-git-send-email-kamal@canonical.com>
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

commit 37bc4f8dfa72fb43b84381abca39cfdbbc8ff2df upstream.

Fix broken incomplete object dumping if the list of objects does not
fit into one single netlink message.

Reported-by: Gabriel Lazar <Gabriel.Lazar@com.utcluj.ro>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 701c88a..65074df 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -220,9 +220,12 @@ ctnl_timeout_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &cttimeout_list, head) {
-		if (last && cur != last)
-			continue;
+		if (last) {
+			if (cur != last)
+				continue;
 
+			last = NULL;
+		}
 		if (ctnl_timeout_fill_info(skb, NETLINK_CB(cb->skb).portid,
 					   cb->nlh->nlmsg_seq,
 					   NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-- 
1.8.1.2

