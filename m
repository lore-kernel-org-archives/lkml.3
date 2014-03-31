Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaCaNtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:49:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaCaNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/71] can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
Date: Mon, 31 Mar 2014 14:22:20 +0100
Message-Id: <1396272197-13394-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 7e9e148af01ef388efb6e2490805970be4622792 upstream.

If flexcan_chip_start() in flexcan_open() fails, the interrupt is not freed,
this patch adds the missing cleanup.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 95109eb..8a5911f 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -813,12 +813,15 @@ static int flexcan_open(struct net_device *dev)
 	/* start chip and queuing */
 	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_close;
+		goto out_free_irq;
+
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
 	return 0;
 
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
  out:
-- 
1.9.1

