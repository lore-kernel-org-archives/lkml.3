Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaH1NOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:49 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56864 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaH1NOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/11] mfd: twl4030-irq: Check return value from twl_i2c_write() - warn() on failure
Date: Thu, 28 Aug 2014 14:14:16 +0100
Message-Id: <1409231657-18294-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the original code a return value variable was provided, but it
was never checked and the user was never informed of failure.  Now
it is and they are.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-irq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index b1dabba..1b772ef 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -396,13 +396,17 @@ static int twl4030_init_sih_modules(unsigned line)
 			status = twl_i2c_read(sih->module, rxbuf,
 				sih->mask[line].isr_offset, sih->bytes_ixr);
 			if (status < 0)
-				pr_err("twl4030: err %d initializing %s %s\n",
+				pr_warn("twl4030: err %d initializing %s %s\n",
 					status, sih->name, "ISR");
 
-			if (!sih->set_cor)
+			if (!sih->set_cor) {
 				status = twl_i2c_write(sih->module, buf,
 					sih->mask[line].isr_offset,
 					sih->bytes_ixr);
+				if (status < 0)
+					pr_warn("twl4030: write failed: %d\n",
+						status);
+			}
 			/*
 			 * else COR=1 means read sufficed.
 			 * (for most SIH modules...)
-- 
1.9.1

