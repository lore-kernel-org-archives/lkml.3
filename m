Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967337AbaFQV72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:59:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54912 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967159AbaFQVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Gibson <david@gibson.dropbear.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/212] rtnetlink: Warn when interface's information won't fit in our packet
Date: Tue, 17 Jun 2014 14:41:57 -0700
Message-Id: <1403041506-13646-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gibson <david@gibson.dropbear.id.au>

[ Upstream commit 973462bbde79bb827824c73b59027a0aed5c9ca6 ]

Without IFLA_EXT_MASK specified, the information reported for a single
interface in response to RTM_GETLINK is expected to fit within a netlink
packet of NLMSG_GOODSIZE.

If it doesn't, however, things will go badly wrong,  When listing all
interfaces, netlink_dump() will incorrectly treat -EMSGSIZE on the first
message in a packet as the end of the listing and omit information for
that interface and all subsequent ones.  This can cause getifaddrs(3) to
enter an infinite loop.

This patch won't fix the problem, but it will WARN_ON() making it easier to
track down what's going wrong.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/rtnetlink.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cc706c9..5bee798 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1070,6 +1070,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_head *head;
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
+	int err;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -1090,11 +1091,17 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
-			if (rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
-					     NETLINK_CB(cb->skb).portid,
-					     cb->nlh->nlmsg_seq, 0,
-					     NLM_F_MULTI,
-					     ext_filter_mask) <= 0)
+			err = rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
+					       NETLINK_CB(cb->skb).portid,
+					       cb->nlh->nlmsg_seq, 0,
+					       NLM_F_MULTI,
+					       ext_filter_mask);
+			/* If we ran out of room on the first message,
+			 * we're in trouble
+			 */
+			WARN_ON((err == -EMSGSIZE) && (skb->len == 0));
+
+			if (err <= 0)
 				goto out;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
-- 
1.9.1

