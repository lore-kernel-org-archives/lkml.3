Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaELB7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:59:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34640 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbaELBmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:51 -0400
Message-Id: <20140512003202.045601156@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 034/143] connector: use nlmsg_len() to check message length
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 162b2bedc084d2d908a04c93383ba02348b648b0 ]

The current code tests the length of the whole netlink message to be
at least as long to fit a cn_msg. This is wrong as nlmsg_len includes
the length of the netlink message header. Use nlmsg_len() instead to
fix this "off-by-NLMSG_HDRLEN" size check.

Cc: stable@vger.kernel.org  
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/connector/connector.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 537c29a..980412b 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -177,17 +177,18 @@ static int cn_call_callback(struct sk_buff *skb)
 static void cn_rx_skb(struct sk_buff *__skb)
 {
 	struct nlmsghdr *nlh;
-	int err;
 	struct sk_buff *skb;
+	int len, err;
 
 	skb = skb_get(__skb);
 
 	if (skb->len >= NLMSG_SPACE(0)) {
 		nlh = nlmsg_hdr(skb);
+		len = nlmsg_len(nlh);
 
-		if (nlh->nlmsg_len < sizeof(struct cn_msg) ||
+		if (len < (int)sizeof(struct cn_msg) ||
 		    skb->len < nlh->nlmsg_len ||
-		    nlh->nlmsg_len > CONNECTOR_MAX_MSG_SIZE) {
+		    len > CONNECTOR_MAX_MSG_SIZE) {
 			kfree_skb(skb);
 			return;
 		}
-- 
1.7.12.2.21.g234cd45.dirty



