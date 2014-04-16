Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaDPKqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:46:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbaDPKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 24/46] ipmr: fix mfc notification flags
Date: Wed, 16 Apr 2014 11:31:40 +0100
Message-Id: <1397644322-13905-25-git-send-email-luis.henriques@canonical.com>
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

commit 65886f439ab0fdc2dff20d1fa87afb98c6717472 upstream.

Commit 8cd3ac9f9b7b ("ipmr: advertise new mfc entries via rtnl") reuses the
function ipmr_fill_mroute() to notify mfc events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ipmr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6fabc8d..aaa1be5 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2255,13 +2255,14 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
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
 
@@ -2329,7 +2330,7 @@ static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 	if (skb == NULL)
 		goto errout;
 
-	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2368,7 +2369,8 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 				if (ipmr_fill_mroute(mrt, skb,
 						     NETLINK_CB(cb->skb).portid,
 						     cb->nlh->nlmsg_seq,
-						     mfc, RTM_NEWROUTE) < 0)
+						     mfc, RTM_NEWROUTE,
+						     NLM_F_MULTI) < 0)
 					goto done;
 next_entry:
 				e++;
@@ -2382,7 +2384,8 @@ next_entry:
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
1.9.1

