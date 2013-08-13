Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab3HMUGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:06:24 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41882 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759052Ab3HMUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:05:10 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: =?UTF-8?q?=5BPATCH=201/4=5D=20input=3A=20ti=5Fam335x=5Ftsc=3A=20correct=20step=20mask=20update=20after=20IRQ?=
Date: Tue, 13 Aug 2013 21:05:00 +0100
Message-Id: <1376424303-22740-2-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TSC steps should be enabled again after IRQ routine.
This fix ensures they are updated correctly every time.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index e1c5300..e165fcb 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -52,6 +52,7 @@ struct titsc {
 	u32			config_inp[4];
 	u32			bit_xp, bit_xn, bit_yp, bit_yn;
 	u32			inp_xp, inp_xn, inp_yp, inp_yn;
+	u32			step_mask;
 };
 
 static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
@@ -196,7 +197,8 @@ static void titsc_step_config(struct titsc *ts_dev)
 
 	/* The steps1 … end and bit 0 for TS_Charge */
 	stepenable = (1 << (end_step + 2)) - 1;
-	am335x_tsc_se_set(ts_dev->mfd_tscadc, stepenable);
+	ts_dev->step_mask = stepenable;
+	am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 }
 
 static void titsc_read_coordinates(struct titsc *ts_dev,
@@ -316,7 +318,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 
 	if (irqclr) {
 		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
-		am335x_tsc_se_update(ts_dev->mfd_tscadc);
+		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
 		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
-- 
1.7.9.5

