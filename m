Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbaE2FSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:18:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbaE2Efb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 088/140] rtnetlink: Warn when interfaces information wont fit in our packet
Date: Wed, 28 May 2014 21:33:47 -0700
Message-Id: <20140529043100.928899175@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1130,6 +1130,7 @@ static int rtnl_dump_ifinfo(struct sk_bu
 	struct hlist_head *head;
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
+	int err;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -1150,11 +1151,17 @@ static int rtnl_dump_ifinfo(struct sk_bu
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


