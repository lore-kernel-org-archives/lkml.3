Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbaD3TSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:18:11 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:45392 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaD3TSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:18:08 -0400
From: Milos Vyletel <milos.vyletel@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Cc: linux-coverity@vger.kernel.org, Milos Vyletel <milos.vyletel@gmail.com>
Subject: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Date: Wed, 30 Apr 2014 15:17:54 -0400
Message-Id: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity detected possible use of uninitialized pointer when printing info
message during module load. While this is higly unlikely to cause any troubles
simple change in sha1_ssse3_mod_init to make it look like sha256/512 init
function will fix this.

260
   	6. Condition sha1_transform_asm, taking true branch
261        if (sha1_transform_asm) {

CID 1195603 (#1 of 1): Uninitialized pointer read (UNINIT)
7. uninit_use_in_call: Using uninitialized value algo_name when calling printk.
262                pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
263                return crypto_register_shash(&alg);
264        }

Reported-by: <scan-admin@coverity.com>
Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 74d16ef..5352196 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -235,31 +235,33 @@ static bool __init avx2_usable(void)
 
 static int __init sha1_ssse3_mod_init(void)
 {
-	char *algo_name;
-
 	/* test for SSSE3 first */
-	if (cpu_has_ssse3) {
+	if (cpu_has_ssse3)
 		sha1_transform_asm = sha1_transform_ssse3;
-		algo_name = "SSSE3";
-	}
 
 #ifdef CONFIG_AS_AVX
 	/* allow AVX to override SSSE3, it's a little faster */
 	if (avx_usable()) {
 		sha1_transform_asm = sha1_transform_avx;
-		algo_name = "AVX";
 #ifdef CONFIG_AS_AVX2
 		/* allow AVX2 to override AVX, it's a little faster */
-		if (avx2_usable()) {
+		if (avx2_usable())
 			sha1_transform_asm = sha1_apply_transform_avx2;
-			algo_name = "AVX2";
-		}
 #endif
 	}
 #endif
 
 	if (sha1_transform_asm) {
-		pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
+#ifdef CONFIG_AS_AVX
+		if (sha1_transform_asm == sha1_transform_avx)
+			pr_info("Using AVX optimized SHA-1 implementation\n");
+#ifdef CONFIG_AS_AVX2
+		else if (sha1_transform_asm == sha1_transform_avx2)
+			pr_info("Using AVX2 optimized SHA-1 implementation\n");
+#endif
+		else
+#endif
+			pr_info("Using SSSE3 optimized SHA-1 implementation\n");
 		return crypto_register_shash(&alg);
 	}
 	pr_info("Neither AVX nor AVX2 nor SSSE3 is available/usable.\n");
-- 
1.9.0

