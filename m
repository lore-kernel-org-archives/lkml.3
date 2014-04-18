Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaDRJbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45980 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 50/72] rtnetlink: fix fdb notification flags
Date: Fri, 18 Apr 2014 11:22:23 +0200
Message-Id: <be67f8bc657d8b0b0c87a5d6215c6329d9b35a03.1397812482.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/rtnetlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2a0e21de3060..37b492eaa4f8 100644
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
 
@@ -2057,7 +2058,7 @@ static void rtnl_fdb_notify(struct net_device *dev, u8 *addr, int type)
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_fdb_fill(skb, dev, addr, 0, 0, type, NTF_SELF, 0);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
@@ -2282,7 +2283,8 @@ static int nlmsg_populate_fdb(struct sk_buff *skb,
 
 		err = nlmsg_populate_fdb_fill(skb, dev, ha->addr,
 					      portid, seq,
-					      RTM_NEWNEIGH, NTF_SELF);
+					      RTM_NEWNEIGH, NTF_SELF,
+					      NLM_F_MULTI);
 		if (err < 0)
 			return err;
 skip:
-- 
1.9.2

