Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3FYSyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:54:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3FYSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 77/95] macvtap: set transport header before passing skb to lower device
Date: Tue, 25 Jun 2013 11:33:04 -0700
Message-Id: <20130625182202.293197703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9b4d669bc06c215d64f56f1eb0d4eb96e14d689d ]

Set the transport header for 1) some drivers (e.g ixgbe) needs l4 header 2)
precise packet length estimation (introduced in 1def9238) needs l4 header to
compute header length.

For the packets with partial checksum, the patch just set the transport header
to csum_start. Otherwise tries to use skb_flow_dissect() to get l4 offset, if it
fails, just pretend no l4 header.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -21,6 +21,7 @@
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <linux/virtio_net.h>
+#include <net/flow_keys.h>
 
 /*
  * A macvtap queue is the central object of this driver, it connects
@@ -645,6 +646,7 @@ static ssize_t macvtap_get_user(struct m
 	int vnet_hdr_len = 0;
 	int copylen = 0;
 	bool zerocopy = false;
+	struct flow_keys keys;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = q->vnet_hdr_sz;
@@ -725,6 +727,13 @@ static ssize_t macvtap_get_user(struct m
 			goto err_kfree;
 	}
 
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		skb_set_transport_header(skb, skb_checksum_start_offset(skb));
+	else if (skb_flow_dissect(skb, &keys))
+		skb_set_transport_header(skb, keys.thoff);
+	else
+		skb_set_transport_header(skb, ETH_HLEN);
+
 	rcu_read_lock_bh();
 	vlan = rcu_dereference_bh(q->vlan);
 	/* copy skb_ubuf_info for callback when skb has no error */


