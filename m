Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbaDJMul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:50:41 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60712 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030665AbaDJMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:50:37 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH] spi: core: Increase timeout value
Date: Thu, 10 Apr 2014 18:20:29 +0530
Message-Id: <1397134229-2380-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing timeout value in wait_for_completion_timeout is
calculated from the transfer length and speed with tolerance of 10msec.
This is too low because this is used for error conditions such as
hardware hang etc.
The xfer->speed_hz considered may not be the actual speed set
because the best clock divisor is chosen from a limited set such that
the actual speed <= requested speed. This will lead to timeout being
less than actual transfer time.
Considering acceptable latencies, this timeout can be set to a large
value >= 1*HZ typically.
This patch adds a tolerance of 2000 msec in the core accordingly.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4eb9bf0..3fdecfa 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -775,7 +775,7 @@ static int spi_transfer_one_message(struct spi_master *master,
 		if (ret > 0) {
 			ret = 0;
 			ms = xfer->len * 8 * 1000 / xfer->speed_hz;
-			ms += 10; /* some tolerance */
+			ms += 2000; /* some tolerance */
 
 			ms = wait_for_completion_timeout(&master->xfer_completion,
 							 msecs_to_jiffies(ms));
-- 
1.7.9.5

