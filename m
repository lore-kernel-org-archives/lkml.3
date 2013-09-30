Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3I3KNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3I3KNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 098/104] crypto: api - Fix race condition in larval lookup
Date: Mon, 30 Sep 2013 11:11:15 +0100
Message-Id: <1380535881-9239-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..cea3cf6 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
 	atomic_inc(&alg->cra_refcnt);
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
1.8.3.2

