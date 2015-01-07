Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbbAGVBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:01:44 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44555 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbAGVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:01:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-ide@vger.kernel.org
Subject: [PATCH][RFC] ide: pdc202xxx_new: Remove do_gettimeofday() usage for ktime_get
Date: Wed,  7 Jan 2015 13:01:33 -0800
Message-Id: <1420664493-7041-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the y2038 cleanups, this patch removes the do_gettimeofday
usage replacing it with ktime_get.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-ide@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/ide/pdc202xx_new.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/pdc202xx_new.c b/drivers/ide/pdc202xx_new.c
index df73cbd..94bd05f 100644
--- a/drivers/ide/pdc202xx_new.c
+++ b/drivers/ide/pdc202xx_new.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -243,13 +244,13 @@ static long read_counter(u32 dma_base)
  */
 static long detect_pll_input_clock(unsigned long dma_base)
 {
-	struct timeval start_time, end_time;
+	ktime_t start_time, end_time;
 	long start_count, end_count;
 	long pll_input, usec_elapsed;
 	u8 scr1;
 
 	start_count = read_counter(dma_base);
-	do_gettimeofday(&start_time);
+	start_time = ktime_get();
 
 	/* Start the test mode */
 	outb(0x01, dma_base + 0x01);
@@ -261,7 +262,7 @@ static long detect_pll_input_clock(unsigned long dma_base)
 	mdelay(10);
 
 	end_count = read_counter(dma_base);
-	do_gettimeofday(&end_time);
+	end_time = ktime_get();
 
 	/* Stop the test mode */
 	outb(0x01, dma_base + 0x01);
@@ -273,8 +274,7 @@ static long detect_pll_input_clock(unsigned long dma_base)
 	 * Calculate the input clock in Hz
 	 * (the clock counter is 30 bit wide and counts down)
 	 */
-	usec_elapsed = (end_time.tv_sec - start_time.tv_sec) * 1000000 +
-		(end_time.tv_usec - start_time.tv_usec);
+	usec_elapsed = (long)ktime_to_ns(ktime_sub(end_time, start_time))/1000;
 	pll_input = ((start_count - end_count) & 0x3fffffff) / 10 *
 		(10000000 / usec_elapsed);
 
-- 
1.9.1

