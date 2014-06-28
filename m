Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaF1TPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:15:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaF1Rrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 02/77] af_iucv: wrong mapping of sent and confirmed skbs
Date: Sat, 28 Jun 2014 10:45:55 -0700
Message-Id: <20140628174521.822598806@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/iucv/af_iucv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1829,7 +1829,7 @@ static void iucv_callback_txdone(struct
 		spin_lock_irqsave(&list->lock, flags);
 
 		while (list_skb != (struct sk_buff *)list) {
-			if (msg->tag != IUCV_SKB_CB(list_skb)->tag) {
+			if (msg->tag == IUCV_SKB_CB(list_skb)->tag) {
 				this = list_skb;
 				break;
 			}


