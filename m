Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaESR0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:26:44 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44103 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbaESR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:26:39 -0400
From: Michael Spang <spang@chromium.org>
To: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Spang <spang@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] macvlan: Fix checksum errors when ip_summed is CHECKSUM_PARTIAL
Date: Mon, 19 May 2014 13:24:14 -0400
Message-Id: <1400520254-5142-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing ip_summed from CHECKSUM_PARTIAL to CHECKSUM_UNNECESSARY
will result in an incorrect checksum if the packet is sent off the box.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Spang <spang@chromium.org>
---
 drivers/net/macvlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 753a8c2..806b56a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -267,7 +267,9 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
 		const struct ethhdr *eth = (void *)skb->data;
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		if (skb->ip_summed == CHECKSUM_NONE)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		/* send to other bridge ports directly */
 		if (is_multicast_ether_addr(eth->h_dest)) {
-- 
2.0.0.rc2

