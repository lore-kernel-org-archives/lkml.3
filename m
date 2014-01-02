Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaABRSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:18:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaABRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Glen <AGlen@bepmarine.com>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 65/91] can: c_can: don't call pm_runtime_get_sync() from interrupt context
Date: Thu,  2 Jan 2014 09:04:40 -0800
Message-Id: <1388682306-30859-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/c_can/c_can.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 915847d..aa92283 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -709,22 +709,31 @@ static int c_can_set_mode(struct net_device *dev, enum can_mode mode)
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
@@ -868,7 +877,7 @@ static int c_can_handle_state_change(struct net_device *dev,
 	if (unlikely(!skb))
 		return 0;
 
-	c_can_get_berr_counter(dev, &bec);
+	__c_can_get_berr_counter(dev, &bec);
 	reg_err_counter = priv->read_reg(priv, C_CAN_ERR_CNT_REG);
 	rx_err_passive = (reg_err_counter & ERR_CNT_RP_MASK) >>
 				ERR_CNT_RP_SHIFT;
-- 
1.8.3.2

