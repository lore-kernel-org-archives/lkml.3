Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3ITULv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:11:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3ITULt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:11:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 81/93] crypto: api - Fix race condition in larval lookup
Date: Fri, 20 Sep 2013 13:09:16 -0700
Message-Id: <1379707768-1804-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 77dbd7a95e4a4f15264c333a9e9ab97ee27dc2aa upstream.

crypto_larval_lookup should only return a larval if it created one.
Any larval created by another entity must be processed through
crypto_larval_wait before being returned.

Otherwise this will lead to a larval being killed twice, which
will most likely lead to a crash.

Reported-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 3b61803..37c4c72 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
@@ -144,8 +146,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
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
1.8.1.2

