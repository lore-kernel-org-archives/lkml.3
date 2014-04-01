Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaDALQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaDALQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/144] can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
Date: Tue,  1 Apr 2014 12:13:55 +0100
Message-Id: <1396350948-29910-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 7e9e148af01ef388efb6e2490805970be4622792 upstream.

If flexcan_chip_start() in flexcan_open() fails, the interrupt is not freed,
this patch adds the missing cleanup.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index ce3ee69..394b2eb 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -860,7 +860,7 @@ static int flexcan_open(struct net_device *dev)
 	/* start chip and queuing */
 	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_close;
+		goto out_free_irq;
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
@@ -869,6 +869,8 @@ static int flexcan_open(struct net_device *dev)
 
 	return 0;
 
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
  out:
-- 
1.9.1

