Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbaDVVj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:39:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaDVUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/133] rtnetlink: fix fdb notification flags
Date: Tue, 22 Apr 2014 13:12:30 -0700
Message-Id: <1398197671-12786-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/rtnetlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 055fb13..23d73d3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1997,12 +1997,13 @@ errout:
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
 
@@ -2040,7 +2041,7 @@ static void rtnl_fdb_notify(struct net_device *dev, u8 *addr, int type)
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF, 0);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
@@ -2204,7 +2205,8 @@ static int nlmsg_populate_fdb(struct sk_buff *skb,
 
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

