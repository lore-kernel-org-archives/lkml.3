Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaANA5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:57:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaANA1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 28/62] net: rose: restore old recvmsg behavior
Date: Mon, 13 Jan 2014 16:26:53 -0800
Message-Id: <20140114002711.264827390@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1253,6 +1253,7 @@ static int rose_recvmsg(struct kiocb *io
 
 	if (msg->msg_name) {
 		struct sockaddr_rose *srose;
+		struct full_sockaddr_rose *full_srose = msg->msg_name;
 
 		memset(msg->msg_name, 0, sizeof(struct full_sockaddr_rose));
 		srose = msg->msg_name;
@@ -1260,18 +1261,9 @@ static int rose_recvmsg(struct kiocb *io
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


