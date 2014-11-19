Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbaKSWD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:03:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406AbaKSVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 032/122] macvtap: Fix csum_start when VLAN tags are present
Date: Wed, 19 Nov 2014 12:51:22 -0800
Message-Id: <20141119205209.842017006@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 3ce9b20f1971690b8b3b620e735ec99431573b39 upstream.

When VLAN is in use in macvtap_put_user, we end up setting
csum_start to the wrong place.  The result is that the whoever
ends up doing the checksum setting will corrupt the packet instead
of writing the checksum to the expected location, usually this
means writing the checksum with an offset of -4.

This patch fixes this by adjusting csum_start when VLAN tags are
detected.

Fixes: f09e2249c4f5 ("macvtap: restore vlan header on user read")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/macvtap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -629,6 +629,8 @@ static void macvtap_skb_to_vnet_hdr(cons
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
 		vnet_hdr->csum_start = skb_checksum_start_offset(skb);
+		if (vlan_tx_tag_present(skb))
+			vnet_hdr->csum_start += VLAN_HLEN;
 		vnet_hdr->csum_offset = skb->csum_offset;
 	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;


