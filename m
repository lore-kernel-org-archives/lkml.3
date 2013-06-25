Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3FYSyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:54:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3FYSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 78/95] tuntap: set transport header before passing it to kernel
Date: Tue, 25 Jun 2013 11:33:05 -0700
Message-Id: <20130625182202.393335388@linuxfoundation.org>
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

[ Upstream commit 38502af77e07b5d6650b9ff99a0b482d86366592 ]

Currently, for the packets receives from tuntap, before doing header check,
kernel just reset the transport header in netif_receive_skb() which pretends no
l4 header. This is suboptimal for precise packet length estimation (introduced
in 1def9238) which needs correct l4 header for gso packets.

So this patch set the transport header to csum_start for partial checksum
packets, otherwise it first try skb_flow_dissect(), if it fails, just reset the
transport header.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -70,6 +70,7 @@
 #include <net/sock.h>
 
 #include <asm/uaccess.h>
+#include <net/flow_keys.h>
 
 /* Uncomment to enable debugging */
 /* #define TUN_DEBUG 1 */
@@ -1051,6 +1052,7 @@ static ssize_t tun_get_user(struct tun_s
 	bool zerocopy = false;
 	int err;
 	u32 rxhash;
+	struct flow_keys keys;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) > total_len)
@@ -1205,6 +1207,14 @@ static ssize_t tun_get_user(struct tun_s
 	}
 
 	skb_reset_network_header(skb);
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		skb_set_transport_header(skb, skb_checksum_start_offset(skb));
+	else if (skb_flow_dissect(skb, &keys))
+		skb_set_transport_header(skb, keys.thoff);
+	else
+		skb_reset_transport_header(skb);
+
 	rxhash = skb_get_rxhash(skb);
 	netif_rx_ni(skb);
 


