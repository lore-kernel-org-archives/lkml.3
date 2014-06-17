Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967376AbaFQVzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:55:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967266AbaFQVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/212] af_iucv: wrong mapping of sent and confirmed skbs
Date: Tue, 17 Jun 2014 14:44:01 -0700
Message-Id: <1403041506-13646-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ursula Braun <ursula.braun@de.ibm.com>

commit f5738e2ef88070ef1372e6e718124d88e9abe4ac upstream.

When sending data through IUCV a MESSAGE COMPLETE interrupt
signals that sent data memory can be freed or reused again.
With commit f9c41a62bba3f3f7ef3541b2a025e3371bcbba97
"af_iucv: fix recvmsg by replacing skb_pull() function" the
MESSAGE COMPLETE callback iucv_callback_txdone() identifies
the wrong skb as being confirmed, which leads to data corruption.
This patch fixes the skb mapping logic in iucv_callback_txdone().

Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Frank Blaschka <frank.blaschka@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/iucv/af_iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c4b7218..1465363 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1829,7 +1829,7 @@ static void iucv_callback_txdone(struct iucv_path *path,
 		spin_lock_irqsave(&list->lock, flags);
 
 		while (list_skb != (struct sk_buff *)list) {
-			if (msg->tag != IUCV_SKB_CB(list_skb)->tag) {
+			if (msg->tag == IUCV_SKB_CB(list_skb)->tag) {
 				this = list_skb;
 				break;
 			}
-- 
1.9.1

