Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaHESwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:52:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaHESOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.15 02/42] crypto: arm-aes - fix encryption of unaligned data
Date: Tue,  5 Aug 2014 11:13:16 -0700
Message-Id: <20140805181321.095839264@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f3c400ef473e00c680ea713a66196b05870b3710 upstream.

Fix the same alignment bug as in arm64 - we need to pass residue
unprocessed bytes as the last argument to blkcipher_walk_done.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/crypto/aesbs-glue.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -137,7 +137,7 @@ static int aesbs_cbc_encrypt(struct blkc
 				dst += AES_BLOCK_SIZE;
 			} while (--blocks);
 		}
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -158,7 +158,7 @@ static int aesbs_cbc_decrypt(struct blkc
 		bsaes_cbc_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	while (walk.nbytes) {
 		u32 blocks = walk.nbytes / AES_BLOCK_SIZE;
@@ -182,7 +182,7 @@ static int aesbs_cbc_decrypt(struct blkc
 			dst += AES_BLOCK_SIZE;
 			src += AES_BLOCK_SIZE;
 		} while (--blocks);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -268,7 +268,7 @@ static int aesbs_xts_encrypt(struct blkc
 		bsaes_xts_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->enc, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
@@ -292,7 +292,7 @@ static int aesbs_xts_decrypt(struct blkc
 		bsaes_xts_decrypt(walk.src.virt.addr, walk.dst.virt.addr,
 				  walk.nbytes, &ctx->dec, walk.iv);
 		kernel_neon_end();
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = blkcipher_walk_done(desc, &walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }


