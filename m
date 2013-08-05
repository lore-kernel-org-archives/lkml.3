Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3HETKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:10:51 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41086 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3HETKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:10:49 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bigeasy@linutronix.de, zubair.lutfullah@gmail.com
Subject: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Date: Mon,  5 Aug 2013 20:10:45 +0100
Message-Id: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg_cache variable is used to lock step enable register
from being accessed and written by both TSC and ADC
at the same time.
However, it isn't updated anywhere in the code at all.

If both TSC and ADC are used, eventually 1FFFF is always
written enabling all 16 steps uselessly causing a mess.

Patch fixes it by correcting the locks and updates the
variable by reading the step enable register

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index cd74d59..9f3f07a 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -57,10 +57,10 @@ EXPORT_SYMBOL_GPL(am335x_tsc_se_update);
 void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock(&tsadc->reg_lock);
+	tsadc->reg_se_cache = tscadc_readl(tsadc, REG_SE);
 	tsadc->reg_se_cache |= val;
-	spin_unlock(&tsadc->reg_lock);
-
 	am335x_tsc_se_update(tsadc);
+	spin_unlock(&tsadc->reg_lock);
 }
 EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
 
-- 
1.7.9.5

