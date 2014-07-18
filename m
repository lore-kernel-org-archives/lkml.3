Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603AbaGRNLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:37 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17568 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757854AbaGRNLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 149/170] crypto: sha512_ssse3 - fix byte count to bit count conversion
Date: Fri, 18 Jul 2014 14:12:34 +0200
Message-Id: <cd84cb243c24c43a33edfc09a8dbf46485ab58da.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

