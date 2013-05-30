Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab3E3P7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:59:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44520 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469Ab3E3P7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:59:48 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] spi: fix undefined behaviour in SPI_BPW_RANGE_MASK
Date: Thu, 30 May 2013 09:59:39 -0600
Message-Id: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The parameters to SPI_BPW_RANGE_MASK() are in the range 1..32. If 32 is
used as a parameter, part of the expression is "1 << 32". Since 32 is >=
the size of the type in use, such a shift is undefined behaviour. Add
macro SPI_BIT_MASK to Implement a special case and thus avoid undefined
behaviour. Use this new macro rather than BIT() when implementing
SPI_BPW_RANGE_MASK().

This fixes build warnings such as:
drivers/spi/spi-gpio.c:446:2: warning: left shift count >= width of type [enabled by default]

SPI_BPW_MASK() already avoids this, since its parameter is also in range
1..32, yet it only shifts by up to one less than the input parameter.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/spi/spi.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 1737256..3e94791 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -309,7 +309,8 @@ struct spi_master {
 	/* bitmask of supported bits_per_word for transfers */
 	u32			bits_per_word_mask;
 #define SPI_BPW_MASK(bits) BIT((bits) - 1)
-#define SPI_BPW_RANGE_MASK(min, max) ((BIT(max) - 1) - (BIT(min) - 1))
+#define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0UL : (BIT(bits) - 1))
+#define SPI_BPW_RANGE_MASK(min, max) (SPI_BIT_MASK(max) - SPI_BIT_MASK(min))
 
 	/* other constraints relevant to this driver */
 	u16			flags;
-- 
1.7.10.4

