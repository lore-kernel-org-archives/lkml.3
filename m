Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaEAKEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:04:34 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51604 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaEAJ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/47] mtd: nand: stm_nand_bch: check erased page for zeros
Date: Thu,  1 May 2014 10:56:31 +0100
Message-Id: <1398938214-17847-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect an erased page, tolerating and correcting up to a specified number
of bits at '0'. Downgrade uncorrectable ECC error for an erased page,
tolerating 'sectors_per_page' bits at '0'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 6d7ab79..2ff72c9 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -486,6 +486,33 @@ static uint8_t bch_erase_block(struct nandi_controller *nandi,
 }
 
 /*
+ * Detect an erased page, tolerating and correcting up to a specified number of
+ * bits at '0'.  (For many devices, it is now deemed within spec for an erased
+ * page to include a number of bits at '0', either as a result of read-disturb
+ * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
+ * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
+ * to be a genuine uncorrectable ECC error).  In the latter case, the data must
+ * be returned unmodified, in accordance with the MTD API.
+ */
+static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
+{
+	uint8_t *b = data;
+	int zeros = 0;
+	int i;
+
+	for (i = 0; i < page_size; i++) {
+		zeros += hweight8(~*b++);
+		if (zeros > max_zeros)
+			return -1;
+	}
+
+	if (zeros)
+		memset(data, 0xff, page_size);
+
+	return zeros;
+}
+
+/*
  * Initialisation
  */
 static int bch_check_compatibility(struct nandi_controller *nandi,
-- 
1.8.3.2

