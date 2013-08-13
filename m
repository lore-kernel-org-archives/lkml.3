Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab3HMWCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:02:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48829 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3HMWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:02:31 -0400
Date: Tue, 13 Aug 2013 15:02:27 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org
Subject: [PATCH] ecryptfs: avoid ctx initialization race
Message-ID: <20130813220227.GA20160@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be possible for two callers to race the mutex lock after the
NULL ctx check. Instead, move the lock above the check so there isn't
the possibility of leaking a crypto ctx. Additionally, report the full
algo name when failing.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ecryptfs/crypto.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index d107576..c134346 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -618,27 +618,28 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat)
 			"key_size_bits = [%zd]\n",
 			crypt_stat->cipher, (int)strlen(crypt_stat->cipher),
 			crypt_stat->key_size << 3);
+	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	if (crypt_stat->tfm) {
 		rc = 0;
-		goto out;
+		goto out_unlock;
 	}
-	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
 						    crypt_stat->cipher, "cbc");
 	if (rc)
 		goto out_unlock;
 	crypt_stat->tfm = crypto_alloc_ablkcipher(full_alg_name, 0, 0);
-	kfree(full_alg_name);
 	if (IS_ERR(crypt_stat->tfm)) {
 		rc = PTR_ERR(crypt_stat->tfm);
 		crypt_stat->tfm = NULL;
 		ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
 				"Error initializing cipher [%s]\n",
-				crypt_stat->cipher);
-		goto out_unlock;
+				full_alg_name);
+		goto out_free;
 	}
 	crypto_ablkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
 	rc = 0;
+out_free:
+	kfree(full_alg_name);
 out_unlock:
 	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 out:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
