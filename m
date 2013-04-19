Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3DSUZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:25:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:32569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab3DSUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="321066342"
Subject: [PATCH] Fix prototype definitions of sha256_transform_asm, 
 sha512_transform_asm
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <1364331519.27102.10.camel@schen9-DESK>
References: <cover.1364303479.git.tim.c.chen@linux.intel.com>
	 <1364331519.27102.10.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Apr 2013 13:25:12 -0700
Message-ID: <1366403112.27102.112.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

This is a follow on patch to the optimized sha256 and sha512 patch series that's just
merged into the crypto-dev.  Let me know if you prefer me to respin the
patch series.

This patch corrects the prototype of sha256_transform_asm and
sha512_transform_asm function pointer declaration to static.  It also
fixes a typo in sha512_ssse3_final function that affects the computation
of upper 64 bits of the buffer size.

Thanks.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 2 +-
 arch/x86/crypto/sha512_ssse3_glue.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index fa65453..8a0b711 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -53,7 +53,7 @@ asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
 				     u64 rounds);
 #endif
 
-asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
+static void (*sha256_transform_asm)(const char *, u32 *, u64);
 
 
 static int sha256_ssse3_init(struct shash_desc *desc)
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 295f790..3c844f2 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -52,7 +52,7 @@ asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
 				     u64 rounds);
 #endif
 
-asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
+static void (*sha512_transform_asm)(const char *, u64 *, u64);
 
 
 static int sha512_ssse3_init(struct shash_desc *desc)
@@ -141,7 +141,7 @@ static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
 
 	/* save number of bits */
 	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3) | sctx->count[0] >> 61;
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
 
 	/* Pad out to 112 mod 128 and append length */
 	index = sctx->count[0] & 0x7f;
-- 
1.7.11.7



