Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbaJIVKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIVJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Dueck <davidcdueck@googlemail.com>,
        Anthony Harivel <anthony.harivel@emtrion.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/163] can: at91_can: add missing prepare and unprepare of the clock
Date: Thu,  9 Oct 2014 14:02:29 -0700
Message-Id: <1412888588-26755-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/at91_can.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index cf0f63e..5e76a95 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1120,7 +1120,9 @@ static int at91_open(struct net_device *dev)
 	struct at91_priv *priv = netdev_priv(dev);
 	int err;
 
-	clk_enable(priv->clk);
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
 
 	/* check or determine and set bittime */
 	err = open_candev(dev);
@@ -1146,7 +1148,7 @@ static int at91_open(struct net_device *dev)
  out_close:
 	close_candev(dev);
  out:
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	return err;
 }
@@ -1163,7 +1165,7 @@ static int at91_close(struct net_device *dev)
 	at91_chip_stop(dev, CAN_STATE_STOPPED);
 
 	free_irq(dev->irq, dev);
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	close_candev(dev);
 
-- 
1.9.1

