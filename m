Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbbAKSFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:05:01 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:45540 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbAKSE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:04:59 -0500
From: Christoph Jaeger <cj@linux.com>
To: davem@davemloft.net
Cc: willemb@google.com, edumazet@google.com, dborkman@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <cj@linux.com>
Subject: [PATCH net] packet: bail out of packet_snd() if L2 header creation fails
Date: Sun, 11 Jan 2015 13:01:16 -0500
Message-Id: <1420999276-28225-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 2.1.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a misplaced parenthesis, the expression

  (unlikely(offset) < 0),

which expands to

  (__builtin_expect(!!(offset), 0) < 0),

never evaluates to true. Therefore, when sending packets with
PF_PACKET/SOCK_DGRAM, packet_snd() does not abort as intended
if the creation of the layer 2 header fails.

Spotted by Coverity - CID 1259975 ("Operands don't affect result").

Fixes: 9c7077622dd9 ("packet: make packet_snd fail on len smaller than l2 header")
Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6880f34..9cfe2e1 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2517,7 +2517,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	err = -EINVAL;
 	if (sock->type == SOCK_DGRAM) {
 		offset = dev_hard_header(skb, dev, ntohs(proto), addr, NULL, len);
-		if (unlikely(offset) < 0)
+		if (unlikely(offset < 0))
 			goto out_free;
 	} else {
 		if (ll_header_truncated(dev, len))
-- 
2.1.0

