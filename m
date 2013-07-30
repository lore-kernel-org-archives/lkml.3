Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3G3JvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:51:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3G3JdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 046/106] af_key: fix info leaks in notify messages
Date: Tue, 30 Jul 2013 10:31:05 +0100
Message-Id: <1375176725-5825-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit a5cc68f3d63306d0d288f31edfc2ae6ef8ecd887 upstream.

key_notify_sa_flush() and key_notify_policy_flush() miss to initialize
the sadb_msg_reserved member of the broadcasted message and thereby
leak 2 bytes of heap memory to listeners. Fix that.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/key/af_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 34e4185..7a09bbb 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1705,6 +1705,7 @@ static int key_notify_sa_flush(const struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 
 	pfkey_broadcast(skb, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 
@@ -2686,6 +2687,7 @@ static int key_notify_policy_flush(const struct km_event *c)
 	hdr->sadb_msg_version = PF_KEY_V2;
 	hdr->sadb_msg_errno = (uint8_t) 0;
 	hdr->sadb_msg_len = (sizeof(struct sadb_msg) / sizeof(uint64_t));
+	hdr->sadb_msg_reserved = 0;
 	pfkey_broadcast(skb_out, GFP_ATOMIC, BROADCAST_ALL, NULL, c->net);
 	return 0;
 
-- 
1.8.3.2

