Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbaICKOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:14:41 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57295 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755970AbaICJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 42/56] crypto: ux500 - make interrupt mode plausible
Date: Wed,  3 Sep 2014 11:27:01 +0200
Message-Id: <7a1b0c7591f6bb6a2d08eea93c20abaff2961d06.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e1f8859ee265fc89bd21b4dca79e8e983a044892 upstream.

The interrupt handler in the ux500 crypto driver has an obviously
incorrect way to access the data buffer, which for a while has
caused this build warning:

../ux500/cryp/cryp_core.c: In function 'cryp_interrupt_handler':
../ux500/cryp/cryp_core.c:234:5: warning: passing argument 1 of '__fswab32' makes integer from pointer without a cast [enabled by default]
     writel_relaxed(ctx->indata,
     ^
In file included from ../include/linux/swab.h:4:0,
                 from ../include/uapi/linux/byteorder/big_endian.h:12,
                 from ../include/linux/byteorder/big_endian.h:4,
                 from ../arch/arm/include/uapi/asm/byteorder.h:19,
                 from ../include/asm-generic/bitops/le.h:5,
                 from ../arch/arm/include/asm/bitops.h:340,
                 from ../include/linux/bitops.h:33,
                 from ../include/linux/kernel.h:10,
                 from ../include/linux/clk.h:16,
                 from ../drivers/crypto/ux500/cryp/cryp_core.c:12:
../include/uapi/linux/swab.h:57:119: note: expected '__u32' but argument is of type 'const u8 *'
 static inline __attribute_const__ __u32 __fswab32(__u32 val)

There are at least two, possibly three problems here:
a) when writing into the FIFO, we copy the pointer rather than the
   actual data we want to give to the hardware
b) the data pointer is an array of 8-bit values, while the FIFO
   is 32-bit wide, so both the read and write access fail to do
   a proper type conversion
c) This seems incorrect for big-endian kernels, on which we need to
   byte-swap any register access, but not normally FIFO accesses,
   at least the DMA case doesn't do it either.

This converts the bogus loop to use the same readsl/writesl pair
that we use for the two other modes (DMA and polling). This is
more efficient and consistent, and probably correct for endianess.

The bug has existed since the driver was first merged, and was
probably never detected because nobody tried to use interrupt mode.
It might make sense to backport this fix to stable kernels, depending
on how the crypto maintainers feel about that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-crypto@vger.kernel.org
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index a999f537228f..92105f3dc8e0 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -190,7 +190,7 @@ static void add_session_id(struct cryp_ctx *ctx)
 static irqreturn_t cryp_interrupt_handler(int irq, void *param)
 {
 	struct cryp_ctx *ctx;
-	int i;
+	int count;
 	struct cryp_device_data *device_data;
 
 	if (param == NULL) {
@@ -215,12 +215,11 @@ static irqreturn_t cryp_interrupt_handler(int irq, void *param)
 	if (cryp_pending_irq_src(device_data,
 				 CRYP_IRQ_SRC_OUTPUT_FIFO)) {
 		if (ctx->outlen / ctx->blocksize > 0) {
-			for (i = 0; i < ctx->blocksize / 4; i++) {
-				*(ctx->outdata) = readl_relaxed(
-						&device_data->base->dout);
-				ctx->outdata += 4;
-				ctx->outlen -= 4;
-			}
+			count = ctx->blocksize / 4;
+
+			readsl(&device_data->base->dout, ctx->outdata, count);
+			ctx->outdata += count;
+			ctx->outlen -= count;
 
 			if (ctx->outlen == 0) {
 				cryp_disable_irq_src(device_data,
@@ -230,12 +229,12 @@ static irqreturn_t cryp_interrupt_handler(int irq, void *param)
 	} else if (cryp_pending_irq_src(device_data,
 					CRYP_IRQ_SRC_INPUT_FIFO)) {
 		if (ctx->datalen / ctx->blocksize > 0) {
-			for (i = 0 ; i < ctx->blocksize / 4; i++) {
-				writel_relaxed(ctx->indata,
-						&device_data->base->din);
-				ctx->indata += 4;
-				ctx->datalen -= 4;
-			}
+			count = ctx->blocksize / 4;
+
+			writesl(&device_data->base->din, ctx->indata, count);
+
+			ctx->indata += count;
+			ctx->datalen -= count;
 
 			if (ctx->datalen == 0)
 				cryp_disable_irq_src(device_data,
-- 
2.1.0

