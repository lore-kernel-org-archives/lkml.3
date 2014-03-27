Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaC0FZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:25:20 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36647
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbaC0FZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:25:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/2] regmap: mmio: Add support for 1/2/8 bytes wide register address.
Date: Thu, 27 Mar 2014 12:42:43 +0800
Message-ID: <1395895363-31521-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1395895363-31521-1-git-send-email-Li.Xiubo@freescale.com>
References: <1395895363-31521-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regmap core and mmio have already support for 1/2/8 bytes wide values,
so adds support for 1/2/8 bytes wide registers address.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-mmio.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 4f1efce..ed080a4 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -26,18 +26,30 @@
 
 struct regmap_mmio_context {
 	void __iomem *regs;
+	unsigned reg_bytes;
 	unsigned val_bytes;
+	unsigned pad_bytes;
 	struct clk *clk;
 };
 
 static inline void regmap_mmio_regsize_check(size_t reg_size)
 {
-	BUG_ON(reg_size != 4);
+	switch (reg_size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef CONFIG_64BIT
+	case 8:
+#endif
+		break;
+	default:
+		BUG();
+	}
 }
 
 static inline void regmap_mmio_count_check(size_t count)
 {
-	BUG_ON(count < 4);
+	BUG_ON(count % 2 != 0);
 }
 
 static int regmap_mmio_gather_write(void *context,
@@ -91,9 +103,13 @@ static int regmap_mmio_gather_write(void *context,
 
 static int regmap_mmio_write(void *context, const void *data, size_t count)
 {
+	struct regmap_mmio_context *ctx = context;
+	u32 offset = ctx->reg_bytes + ctx->pad_bytes;
+
 	regmap_mmio_count_check(count);
 
-	return regmap_mmio_gather_write(context, data, 4, data + 4, count - 4);
+	return regmap_mmio_gather_write(context, data, ctx->reg_bytes,
+					data + offset, count - offset);
 }
 
 static int regmap_mmio_read(void *context,
@@ -219,6 +235,8 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(struct device *dev,
 
 	ctx->regs = regs;
 	ctx->val_bytes = config->val_bits / 8;
+	ctx->reg_bytes = config->reg_bits / 8;
+	ctx->pad_bytes = config->pad_bits / 8;
 	ctx->clk = ERR_PTR(-ENODEV);
 
 	if (clk_id == NULL)
-- 
1.8.4


