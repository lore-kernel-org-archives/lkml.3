Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaDPKqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:46:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51726 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaDPKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 25/46] ip6mr: fix mfc notification flags
Date: Wed, 16 Apr 2014 11:31:41 +0100
Message-Id: <1397644322-13905-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit f518338b16038beeb73e155e60d0f70beb9379f4 upstream.

Commit 812e44dd1829 ("ip6mr: advertise new mfc entries via rtnl") reuses the
function ip6mr_fill_mroute() to notify mfc events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6mr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 0caf013..1292075 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2351,13 +2351,14 @@ int ip6mr_get_route(struct net *net,
 }
 
 static int ip6mr_fill_mroute(struct mr6_table *mrt, struct sk_buff *skb,
-			     u32 portid, u32 seq, struct mfc6_cache *c, int cmd)
+			     u32 portid, u32 seq, struct mfc6_cache *c, int cmd,
+			     int flags)
 {
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 	int err;
 
-	nlh = nlmsg_put(skb, portid, seq, cmd, sizeof(*rtm), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, portid, seq, cmd, sizeof(*rtm), flags);
 	if (nlh == NULL)
 		return -EMSGSIZE;
 
@@ -2425,7 +2426,7 @@ static void mr6_netlink_event(struct mr6_table *mrt, struct mfc6_cache *mfc,
 	if (skb == NULL)
 		goto errout;
 
-	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2464,7 +2465,8 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 				if (ip6mr_fill_mroute(mrt, skb,
 						      NETLINK_CB(cb->skb).portid,
 						      cb->nlh->nlmsg_seq,
-						      mfc, RTM_NEWROUTE) < 0)
+						      mfc, RTM_NEWROUTE,
+						      NLM_F_MULTI) < 0)
 					goto done;
 next_entry:
 				e++;
@@ -2478,7 +2480,8 @@ next_entry:
 			if (ip6mr_fill_mroute(mrt, skb,
 					      NETLINK_CB(cb->skb).portid,
 					      cb->nlh->nlmsg_seq,
-					      mfc, RTM_NEWROUTE) < 0) {
+					      mfc, RTM_NEWROUTE,
+					      NLM_F_MULTI) < 0) {
 				spin_unlock_bh(&mfc_unres_lock);
 				goto done;
 			}
-- 
1.9.1

