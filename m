Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaEPOZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:25:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaEPOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:25:42 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] regmap: mmio: Fix regmap_mmio_write for uneven counts
Date: Fri, 16 May 2014 16:25:34 +0200
Message-Id: <1400250334-9397-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc0
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 932580409a9dacbf42215fa737bf06ae2c0aa624
"regmap: mmio: Add support for 1/2/8 bytes wide register address."
broke regmap_mmio_write for uneven counts, for example 32-bit register
addresses with no padding and 8-byte values (count = 5).
Fix this by allowing all counts large enough to include some value.
This check was BUG_ON(count < 4) before the last change.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Added missing offset parameter.
---
 drivers/base/regmap/regmap-mmio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 1e03e7f..902c4fb 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -61,9 +61,9 @@ static int regmap_mmio_regbits_check(size_t reg_bits)
 	}
 }
 
-static inline void regmap_mmio_count_check(size_t count)
+static inline void regmap_mmio_count_check(size_t count, u32 offset)
 {
-	BUG_ON(count % 2 != 0);
+	BUG_ON(count <= offset);
 }
 
 static int regmap_mmio_gather_write(void *context,
@@ -120,7 +120,7 @@ static int regmap_mmio_write(void *context, const void *data, size_t count)
 	struct regmap_mmio_context *ctx = context;
 	u32 offset = ctx->reg_bytes + ctx->pad_bytes;
 
-	regmap_mmio_count_check(count);
+	regmap_mmio_count_check(count, offset);
 
 	return regmap_mmio_gather_write(context, data, ctx->reg_bytes,
 					data + offset, count - offset);
-- 
2.0.0.rc0

