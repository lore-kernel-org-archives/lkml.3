Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbbAOWNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:13:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbbAOWKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 11/19] batman-adv: Calculate extra tail size based on queued fragments
Date: Thu, 15 Jan 2015 14:09:47 -0800
Message-Id: <1421359795-11155-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 5b6698b0e4a37053de35cc24ee695b98a7eb712b upstream.

The fragmentation code was replaced in 610bfc6bc99bc83680d190ebc69359a05fc7f605
("batman-adv: Receive fragmented packets and merge"). The new code provided a
mostly unused parameter skb for the merging function. It is used inside the
function to calculate the additionally needed skb tailroom. But instead of
increasing its own tailroom, it is only increasing the tailroom of the first
queued skb. This is not correct in some situations because the first queued
entry can be a different one than the parameter.

An observed problem was:

1. packet with size 104, total_size 1464, fragno 1 was received
   - packet is queued
2. packet with size 1400, total_size 1464, fragno 0 was received
   - packet is queued at the end of the list
3. enough data was received and can be given to the merge function
   (1464 == (1400 - 20) + (104 - 20))
   - merge functions gets 1400 byte large packet as skb argument
4. merge function gets first entry in queue (104 byte)
   - stored as skb_out
5. merge function calculates the required extra tail as total_size - skb->len
   - pskb_expand_head tail of skb_out with 64 bytes
6. merge function tries to squeeze the extra 1380 bytes from the second queued
   skb (1400 byte aka skb parameter) in the 64 extra tail bytes of skb_out

Instead calculate the extra required tail bytes for skb_out also using skb_out
instead of using the parameter skb. The skb parameter is only used to get the
total_size from the last received packet. This is also the total_size used to
decide that all fragments were received.

Reported-by: Philipp Psurek <philipp.psurek@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Martin Hundebøll <martin@hundeboll.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/fragmentation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 8a1d4b54..b3c4223 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -253,7 +253,7 @@ batadv_frag_merge_packets(struct hlist_head *chain, struct sk_buff *skb)
 	kfree(entry);
 
 	/* Make room for the rest of the fragments. */
-	if (pskb_expand_head(skb_out, 0, size - skb->len, GFP_ATOMIC) < 0) {
+	if (pskb_expand_head(skb_out, 0, size - skb_out->len, GFP_ATOMIC) < 0) {
 		kfree_skb(skb_out);
 		skb_out = NULL;
 		goto free;
-- 
1.9.1

