Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaEPNnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:43:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaEPNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:43:37 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: mmio: Fix regmap_mmio_write for uneven counts
Date: Fri, 16 May 2014 15:43:29 +0200
Message-Id: <1400247809-17645-1-git-send-email-p.zabel@pengutronix.de>
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
 drivers/base/regmap/regmap-mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 1e03e7f..4f5725f 100644
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
-- 
2.0.0.rc0

