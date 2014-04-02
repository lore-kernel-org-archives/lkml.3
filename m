Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbaDBDDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 23:03:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:30366 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbaDBDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 23:03:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>, <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH resend] regmap: mmio: Fix the bug of 'offset' value parsing.
Date: Wed, 2 Apr 2014 10:20:17 +0800
Message-ID: <1396405217-12658-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'offset = *(u32 *)reg;'
This will be okey for 32/64-bits register device, but for 8/16-bits
register ones, the 'offset' value will overflow, for example:

The IMX2 Watchdog, whose registers and values are all 16-bits:

If the IO base virtual address is ctx->regs = 0x888c0000, and the now
doing the 0x00 register accessing:
Using 'offset = *(u32 *)reg' the offset value will possiblly be 0x77310000,
Using 'offset = *(u16 *)reg' the offset value will be 0x0000.

In the regmap_mmio_gather_write(), ctx->regs + 0x7731000 will be 0xffbd0000,
but actually it should be ctx->regs + 0x0000 = 0x888c0000.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-mmio.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index de45a1e..e1b42c5 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -67,12 +67,31 @@ static inline void regmap_mmio_count_check(size_t count)
 	BUG_ON(count % 2 != 0);
 }
 
+static inline unsigned int
+regmap_mmio_get_offset(const void *reg, size_t reg_size)
+{
+	switch (reg_size) {
+	case 1:
+		return *(u8 *)reg;
+	case 2:
+		return *(u16 *)reg;
+	case 4:
+		return *(u32 *)reg;
+#ifdef CONFIG_64BIT
+	case 8:
+		return *(u64 *)reg;
+#endif
+	default:
+		BUG();
+	}
+}
+
 static int regmap_mmio_gather_write(void *context,
 				    const void *reg, size_t reg_size,
 				    const void *val, size_t val_size)
 {
 	struct regmap_mmio_context *ctx = context;
-	u32 offset;
+	unsigned int offset;
 	int ret;
 
 	regmap_mmio_regsize_check(reg_size);
@@ -83,7 +102,7 @@ static int regmap_mmio_gather_write(void *context,
 			return ret;
 	}
 
-	offset = *(u32 *)reg;
+	offset = regmap_mmio_get_offset(reg, reg_size);
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
@@ -119,7 +138,7 @@ static int regmap_mmio_gather_write(void *context,
 static int regmap_mmio_write(void *context, const void *data, size_t count)
 {
 	struct regmap_mmio_context *ctx = context;
-	u32 offset = ctx->reg_bytes + ctx->pad_bytes;
+	unsigned int offset = ctx->reg_bytes + ctx->pad_bytes;
 
 	regmap_mmio_count_check(count);
 
@@ -132,7 +151,7 @@ static int regmap_mmio_read(void *context,
 			    void *val, size_t val_size)
 {
 	struct regmap_mmio_context *ctx = context;
-	u32 offset;
+	unsigned int offset;
 	int ret;
 
 	regmap_mmio_regsize_check(reg_size);
@@ -143,7 +162,7 @@ static int regmap_mmio_read(void *context,
 			return ret;
 	}
 
-	offset = *(u32 *)reg;
+	offset = regmap_mmio_get_offset(reg, reg_size);
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
-- 
1.8.4


