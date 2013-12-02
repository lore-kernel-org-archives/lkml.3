Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab3LBVO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:14:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3LBTM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.10 027/173] i2c: mux: gpio: use reg value for i2c_add_mux_adapter
Date: Mon,  2 Dec 2013 11:10:10 -0800
Message-Id: <20131202191145.908691599@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -39,7 +39,7 @@ static int i2c_mux_gpio_select(struct i2
 {
 	struct gpiomux *mux = data;
 
-	i2c_mux_gpio_set(mux, mux->data.values[chan]);
+	i2c_mux_gpio_set(mux, chan);
 
 	return 0;
 }
@@ -223,7 +223,7 @@ static int i2c_mux_gpio_probe(struct pla
 		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
 
 		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
-						   i, class,
+						   mux->data.values[i], class,
 						   i2c_mux_gpio_select, deselect);
 		if (!mux->adap[i]) {
 			ret = -ENODEV;


