Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaDKGgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:36:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47373 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaDKGgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:36:35 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v2] spi: core: Increase timeout value
Date: Fri, 11 Apr 2014 12:06:28 +0530
Message-Id: <1397198188-8602-1-git-send-email-harinik@xilinx.com>
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
Considering acceptable latencies, this timeout can be set to a
value double the expected transfer plus 100 msecs.
This patch adds the same in the core.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v2 changes:
Decrease timeout - make it double of expected time + 100ms

---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 4eb9bf0..f01cbb4 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -775,7 +775,7 @@ static int spi_transfer_one_message(struct spi_master *master,
 		if (ret > 0) {
 			ret = 0;
 			ms = xfer->len * 8 * 1000 / xfer->speed_hz;
-			ms += 10; /* some tolerance */
+			ms += ms + 100; /* some tolerance */
 
 			ms = wait_for_completion_timeout(&master->xfer_completion,
 							 msecs_to_jiffies(ms));
-- 
1.7.9.5

