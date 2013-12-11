Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3LKGpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:45:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56858 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750774Ab3LKGpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:45:41 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH v2] usb: phy: initilize the notifier when add a new phy
Date: Wed, 11 Dec 2013 14:45:14 +0800
Message-ID: <1386744314-4824-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-11_02:2013-12-10,2013-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312100272
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to initilize the notifer before use it.
So lets initilize it when add a new phy device to reduce the code
redundance.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/phy/phy-ab8500-usb.c    |    2 --
 drivers/usb/phy/phy-generic.c       |    1 -
 drivers/usb/phy/phy-gpio-vbus-usb.c |    2 --
 drivers/usb/phy/phy-mxs-usb.c       |    2 --
 drivers/usb/phy/phy.c               |    4 ++++
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 0874023..11ab2c4 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -1415,8 +1415,6 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ab);
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&ab->phy.notifier);
-
 	/* all: Disable phy when called from set_host and set_peripheral */
 	INIT_WORK(&ab->phy_dis_work, ab8500_usb_phy_disable_work);
 
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index aa6d37b..bb39498 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -241,7 +241,6 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
 	nop->phy.otg->set_host		= nop_set_host;
 	nop->phy.otg->set_peripheral	= nop_set_peripheral;
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_phy_gen_create_phy);
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index 02799a5..69462e0 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -314,8 +314,6 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&gpio_vbus->phy.notifier);
-
 	INIT_DELAYED_WORK(&gpio_vbus->work, gpio_vbus_work);
 
 	gpio_vbus->vbus_draw = regulator_get(&pdev->dev, "vbus_draw");
diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index 545844b..9df81f0 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -160,8 +160,6 @@ static int mxs_phy_probe(struct platform_device *pdev)
 	mxs_phy->phy.notify_disconnect	= mxs_phy_on_disconnect;
 	mxs_phy->phy.type		= USB_PHY_TYPE_USB2;
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&mxs_phy->phy.notifier);
-
 	mxs_phy->clk = clk;
 
 	platform_set_drvdata(pdev, mxs_phy);
diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 1b74523..e6f61e4 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -329,6 +329,8 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
 		return -EINVAL;
 	}
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&x->notifier);
+
 	spin_lock_irqsave(&phy_lock, flags);
 
 	list_for_each_entry(phy, &phy_list, head) {
@@ -367,6 +369,8 @@ int usb_add_phy_dev(struct usb_phy *x)
 		return -EINVAL;
 	}
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&x->notifier);
+
 	spin_lock_irqsave(&phy_lock, flags);
 	list_for_each_entry(phy_bind, &phy_bind_list, list)
 		if (!(strcmp(phy_bind->phy_dev_name, dev_name(x->dev))))
-- 
1.7.9.5

