Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3LSL4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3LSL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Glen <AGlen@bepmarine.com>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/208] can: c_can: don't call pm_runtime_get_sync() from interrupt context
Date: Thu, 19 Dec 2013 11:52:35 +0000
Message-Id: <1387454106-19326-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e35d46adc49b469fd92bdb64fea8af93640e6651 upstream.

The c_can driver contians a callpath (c_can_poll -> c_can_state_change ->
c_can_get_berr_counter) which may call pm_runtime_get_sync() from the IRQ
handler, which is not allowed and results in "BUG: scheduling while atomic".

This problem is fixed by introducing __c_can_get_berr_counter, which will not
call pm_runtime_get_sync().

Reported-by: Andrew Glen <AGlen@bepmarine.com>
Tested-by: Andrew Glen <AGlen@bepmarine.com>
Signed-off-by: Andrew Glen <AGlen@bepmarine.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/c_can/c_can.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index e3fc07c..e59c42b 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -712,22 +712,31 @@ static int c_can_set_mode(struct net_device *dev, enum can_mode mode)
 	return 0;
 }
 
-static int c_can_get_berr_counter(const struct net_device *dev,
-					struct can_berr_counter *bec)
+static int __c_can_get_berr_counter(const struct net_device *dev,
+				    struct can_berr_counter *bec)
 {
 	unsigned int reg_err_counter;
 	struct c_can_priv *priv = netdev_priv(dev);
 
-	c_can_pm_runtime_get_sync(priv);
-
 	reg_err_counter = priv->read_reg(priv, C_CAN_ERR_CNT_REG);
 	bec->rxerr = (reg_err_counter & ERR_CNT_REC_MASK) >>
 				ERR_CNT_REC_SHIFT;
 	bec->txerr = reg_err_counter & ERR_CNT_TEC_MASK;
 
+	return 0;
+}
+
+static int c_can_get_berr_counter(const struct net_device *dev,
+				  struct can_berr_counter *bec)
+{
+	struct c_can_priv *priv = netdev_priv(dev);
+	int err;
+
+	c_can_pm_runtime_get_sync(priv);
+	err = __c_can_get_berr_counter(dev, bec);
 	c_can_pm_runtime_put_sync(priv);
 
-	return 0;
+	return err;
 }
 
 /*
@@ -872,7 +881,7 @@ static int c_can_handle_state_change(struct net_device *dev,
 	if (unlikely(!skb))
 		return 0;
 
-	c_can_get_berr_counter(dev, &bec);
+	__c_can_get_berr_counter(dev, &bec);
 	reg_err_counter = priv->read_reg(priv, C_CAN_ERR_CNT_REG);
 	rx_err_passive = (reg_err_counter & ERR_CNT_RP_MASK) >>
 				ERR_CNT_RP_SHIFT;
-- 
1.8.3.2

