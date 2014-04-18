Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaDRJb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45984 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 52/72] ip6mr: fix mfc notification flags
Date: Fri, 18 Apr 2014 11:22:25 +0200
Message-Id: <5d0d91da73f727eda31b8600e6f6d7b8579cbe20.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit f518338b16038beeb73e155e60d0f70beb9379f4 ]

Commit 812e44dd1829 ("ip6mr: advertise new mfc entries via rtnl") reuses the
function ip6mr_fill_mroute() to notify mfc events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6mr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 0eb4038a4d63..8737400af0a0 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2349,13 +2349,14 @@ int ip6mr_get_route(struct net *net,
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
 
@@ -2423,7 +2424,7 @@ static void mr6_netlink_event(struct mr6_table *mrt, struct mfc6_cache *mfc,
 	if (skb == NULL)
 		goto errout;
 
-	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2462,7 +2463,8 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 				if (ip6mr_fill_mroute(mrt, skb,
 						      NETLINK_CB(cb->skb).portid,
 						      cb->nlh->nlmsg_seq,
-						      mfc, RTM_NEWROUTE) < 0)
+						      mfc, RTM_NEWROUTE,
+						      NLM_F_MULTI) < 0)
 					goto done;
 next_entry:
 				e++;
@@ -2476,7 +2478,8 @@ next_entry:
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
1.9.2

