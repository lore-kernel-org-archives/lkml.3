Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaFGBoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Gibson" <david@gibson.dropbear.id.au>,
        "Jiri Pirko" <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.82438035@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 14/92] rtnetlink: Warn when interface's information
 won't fit  in our packet
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5b7d5f2..978a367 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1057,6 +1057,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_node *node;
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
+	int err;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -1077,11 +1078,17 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 		hlist_for_each_entry_rcu(dev, node, head, index_hlist) {
 			if (idx < s_idx)
 				goto cont;
-			if (rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
-					     NETLINK_CB(cb->skb).pid,
-					     cb->nlh->nlmsg_seq, 0,
-					     NLM_F_MULTI,
-					     ext_filter_mask) <= 0)
+			err = rtnl_fill_ifinfo(skb, dev, RTM_NEWLINK,
+					       NETLINK_CB(cb->skb).pid,
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

