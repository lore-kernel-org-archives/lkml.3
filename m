Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbbA1Een (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:34:43 -0500
Received: from mail.kernel.org ([198.145.29.136]:41103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965202AbbA1EZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:27 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 151/177] macvtap: Fix csum_start when VLAN tags are present
Date: Wed, 28 Jan 2015 12:10:09 +0800
Message-Id: <1422418236-12852-242-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/macvtap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index f5b9de4..f0e3764 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -634,6 +634,8 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
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

