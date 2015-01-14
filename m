Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbbANIrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:47:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbANHZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.18 032/150] Bluetooth: 6lowpan: fix skb_unshare behaviour
Date: Tue, 13 Jan 2015 23:21:43 -0800
Message-Id: <20150114072057.326360116@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <alex.aring@gmail.com>

commit b0c42cd7b210efc74aa4bfc3e39a2814dfaa9b89 upstream.

This patch reverts commit:

a7807d73 ("Bluetooth: 6lowpan: Avoid memory leak if memory allocation
fails")

which was wrong suggested by Alexander Aring. The function skb_unshare
run also kfree_skb on failure.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/6lowpan.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -591,17 +591,13 @@ static netdev_tx_t bt_xmit(struct sk_buf
 	int err = 0;
 	bdaddr_t addr;
 	u8 addr_type;
-	struct sk_buff *tmpskb;
 
 	/* We must take a copy of the skb before we modify/replace the ipv6
 	 * header as the header could be used elsewhere
 	 */
-	tmpskb = skb_unshare(skb, GFP_ATOMIC);
-	if (!tmpskb) {
-		kfree_skb(skb);
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
 		return NET_XMIT_DROP;
-	}
-	skb = tmpskb;
 
 	/* Return values from setup_header()
 	 *  <0 - error, packet is dropped


