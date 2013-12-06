Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161446Ab3LFXsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:48:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161368Ab3LFXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ionut Nicu <ioan.nicu.ext@nsn.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 035/152] i2c: mux: gpio: use reg value for i2c_add_mux_adapter
Date: Fri,  6 Dec 2013 15:09:19 -0800
Message-Id: <1386371476-2477-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ionut Nicu <ioan.nicu.ext@nsn.com>

commit 8c0ec2500eeb89749341884a972860d7f9e56f9c upstream.

The i2c-mux driver requires that the chan_id parameter
passed to the i2c_add_mux_adapter() function is equal
to the reg value for that adapter:

for_each_child_of_node(mux_dev->of_node, child) {
	ret = of_property_read_u32(child, "reg", &reg);
	if (ret)
		continue;
	if (chan_id == reg) {
		priv->adap.dev.of_node = child;
		break;
	}
}

The i2c-mux-gpio driver uses an internal logical index
for chan_id when calling i2c_add_mux_adapter() instead
of using the reg value.

Because of this, there will problems in selecting the
right adapter when the i2c-mux-gpio's index into
mux->data.values doesn't match the reg value.

An example of such a case:

mux->data.values = { 1, 0 }

For chan_id = 0, i2c-mux will bind the adapter to the
of_node with reg = <0>, but when it will call the
select() callback with chan_id set to 0, the i2c-mux-gpio
will use it as an index into mux->data.values and it will
actually select the bus with reg = <1>.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
Acked-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 61da6b4..4c3db19 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -39,7 +39,7 @@ static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
 {
 	struct gpiomux *mux = data;
 
-	i2c_mux_gpio_set(mux, mux->data.values[chan]);
+	i2c_mux_gpio_set(mux, chan);
 
 	return 0;
 }
@@ -212,7 +212,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
 		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
-						   i, class,
+						   mux->data.values[i], class,
 						   i2c_mux_gpio_select, deselect);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;
-- 
1.8.3.2

