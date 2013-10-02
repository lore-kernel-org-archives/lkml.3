Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3JBLKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:10:30 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48622 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3JBLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:10:27 -0400
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-networking@linaro.org, Danke Xie <d.xie@sta.samsung.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Subject: [PATCH] mfd: twl6030: Fix endianness problem in IRQ handler
Date: Wed,  2 Oct 2013 14:08:44 +0300
Message-Id: <1380712124-20666-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danke Xie <d.xie@sta.samsung.com>

The current TWL 6030 IRQ handler assumes little endianness.
This change makes it endian-neutral.

Signed-off-by: Danke Xie <d.xie@sta.samsung.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/mfd/twl6030-irq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 517eda8..1941dc6 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -178,6 +178,7 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 		u8 bytes[4];
 		u32 int_sts;
 	} sts;
+	u32 int_sts; /* sts.int_sts converted to CPU endianness */
 	struct twl6030_irq *pdata = data;
 
 	/* read INT_STS_A, B and C in one shot using a burst read */
@@ -196,8 +197,9 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 	if (sts.bytes[2] & 0x10)
 		sts.bytes[2] |= 0x08;
 
-	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
-		if (sts.int_sts & 0x1) {
+	int_sts = le32_to_cpu(sts.int_sts);
+	for (i = 0; int_sts; int_sts >>= 1, i++)
+		if (int_sts & 0x1) {
 			int module_irq =
 				irq_find_mapping(pdata->irq_domain,
 						 pdata->irq_mapping_tbl[i]);
-- 
1.7.9.5

