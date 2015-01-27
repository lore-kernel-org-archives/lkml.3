Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbbA0MiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:38:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbbA0MSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 062/126] batman-adv: Unify fragment size calculation
Date: Tue, 27 Jan 2015 12:16:07 +0000
Message-Id: <1422361031-19364-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 0402e444cd199389b7fe47be68a67b817e09e097 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/batman-adv/fragmentation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 57dd88db6bb7..d2b6d5066c33 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -434,7 +434,7 @@ bool batadv_frag_send_packet(struct sk_buff *skb,
 	 * fragments larger than BATADV_FRAG_MAX_FRAG_SIZE
 	 */
 	mtu = min_t(unsigned, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
-	max_fragment_size = (mtu - header_size - ETH_HLEN);
+	max_fragment_size = mtu - header_size;
 	max_packet_size = max_fragment_size * BATADV_FRAG_MAX_FRAGMENTS;
 
 	/* Don't even try to fragment, if we need more than 16 fragments */
-- 
2.1.4

