Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaLCLod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:44:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaLCL1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 029/101] macvtap: Fix csum_start when VLAN tags are present
Date: Wed,  3 Dec 2014 12:25:51 +0100
Message-Id: <6e2b9478b3c0545793d0da88287dc417146bad90.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/macvtap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 4abd98efdc34..89d21fc47a16 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -625,6 +625,8 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
 		vnet_hdr->csum_start = skb_checksum_start_offset(skb);
+		if (vlan_tx_tag_present(skb))
+			vnet_hdr->csum_start += VLAN_HLEN;
 		vnet_hdr->csum_offset = skb->csum_offset;
 	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
-- 
2.1.3

