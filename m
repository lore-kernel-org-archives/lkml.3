Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaLBTWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:22:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaLBTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 056/121] macvtap: Fix csum_start when VLAN tags are present
Date: Tue,  2 Dec 2014 11:18:55 -0800
Message-Id: <1417548000-1794-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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

Cheers,
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index eed7544..ffe8fa4 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -622,6 +622,8 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
 		vnet_hdr->csum_start = skb_checksum_start_offset(skb);
+		if (vlan_tx_tag_present(skb))
+			vnet_hdr->csum_start += VLAN_HLEN;
 		vnet_hdr->csum_offset = skb->csum_offset;
 	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
-- 
1.9.1

