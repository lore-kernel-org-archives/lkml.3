Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3FQGS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:18:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:64351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3FQGS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:18:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,878,1363158000"; 
   d="scan'208";a="350895225"
Subject: [PATCH] tcp: Modify the condition for the first skb to collapse
From: Jun Chen <jun.d.chen@intel.com>
To: ycheng@google.com, ncardwell@google.com
Cc: edumazet@google.com, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jun Chen <jun.d.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jun 2013 10:18:59 -0400
Message-ID: <1371478739.10495.5.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When search the first skb to collapse,the condition of overlap to the next one have been
reached,but the start is less than TCP_SKB_CB(skb)->seq at this time, then followed process
will trigger the BUG_ON of the offset(start - TCP_SKB_CB(skb)->seq).
So this patch add one check (! before(start,TCP_SKB_CB(skb)->seq)) to avoid this ipanic.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 net/ipv4/tcp_input.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9c62257..4c745c5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4465,7 +4465,8 @@ restart:
 		 *   overlaps to the next one.
 		 */
 		if (!tcp_hdr(skb)->syn && !tcp_hdr(skb)->fin &&
-		    (tcp_win_from_space(skb->truesize) > skb->len ||
+			((tcp_win_from_space(skb->truesize) > skb->len &&
+			!before(start, TCP_SKB_CB(skb)->seq)) ||
 		     before(TCP_SKB_CB(skb)->seq, start))) {
 			end_of_skbs = false;
 			break;
-- 
1.7.4.1



