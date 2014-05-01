Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaEAJ55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54833 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaEAJ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/47] mtd: nand: stm_nand_bch: provide shared BCH operations
Date: Thu,  1 May 2014 10:56:29 +0100
Message-Id: <1398938214-17847-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including one for programming the BCH sequence, taking care not to
program two registers marked 'reserved' in the NANDi specification.
Failing to take this precaution results in an imprecise data exception
on ARM platforms. We also add an operation which waits on a completion
timeout (released by the IRQ handler).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 5be7889..40767b8 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -431,6 +431,34 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
 }
 
 /*
+ * BCH Operations
+ */
+static inline void bch_load_prog_cpu(struct nandi_controller *nandi,
+				     struct bch_prog *prog)
+{
+	uint32_t *src = (uint32_t *)prog;
+	uint32_t *dst = (uint32_t *)(nandi->base + NANDBCH_ADDRESS_REG_1);
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		/* Skip registers marked as "reserved" */
+		if (i != 11 && i != 14)
+			writel(*src, dst);
+		dst++;
+		src++;
+	}
+}
+
+static void bch_wait_seq(struct nandi_controller *nandi)
+{
+	int ret;
+
+	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);
+	if (!ret)
+		dev_err(nandi->dev, "BCH Seq timeout\n");
+}
+
+/*
  * Initialisation
  */
 static int bch_check_compatibility(struct nandi_controller *nandi,
-- 
1.8.3.2

