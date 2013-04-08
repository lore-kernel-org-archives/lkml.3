Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935848Ab3DHJwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935795Ab3DHJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Ed Cashin <ecashin@coraid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/102] aoe: reserve enough headroom on skbs
Date: Mon,  8 Apr 2013 10:50:27 +0100
Message-Id: <1365414657-29191-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 91c5746425aed8f7188a351f1224a26aa232e4b3 upstream.

Some network drivers use a non default hard_header_len

Transmitted skb should take into account dev->hard_header_len, or risk
crashes or expensive reallocations.

In the case of aoe, lets reserve MAX_HEADER bytes.

David reported a crash in defxx driver, solved by this patch.

Reported-by: David Oostdyk <daveo@ll.mit.edu>
Tested-by: David Oostdyk <daveo@ll.mit.edu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/aoe/aoecmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 887f68f..db30542 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -30,8 +30,9 @@ new_skb(ulong len)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(len, GFP_ATOMIC);
+	skb = alloc_skb(len + MAX_HEADER, GFP_ATOMIC);
 	if (skb) {
+		skb_reserve(skb, MAX_HEADER);
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);
-- 
1.8.1.2

