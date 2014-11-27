Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaK0Is7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:42334 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaK0Isz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:55 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Dueck <davidcdueck@googlemail.com>,
        Anthony Harivel <anthony.harivel@emtrion.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 58/91] can: at91_can: add missing prepare and unprepare of the clock
Date: Thu, 27 Nov 2014 16:42:41 +0800
Message-Id: <1417077794-9299-58-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Dueck <davidcdueck@googlemail.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit e77980e50bc2850599d4d9c0192b67a9ffd6daac upstream.

In order to make the driver work with the common clock framework, this patch
converts the clk_enable()/clk_disable() to
clk_prepare_enable()/clk_disable_unprepare(). While there, add the missing
error handling.

Signed-off-by: David Dueck <davidcdueck@googlemail.com>
Signed-off-by: Anthony Harivel <anthony.harivel@emtrion.de>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/at91_can.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 6ea905c..12328068 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1115,7 +1115,9 @@ static int at91_open(struct net_device *dev)
 	struct at91_priv *priv = netdev_priv(dev);
 	int err;
 
-	clk_enable(priv->clk);
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return err;
 
 	/* check or determine and set bittime */
 	err = open_candev(dev);
@@ -1139,7 +1141,7 @@ static int at91_open(struct net_device *dev)
  out_close:
 	close_candev(dev);
  out:
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	return err;
 }
@@ -1156,7 +1158,7 @@ static int at91_close(struct net_device *dev)
 	at91_chip_stop(dev, CAN_STATE_STOPPED);
 
 	free_irq(dev->irq, dev);
-	clk_disable(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	close_candev(dev);
 
-- 
1.9.1

