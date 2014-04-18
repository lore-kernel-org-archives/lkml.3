Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaDRJcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45979 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 51/72] ipmr: fix mfc notification flags
Date: Fri, 18 Apr 2014 11:22:24 +0200
Message-Id: <6007e2c269182030d25500d3c2b80ee542291cf1.1397812482.git.jslaby@suse.cz>
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

[ Upstream commit 65886f439ab0fdc2dff20d1fa87afb98c6717472 ]

Commit 8cd3ac9f9b7b ("ipmr: advertise new mfc entries via rtnl") reuses the
function ipmr_fill_mroute() to notify mfc events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ipmr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 1672409f5ba5..6fbf3393d842 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2253,13 +2253,14 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 }
 
 static int ipmr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
-			    u32 portid, u32 seq, struct mfc_cache *c, int cmd)
+			    u32 portid, u32 seq, struct mfc_cache *c, int cmd,
+			    int flags)
 {
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 	int err;
 
-	nlh = nlmsg_put(skb, portid, seq, cmd, sizeof(*rtm), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, portid, seq, cmd, sizeof(*rtm), flags);
 	if (nlh == NULL)
 		return -EMSGSIZE;
 
@@ -2327,7 +2328,7 @@ static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 	if (skb == NULL)
 		goto errout;
 
-	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2366,7 +2367,8 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 				if (ipmr_fill_mroute(mrt, skb,
 						     NETLINK_CB(cb->skb).portid,
 						     cb->nlh->nlmsg_seq,
-						     mfc, RTM_NEWROUTE) < 0)
+						     mfc, RTM_NEWROUTE,
+						     NLM_F_MULTI) < 0)
 					goto done;
 next_entry:
 				e++;
@@ -2380,7 +2382,8 @@ next_entry:
 			if (ipmr_fill_mroute(mrt, skb,
 					     NETLINK_CB(cb->skb).portid,
 					     cb->nlh->nlmsg_seq,
-					     mfc, RTM_NEWROUTE) < 0) {
+					     mfc, RTM_NEWROUTE,
+					     NLM_F_MULTI) < 0) {
 				spin_unlock_bh(&mfc_unres_lock);
 				goto done;
 			}
-- 
1.9.2

