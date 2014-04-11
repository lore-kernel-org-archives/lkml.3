Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbaDKQnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:43:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbaDKQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 36/65] ipmr: fix mfc notification flags
Date: Fri, 11 Apr 2014 09:11:08 -0700
Message-Id: <20140411161002.698513446@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipmr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2253,13 +2253,14 @@ int ipmr_get_route(struct net *net, stru
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
 
@@ -2327,7 +2328,7 @@ static void mroute_netlink_event(struct
 	if (skb == NULL)
 		goto errout;
 
-	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ipmr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2366,7 +2367,8 @@ static int ipmr_rtm_dumproute(struct sk_
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


