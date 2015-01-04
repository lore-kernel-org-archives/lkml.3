Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbbADGao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 01:30:44 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42379 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbbADGam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 01:30:42 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Peter Chen <Peter.Chen@freescale.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH RFC] usb: chipidea: add support for usb_phy in generic usb2
Date: Sun,  4 Jan 2015 08:28:32 +0200
Message-Id: <1f6e0195fcb215d8378db66bdd67900e57b9d290.1420351491.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/usb/chipidea/ci_hdrc_usb2.c | 5 +++++
 1 file changed, 5 insertions(+)

I'm sending this as RFC as I'm not sure this is the right thing to do. There
seems to be a move away from USB specific PHY drivers towards the generic PHY
framework (drivers/phy). The trouble is that my PHY is similar to the mxs PHY
(phy-mxs-usb.c), and like mxs I need the notify_connect/notify_disconnect
callbacks. This functionality is not available is the generic PHY
framework. Having support for both 'usb-phy' and 'phy' properties (as dwc3
seems to do) is particularly bad, since the distinction between the two is a
Linux implementation detail that has nothing to do with hardware description.

So my questions are:

   1. Is there a plan to add notifications support to the generic PHY?

   2. If not, what are my options?

Thanks,
baruch

diff --git a/drivers/usb/chipidea/ci_hdrc_usb2.c b/drivers/usb/chipidea/ci_hdrc_usb2.c
index 45844c951788..cc3aeb781a57 100644
--- a/drivers/usb/chipidea/ci_hdrc_usb2.c
+++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
@@ -35,11 +35,16 @@ static int ci_hdrc_usb2_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ci_hdrc_usb2_priv *priv;
 	struct ci_hdrc_platform_data *ci_pdata = dev_get_platdata(dev);
+	struct usb_phy *usb_phy;
 	int ret;
 
 	if (!ci_pdata)
 		ci_pdata = &ci_default_pdata;
 
+	usb_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
+	if (!IS_ERR(usb_phy))
+		ci_pdata->usb_phy = usb_phy;
+
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.1.4

