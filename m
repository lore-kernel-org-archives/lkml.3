Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3KHCeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:34:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3KHCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 29/91] connector: use nlmsg_len() to check message length
Date: Thu,  7 Nov 2013 18:14:44 -0800
Message-Id: <1383876946-2396-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 162b2bedc084d2d908a04c93383ba02348b648b0 ]

The current code tests the length of the whole netlink message to be
at least as long to fit a cn_msg. This is wrong as nlmsg_len includes
the length of the netlink message header. Use nlmsg_len() instead to
fix this "off-by-NLMSG_HDRLEN" size check.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/connector/connector.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 7b69591..3050b7e 100644
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
1.8.1.2

