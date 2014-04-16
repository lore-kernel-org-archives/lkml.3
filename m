Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbaDPKcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbaDPKcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 23/46] rtnetlink: fix fdb notification flags
Date: Wed, 16 Apr 2014 11:31:39 +0100
Message-Id: <1397644322-13905-24-git-send-email-luis.henriques@canonical.com>
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

commit 1c104a6bebf3c16b6248408b84f91d09ac8a26b6 upstream.

Commit 3ff661c38c84 ("net: rtnetlink notify events for FDB NTF_SELF adds and
deletes") reuses the function nlmsg_populate_fdb_fill() to notify fdb events.
But this function was used only for dump and thus was always setting the
flag NLM_F_MULTI, which is wrong in case of a single notification.

Libraries like libnl will wait forever for NLMSG_DONE.

CC: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ca198c1d1..6f73a10 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1991,12 +1991,13 @@ EXPORT_SYMBOL(rtmsg_ifinfo);
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
 
@@ -2034,7 +2035,7 @@ static void rtnl_fdb_notify(struct net_device *dev, u8 *addr, int type)
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF, 0);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
@@ -2259,7 +2260,8 @@ static int nlmsg_populate_fdb(struct sk_buff *skb,
 
 		err = nlmsg_populate_fdb_fill(skb, dev, ha->addr,
 					      portid, seq,
-					      RTM_NEWNEIGH, NTF_SELF);
+					      RTM_NEWNEIGH, NTF_SELF,
+					      NLM_F_MULTI);
 		if (err < 0)
 			return err;
 skip:
-- 
1.9.1

