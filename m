Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3LWRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:11:55 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45245 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3LWRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:11:53 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org, Danke Xie <d.xie@sta.samsung.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2] mfd: twl6030: Fix endianness problem in IRQ handler
Date: Mon, 23 Dec 2013 19:11:46 +0200
Message-Id: <1387818706-6129-1-git-send-email-taras.kondratiuk@linaro.org>
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
v2: fixed sparse warning
v1: https://patchwork.kernel.org/patch/2974331/

drivers/mfd/twl6030-irq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 517eda8..18a607e 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -176,8 +176,9 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
 	int i, ret;
 	union {
 		u8 bytes[4];
-		u32 int_sts;
+		__le32 int_sts;
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

