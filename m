Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHQPnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:43:52 -0400
Received: from mail.eperm.de ([89.247.134.16]:37398 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaHQPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:43:50 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 5/8] DRBG: use kmalloc instead of kzalloc for V and C
Date: Sun, 17 Aug 2014 17:39:31 +0200
Message-ID: <1908749.s83x5fJMRR@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating V, C, the zeroization is only needed when
allocating a new instance of the DRBG, i.e. when performing an
initial seeding. For all other allocations, the memcpy implemented in
drbg_copy_drbg ensures that the memory is filled with the correct
information.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d13f588..997c510 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1142,6 +1142,11 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		pr_devel("DRBG: using personalization string\n");
 	}
 
+	if (!reseed) {
+		memset(drbg->V, 0, drbg_statelen(drbg));
+		memset(drbg->C, 0, drbg_statelen(drbg));
+	}
+
 	ret = drbg->d_ops->update(drbg, &seedlist, reseed);
 	if (ret)
 		goto out;
@@ -1186,14 +1191,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg)
 		return -EINVAL;
 
-	drbg->V = kzalloc(drbg_statelen(drbg), GFP_KERNEL);
+	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->V)
 		goto err;
-	drbg->C = kzalloc(drbg_statelen(drbg), GFP_KERNEL);
+	drbg->C = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->C)
 		goto err;
 #ifdef CONFIG_CRYPTO_FIPS
-	drbg->prev = kzalloc(drbg_blocklen(drbg), GFP_KERNEL);
+	drbg->prev = kmalloc(drbg_blocklen(drbg), GFP_KERNEL);
 	if (!drbg->prev)
 		goto err;
 	drbg->fips_primed = false;
-- 
1.9.3


