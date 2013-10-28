Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3J1Oxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:53:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3J1Otq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 52/64] connector: use nlmsg_len() to check message length
Date: Mon, 28 Oct 2013 14:48:11 +0000
Message-Id: <1382971703-17393-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 162b2bedc084d2d908a04c93383ba02348b648b0 upstream.

The current code tests the length of the whole netlink message to be
at least as long to fit a cn_msg. This is wrong as nlmsg_len includes
the length of the netlink message header. Use nlmsg_len() instead to
fix this "off-by-NLMSG_HDRLEN" size check.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/connector/connector.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index dde6a0f..ea6efe8 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -157,17 +157,18 @@ static int cn_call_callback(struct sk_buff *skb)
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
1.8.3.2

