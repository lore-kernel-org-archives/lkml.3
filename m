Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3DBWiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:38:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466Ab3DBWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Oostdyk <daveo@ll.mit.edu>, Eric Dumazet <edumazet@google.com>,
        Ed Cashin <ecashin@coraid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 111/124] aoe: reserve enough headroom on skbs
Date: Tue,  2 Apr 2013 15:11:33 -0700
Message-Id: <20130402221117.060428566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 91c5746425aed8f7188a351f1224a26aa232e4b3 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/aoe/aoecmd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -51,8 +51,9 @@ new_skb(ulong len)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb(len, GFP_ATOMIC);
+	skb = alloc_skb(len + MAX_HEADER, GFP_ATOMIC);
 	if (skb) {
+		skb_reserve(skb, MAX_HEADER);
 		skb_reset_mac_header(skb);
 		skb_reset_network_header(skb);
 		skb->protocol = __constant_htons(ETH_P_AOE);


