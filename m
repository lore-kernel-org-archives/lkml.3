Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbaGXKBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:01:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934643AbaGXJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/128] crypto: sha512_ssse3 - fix byte count to bit count conversion
Date: Thu, 24 Jul 2014 10:45:40 +0100
Message-Id: <1406195177-8656-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit cfe82d4f45c7cc39332a2be7c4c1d3bf279bbd3d upstream.

Byte-to-bit-count computation is only partly converted to big-endian and is
mixing in CPU-endian values. Problem was noticed by sparce with warning:

  CHECK   arch/x86/crypto/sha512_ssse3_glue.c
arch/x86/crypto/sha512_ssse3_glue.c:144:19: warning: restricted __be64 degrades to integer
arch/x86/crypto/sha512_ssse3_glue.c:144:17: warning: incorrect type in assignment (different base types)
arch/x86/crypto/sha512_ssse3_glue.c:144:17:    expected restricted __be64 <noident>
arch/x86/crypto/sha512_ssse3_glue.c:144:17:    got unsigned long long

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/crypto/sha512_ssse3_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index f30cd10293f0..8626b03e83b7 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -141,7 +141,7 @@ static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
 
 	/* save number of bits */
 	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3) | sctx->count[0] >> 61;
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
 
 	/* Pad out to 112 mod 128 and append length */
 	index = sctx->count[0] & 0x7f;
-- 
1.9.1

