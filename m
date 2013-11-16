Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3KPPlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:41:00 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50714 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3KPPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:40:41 -0500
Message-ID: <528791EF.9060505@koalo.de>
Date: Sat, 16 Nov 2013 16:40:31 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>
CC: linux-i2c@vger.kernel.org,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: Fallback to of_node of parent
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many busses (e.g. tegra, omap, bcm2835)
need to set the of_node of the adapter
device to the one of the parent device, i.e.

adap->dev.of_node = pdev->dev.of_node;

As suggested by Stephen Warren, this could also
be done in the i2c core and it is a common mistake
to forget this line:

I2C: BCM2835: Linking platform nodes to adapter nodes
i2c: Fix device tree binding for i2c-cbus-gpio

Signed-off-by: Florian Meier <florian.meier@koalo.de>
Suggested-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/i2c/i2c-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 430c001..c8e33a5 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1310,6 +1310,9 @@ int i2c_add_adapter(struct i2c_adapter *adapter)
 	struct device *dev = &adapter->dev;
 	int id;

+	if (!dev->of_node && dev->parent)
+		dev->of_node = dev->parent->of_node;
+
 	if (dev->of_node) {
 		id = of_alias_get_id(dev->of_node, "i2c");
 		if (id >= 0) {
-- 
1.7.9.5
