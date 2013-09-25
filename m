Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3IYAMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:12:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3IYAMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 02/40] crypto: api - Fix race condition in larval lookup
Date: Tue, 24 Sep 2013 17:11:34 -0700
Message-Id: <20130925001042.235645066@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/api.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/crypto/api.c
+++ b/crypto/api.c
@@ -40,6 +40,8 @@ static inline struct crypto_alg *crypto_
 	return alg;
 }
 
+static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
+
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
@@ -150,8 +152,11 @@ static struct crypto_alg *crypto_larval_
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


