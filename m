Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab3HTMPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:15:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:20225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3HTMPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:15:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,919,1367996400"; 
   d="scan'208";a="365495464"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: fix SPI_BIT_MASK() to use correct size for 32-bit transfer mask
Date: Tue, 20 Aug 2013 15:15:32 +0300
Message-Id: <1377000932-5438-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a 64-bit kernel we get the following warning from the
compiler:

 drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
 drivers/spi/spi-pxa2xx.c:1152:3: warning: large integer implicitly truncated to unsigned type [-Woverflow]
   master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
   ^
This is due the fact that when the max range is specified as 32
SPI_BIT_MASK() expands to ~0UL which doesn't fit to the u32 type that the
master->bits_per_word_mask is.

Fix this by using ~0U instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 include/linux/spi/spi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 28e440b..c920c2f 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -309,7 +309,7 @@ struct spi_master {
 	/* bitmask of supported bits_per_word for transfers */
 	u32			bits_per_word_mask;
 #define SPI_BPW_MASK(bits) BIT((bits) - 1)
-#define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0UL : (BIT(bits) - 1))
+#define SPI_BIT_MASK(bits) (((bits) == 32) ? ~0U : (BIT(bits) - 1))
 #define SPI_BPW_RANGE_MASK(min, max) (SPI_BIT_MASK(max) - SPI_BIT_MASK(min - 1))
 
 	/* other constraints relevant to this driver */
-- 
1.8.4.rc2

