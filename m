Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaE0RaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:30:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34488 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaE0R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:28:56 -0400
Message-ID: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>
Date: Tue, 27 May 2014 10:28:55 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

zswap allocates one LZO context per online cpu.

Using vmalloc() for small (16KB) memory areas has drawback of slowing
down /proc/vmallocinfo and /proc/meminfo reads, TLB pressure and poor
NUMA locality, as default NUMA policy at boot time is to interleave
pages :

edumazet:~# grep lzo /proc/vmallocinfo | head -4
0xffffc90006062000-0xffffc90006067000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
0xffffc90006067000-0xffffc9000606c000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
0xffffc9000606c000-0xffffc90006071000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
0xffffc90006071000-0xffffc90006076000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2

This patch tries a regular kmalloc() and fallback to vmalloc in case
memory is too fragmented.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 crypto/lzo.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 1c2aa69c54b8..252e791d0ccc 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/lzo.h>
 
 struct lzo_ctx {
@@ -30,7 +31,10 @@ static int lzo_init(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->lzo_comp_mem = vmalloc(LZO1X_MEM_COMPRESS);
+	ctx->lzo_comp_mem = kmalloc(LZO1X_MEM_COMPRESS,
+				    GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+	if (!ctx->lzo_comp_mem)
+		ctx->lzo_comp_mem = vmalloc(LZO1X_MEM_COMPRESS);
 	if (!ctx->lzo_comp_mem)
 		return -ENOMEM;
 
@@ -41,7 +45,10 @@ static void lzo_exit(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	vfree(ctx->lzo_comp_mem);
+	if (is_vmalloc_addr(ctx->lzo_comp_mem))
+		vfree(ctx->lzo_comp_mem);
+	else
+		kfree(ctx->lzo_comp_mem);
 }
 
 static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,


