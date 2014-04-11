Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030639AbaDKQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:08:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421AbaDKQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 22/41] ip6mr: fix mfc notification flags
Date: Fri, 11 Apr 2014 09:09:53 -0700
Message-Id: <20140411160934.420168951@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6mr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

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
 
@@ -2425,7 +2426,7 @@ static void mr6_netlink_event(struct mr6
 	if (skb == NULL)
 		goto errout;
 
-	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd);
+	err = ip6mr_fill_mroute(mrt, skb, 0, 0, mfc, cmd, 0);
 	if (err < 0)
 		goto errout;
 
@@ -2464,7 +2465,8 @@ static int ip6mr_rtm_dumproute(struct sk
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


