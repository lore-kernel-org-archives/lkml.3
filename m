Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbbASFZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:25:45 -0500
Received: from mail.eperm.de ([89.247.134.16]:59544 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbbASFZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:25:33 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Sun, 18 Jan 2015 23:56:03 +0100
Message-ID: <2587101.YvN0IxRmOH@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cipher registered as __driver-gcm-aes-aesni is never intended
to be used directly by any caller. Instead it is a service mechanism to
rfc4106-gcm-aesni.

The kernel crypto API unconditionally calls the registered setkey
function. In case a caller erroneously uses __driver-gcm-aes-aesni a
call to crypto_aead_setkey will cause a NULL pointer dereference without
this patch.

CC: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 947c6bf..a278ef9 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1012,6 +1012,16 @@ static int rfc4106_decrypt(struct aead_request *req)
 	}
 }
 
+static int __driver_rfc4106_set_key(struct crypto_aead *parent,
+				    const u8 *key, unsigned int key_len)
+{
+	/*
+	 * __driver-gcm-aes-aesni is only a backend for rfc4106-gcm-aesni
+	 * and is never intended to be used as a regular cipher.
+	 */
+	return -EOPNOTSUPP;
+}
+
 static int __driver_rfc4106_encrypt(struct aead_request *req)
 {
 	u8 one_entry_in_sg = 0;
@@ -1366,6 +1376,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_module		= THIS_MODULE,
 	.cra_u = {
 		.aead = {
+			.setkey		= __driver_rfc4106_set_key,
 			.encrypt	= __driver_rfc4106_encrypt,
 			.decrypt	= __driver_rfc4106_decrypt,
 		},
-- 
2.1.0


