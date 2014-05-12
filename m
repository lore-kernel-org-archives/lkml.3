Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbaELC0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:26:13 -0400
Received: from 1wt.eu ([62.212.114.60]:34355 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaELBlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:32 -0400
Message-Id: <20140512003201.673375440@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Nikola Pajkovsky <npajkovs@redhat.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 025/143] crypto: api - Fix race condition in larval lookup
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Pajkovsky <npajkovs@redhat.com>

https://bugzilla.redhat.com/1016108

64z is missing rhel6 commit 3af031a395c0 ("[crypto] algboss: Hold ref
count on larval") which is causing cosmetic fuzz, because crypto_alg_get
was move from crypto/api.c to crypto/internal.h.

From: Herbert Xu <herbert@gondor.apana.org.au>

[ upstream commit 77dbd7a95e4a4f15264c333a9e9ab97ee27dc2aa ]

crypto_larval_lookup should only return a larval if it created one.
Any larval created by another entity must be processed through
crypto_larval_wait before being returned.

Otherwise this will lead to a larval being killed twice, which
will most likely lead to a crash.

Cc: stable@vger.kernel.org
Reported-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 crypto/api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 798526d..f4be65f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -40,6 +40,8 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 	return alg;
 }
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
@@ -150,8 +152,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	}
 	up_write(&crypto_alg_sem);
 
-	if (alg != &larval->alg)
+	if (alg != &larval->alg) {
 		kfree(larval);
+		if (crypto_is_larval(alg))
+			alg = crypto_larval_wait(alg);
+	}
 
 	return alg;
 }
-- 
1.7.12.2.21.g234cd45.dirty



