Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbaELC07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:26:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34349 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaELBlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:31 -0400
Message-Id: <20140512003201.259128211@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, Willy Tarreau <w@1wt.eu>
Subject: [ 015/143] af_key: fix info leaks in notify messages
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit a5cc68f3d63306d0d288f31edfc2ae6ef8ecd887 upstream

key_notify_sa_flush() and key_notify_policy_flush() miss to initialize
the sadb_msg_reserved member of the broadcasted message and thereby
leak 2 bytes of heap memory to listeners. Fix that.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/key/af_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 4e98193..03d626f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1726,6 +1726,7 @@ static int key_notify_sa_flush(struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 
 	pfkey_broadcast(skb, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 
@@ -2694,6 +2695,7 @@ static int key_notify_policy_flush(struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 	return 0;
 
-- 
1.7.12.2.21.g234cd45.dirty



