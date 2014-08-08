Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbaHHWWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:22:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbaHHUqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 190/259] crypto: arm-aes - fix encryption of unaligned data
Date: Fri,  8 Aug 2014 13:40:13 -0700
Message-Id: <1407530482-4483-191-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f3c400ef473e00c680ea713a66196b05870b3710 upstream.

Fix the same alignment bug as in arm64 - we need to pass residue
unprocessed bytes as the last argument to blkcipher_walk_done.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/crypto/aesbs-glue.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index 4522366..15468fb 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -137,7 +137,7 @@ static int aesbs_cbc_encrypt(struct blkcipher_desc *desc,
 				dst += AES_BLOCK_SIZE;
 			} while (--blocks);
 		}
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -158,7 +158,7 @@ static int aesbs_cbc_decrypt(struct blkcipher_desc *desc,
 		bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	while (walk.nbytes) {
 		u32 blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -182,7 +182,7 @@ static int aesbs_cbc_decrypt(struct blkcipher_desc *desc,
 			dst += AES_BLOCK_SIZE;
 			src += AES_BLOCK_SIZE;
 		} while (--blocks);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -268,7 +268,7 @@ static int aesbs_xts_encrypt(struct blkcipher_desc *desc,
 		bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->enc, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -292,7 +292,7 @@ static int aesbs_xts_decrypt(struct blkcipher_desc *desc,
 		bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
-- 
1.9.1

