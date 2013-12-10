Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3LJIde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:33:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3LJIAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Glen <AGlen@bepmarine.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 19/52] can: c_can: dont call pm_runtime_get_sync() from interrupt context
Date: Tue, 10 Dec 2013 00:00:52 -0800
Message-Id: <20131210075955.553610457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -712,22 +712,31 @@ static int c_can_set_mode(struct net_dev
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
@@ -872,7 +881,7 @@ static int c_can_handle_state_change(str
 	if (unlikely(!skb))
 		return 0;
 
-	c_can_get_berr_counter(dev, &bec);
+	__c_can_get_berr_counter(dev, &bec);
 	reg_err_counter = priv->read_reg(priv, C_CAN_ERR_CNT_REG);
 	rx_err_passive = (reg_err_counter & ERR_CNT_RP_MASK) >>
 				ERR_CNT_RP_SHIFT;


