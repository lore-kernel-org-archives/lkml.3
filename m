Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbaE2Eix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbaE2Eiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Suarez <gsuarez@smithmicro.com>,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 66/86] net: cdc_mbim: handle unaccelerated VLAN tagged frames
Date: Wed, 28 May 2014 21:37:41 -0700
Message-Id: <20140529043522.427338922@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 6b5eeb7f874b689403e52a646e485d0191ab9507 ]

This driver maps 802.1q VLANs to MBIM sessions. The mapping is based on
a bogus assumption that all tagged frames will use the acceleration API
because we enable NETIF_F_HW_VLAN_CTAG_TX. This fails for e.g. frames
tagged in userspace using packet sockets. Such frames will erroneously
be considered as untagged and silently dropped based on not being IP.

Fix by falling back to looking into the ethernet header for a tag if no
accelerated tag was found.

Fixes: a82c7ce5bc5b ("net: cdc_ncm: map MBIM IPS SessionID to VLAN ID")
Cc: Greg Suarez <gsuarez@smithmicro.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_mbim.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -120,6 +120,16 @@ static void cdc_mbim_unbind(struct usbne
 	cdc_ncm_unbind(dev, intf);
 }
 
+/* verify that the ethernet protocol is IPv4 or IPv6 */
+static bool is_ip_proto(__be16 proto)
+{
+	switch (proto) {
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+		return true;
+	}
+	return false;
+}
 
 static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 {
@@ -128,6 +138,7 @@ static struct sk_buff *cdc_mbim_tx_fixup
 	struct cdc_ncm_ctx *ctx = info->ctx;
 	__le32 sign = cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN);
 	u16 tci = 0;
+	bool is_ip;
 	u8 *c;
 
 	if (!ctx)
@@ -137,25 +148,32 @@ static struct sk_buff *cdc_mbim_tx_fixup
 		if (skb->len <= ETH_HLEN)
 			goto error;
 
+		/* Some applications using e.g. packet sockets will
+		 * bypass the VLAN acceleration and create tagged
+		 * ethernet frames directly.  We primarily look for
+		 * the accelerated out-of-band tag, but fall back if
+		 * required
+		 */
+		skb_reset_mac_header(skb);
+		if (vlan_get_tag(skb, &tci) < 0 && skb->len > VLAN_ETH_HLEN &&
+		    __vlan_get_tag(skb, &tci) == 0) {
+			is_ip = is_ip_proto(vlan_eth_hdr(skb)->h_vlan_encapsulated_proto);
+			skb_pull(skb, VLAN_ETH_HLEN);
+		} else {
+			is_ip = is_ip_proto(eth_hdr(skb)->h_proto);
+			skb_pull(skb, ETH_HLEN);
+		}
+
 		/* mapping VLANs to MBIM sessions:
 		 *   no tag     => IPS session <0>
 		 *   1 - 255    => IPS session <vlanid>
 		 *   256 - 511  => DSS session <vlanid - 256>
 		 *   512 - 4095 => unsupported, drop
 		 */
-		vlan_get_tag(skb, &tci);
-
 		switch (tci & 0x0f00) {
 		case 0x0000: /* VLAN ID 0 - 255 */
-			/* verify that datagram is IPv4 or IPv6 */
-			skb_reset_mac_header(skb);
-			switch (eth_hdr(skb)->h_proto) {
-			case htons(ETH_P_IP):
-			case htons(ETH_P_IPV6):
-				break;
-			default:
+			if (!is_ip)
 				goto error;
-			}
 			c = (u8 *)&sign;
 			c[3] = tci;
 			break;
@@ -169,7 +187,6 @@ static struct sk_buff *cdc_mbim_tx_fixup
 				  "unsupported tci=0x%04x\n", tci);
 			goto error;
 		}
-		skb_pull(skb, ETH_HLEN);
 	}
 
 	spin_lock_bh(&ctx->mtx);


