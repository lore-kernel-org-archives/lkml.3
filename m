Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbbA2DFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:05:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbbA2Ch2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 006/139] batman-adv: Unify fragment size calculation
Date: Wed, 28 Jan 2015 14:19:09 -0800
Message-Id: <1422483682-15393-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 0402e444cd199389b7fe47be68a67b817e09e097 ]

The fragmentation code was replaced in 610bfc6bc99bc83680d190ebc69359a05fc7f605
("batman-adv: Receive fragmented packets and merge") by an implementation which
can handle up to 16 fragments of a packet. The packet is prepared for the split
in fragments by the function batadv_frag_send_packet and the actual split is
done by batadv_frag_create.

Both functions calculate the size of a fragment themself. But their calculation
differs because batadv_frag_send_packet also subtracts ETH_HLEN. Therefore,
the check in batadv_frag_send_packet "can a full fragment can be created?" may
return true even when batadv_frag_create cannot create a full fragment.

The function batadv_frag_create doesn't check the size of the skb before
splitting it and therefore might try to create a larger fragment than the
remaining buffer. This creates an integer underflow and an invalid len is given
to skb_split.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/fragmentation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index b3c4223..ff7cd41 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -436,7 +436,7 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 	 * fragments larger than BATADV_FRAG_MAX_FRAG_SIZE
 	 */
 	mtu = min_t(unsigned, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
-	max_fragment_size = (mtu - header_size - ETH_HLEN);
+	max_fragment_size = mtu - header_size;
 	max_packet_size = max_fragment_size * BATADV_FRAG_MAX_FRAGMENTS;
 
 	/* Don't even try to fragment, if we need more than 16 fragments */
-- 
1.9.1

