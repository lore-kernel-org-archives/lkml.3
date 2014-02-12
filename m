Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaBLIgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50072 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbaBLINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Florian Westphal" <fw@strlen.de>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.852002172@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 11/79] net: rose: restore old recvmsg behavior
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rose/af_rose.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf76dec7..686fb1a 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1258,6 +1258,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (msg->msg_name) {
 		struct sockaddr_rose *srose;
+		struct full_sockaddr_rose *full_srose = msg->msg_name;
 
 		memset(msg->msg_name, 0, sizeof(struct full_sockaddr_rose));
 		srose = msg->msg_name;
@@ -1265,18 +1266,9 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
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

