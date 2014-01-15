Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaAOWPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:15:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41238 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaAOV7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 158/166] net: rose: restore old recvmsg behavior
Date: Wed, 15 Jan 2014 13:52:52 -0800
Message-Id: <1389822780-4729-159-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f81152e35001e91997ec74a7b4e040e6ab0acccf ]

recvmsg handler in net/rose/af_rose.c performs size-check ->msg_namelen.

After commit f3d3342602f8bcbf37d7c46641cb9bca7618eb1c
(net: rework recvmsg handler msg_name and msg_namelen logic), we now
always take the else branch due to namelen being initialized to 0.

Digging in netdev-vger-cvs git repo shows that msg_namelen was
initialized with a fixed-size since at least 1995, so the else branch
was never taken.

Compile tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/rose/af_rose.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index ce5f5b9..bde7d69 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (msg->msg_name) {
 		struct sockaddr_rose *srose;
+		struct full_sockaddr_rose *full_srose = msg->msg_name;
 
 		memset(msg->msg_name, 0, sizeof(struct full_sockaddr_rose));
 		srose = msg->msg_name;
@@ -1264,18 +1265,9 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
 		srose->srose_ndigis = rose->dest_ndigis;
-		if (msg->msg_namelen >= sizeof(struct full_sockaddr_rose)) {
-			struct full_sockaddr_rose *full_srose = (struct full_sockaddr_rose *)msg->msg_name;
-			for (n = 0 ; n < rose->dest_ndigis ; n++)
-				full_srose->srose_digis[n] = rose->dest_digis[n];
-			msg->msg_namelen = sizeof(struct full_sockaddr_rose);
-		} else {
-			if (rose->dest_ndigis >= 1) {
-				srose->srose_ndigis = 1;
-				srose->srose_digi = rose->dest_digis[0];
-			}
-			msg->msg_namelen = sizeof(struct sockaddr_rose);
-		}
+		for (n = 0 ; n < rose->dest_ndigis ; n++)
+			full_srose->srose_digis[n] = rose->dest_digis[n];
+		msg->msg_namelen = sizeof(struct full_sockaddr_rose);
 	}
 
 	skb_free_datagram(sk, skb);
-- 
1.8.3.2

