Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaKKLKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaKKLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Dueck <davidcdueck@googlemail.com>,
        Anthony Harivel <anthony.harivel@emtrion.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 064/170] can: at91_can: add missing prepare and unprepare of the clock
Date: Tue, 11 Nov 2014 11:07:03 +0000
Message-Id: <1415704129-12709-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dueck <davidcdueck@googlemail.com>

commit e77980e50bc2850599d4d9c0192b67a9ffd6daac upstream.

In order to make the driver work with the common clock framework, this patch
converts the clk_enable()/clk_disable() to
clk_prepare_enable()/clk_disable_unprepare(). While there, add the missing
error handling.

Signed-off-by: David Dueck <davidcdueck@googlemail.com>
Signed-off-by: Anthony Harivel <anthony.harivel@emtrion.de>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/at91_can.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index f07fa89b5fd5..05e1aa090add 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1123,7 +1123,9 @@ static int at91_open(struct net_device *dev)
 	struct at91_priv *priv = netdev_priv(dev);
 	int err;
 
-	clk_enable(priv->clk);
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
 
 	/* check or determine and set bittime */
 	err = open_candev(dev);
@@ -1149,7 +1151,7 @@ static int at91_open(struct net_device *dev)
  out_close:
 	close_candev(dev);
  out:
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	return err;
 }
@@ -1166,7 +1168,7 @@ static int at91_close(struct net_device *dev)
 	at91_chip_stop(dev, CAN_STATE_STOPPED);
 
 	free_irq(dev->irq, dev);
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	close_candev(dev);
 
-- 
2.1.0

