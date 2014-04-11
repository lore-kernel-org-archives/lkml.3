Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbaDKQnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:43:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbaDKQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 35/65] rtnetlink: fix fdb notification flags
Date: Fri, 11 Apr 2014 09:11:07 -0700
Message-Id: <20140411161002.558180561@linuxfoundation.org>
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

[ Upstream commit 1c104a6bebf3c16b6248408b84f91d09ac8a26b6 ]

Commit 3ff661c38c84 ("net: rtnetlink notify events for FDB NTF_SELF adds and
deletes") reuses the function nlmsg_populate_fdb_fill() to notify fdb events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2014,12 +2014,13 @@ EXPORT_SYMBOL(rtmsg_ifinfo);
 static int nlmsg_populate_fdb_fill(struct sk_buff *skb,
 				   struct net_device *dev,
 				   u8 *addr, u32 pid, u32 seq,
-				   int type, unsigned int flags)
+				   int type, unsigned int flags,
+				   int nlflags)
 {
 	struct nlmsghdr *nlh;
 	struct ndmsg *ndm;
 
-	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ndm), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ndm), nlflags);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -2057,7 +2058,7 @@ static void rtnl_fdb_notify(struct net_d
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF, 0);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
@@ -2282,7 +2283,8 @@ static int nlmsg_populate_fdb(struct sk_
 
 		err = nlmsg_populate_fdb_fill(skb, dev, ha->addr,
 					      portid, seq,
-					      RTM_NEWNEIGH, NTF_SELF);
+					      RTM_NEWNEIGH, NTF_SELF,
+					      NLM_F_MULTI);
 		if (err < 0)
 			return err;
 skip:


