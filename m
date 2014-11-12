Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaKLHJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:09:41 -0500
Received: from mail.eperm.de ([89.247.134.16]:54498 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaKLHJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:09:37 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] crypto: AF_ALG: extend data structuers for AEAD
Date: Wed, 12 Nov 2014 08:01:55 +0100
Message-ID: <2335823.jDvecWWIYp@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <4738444.A2vZX1nNCo@tachyon.chronox.de>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure holding the state of an ongoing symmetric cipher
operation is extended by the data variables needed for AEAD.

The request data structures are encapsulated by a union as the symmetric
cipher implementation is either exclusively used for "normal" symmetric
ciphers or for AEAD ciphers.

The define MAX_AEAD_ASSOCLEN restricts the size of the associated
authentication data. The kernel must allocate memory for this data to be
stored for the cipher operation. To prevent an excessive use of memory,
it is limited to 128 bytes, which is considered to be a sensible size.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 7a1656b..9286cfc 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -46,7 +46,15 @@ struct skcipher_ctx {
 	bool merge;
 	bool enc;
 
-	struct ablkcipher_request req;
+	bool aead;
+	void *aead_assoc;
+	/* define arbitrary maximum length of associated data */
+	#define MAX_AEAD_ASSOCLEN 128
+	struct scatterlist sg_aead_assoc;
+	union {
+		struct ablkcipher_request ablkcipher_req;
+		struct aead_request aead_req;
+	} u;
 };
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
-- 
2.1.0


