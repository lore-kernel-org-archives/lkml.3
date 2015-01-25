Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbbAYTEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:04:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbbAYSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 012/183] batman-adv: Unify fragment size calculation
Date: Sun, 25 Jan 2015 10:05:34 -0800
Message-Id: <20150125180810.723997627@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -434,7 +434,7 @@ bool batadv_frag_send_packet(struct sk_b
 	 * fragments larger than BATADV_FRAG_MAX_FRAG_SIZE
 	 */
 	mtu = min_t(unsigned, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
-	max_fragment_size = (mtu - header_size - ETH_HLEN);
+	max_fragment_size = mtu - header_size;
 	max_packet_size = max_fragment_size * BATADV_FRAG_MAX_FRAGMENTS;
 
 	/* Don't even try to fragment, if we need more than 16 fragments */


