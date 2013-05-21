Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3EUOIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:08:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32930 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3EUOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:08:19 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linus.walleij@linaro.org>
CC: <nsekhar@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <prabhakar.csengg@gmail.com>, <peter.ujfalusi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH 2/3] pinctrl: pinctrl-single: pin names for pinctrl-single.bits
Date: Tue, 21 May 2013 19:38:01 +0530
Message-ID: <1369145282-14419-4-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take care to name pin names as
register-offset.bit-pos-of-pin-in-register in case configuring multiple
pins in register.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
 drivers/pinctrl/pinctrl-single.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 9a1ea65..2899c86 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -30,7 +30,7 @@
 #define DRIVER_NAME			"pinctrl-single"
 #define PCS_MUX_PINS_NAME		"pinctrl-single,pins"
 #define PCS_MUX_BITS_NAME		"pinctrl-single,bits"
-#define PCS_REG_NAME_LEN		((sizeof(unsigned long) * 2) + 1)
+#define PCS_REG_NAME_LEN		((sizeof(unsigned long) * 2) + 3)
 #define PCS_OFF_DISABLED		~0U
 
 /**
@@ -744,7 +744,8 @@ static const struct pinconf_ops pcs_pinconf_ops = {
  * @pcs: pcs driver instance
  * @offset: register offset from base
  */
-static int pcs_add_pin(struct pcs_device *pcs, unsigned offset)
+static int pcs_add_pin(struct pcs_device *pcs, unsigned offset,
+		unsigned pin_pos)
 {
 	struct pinctrl_pin_desc *pin;
 	struct pcs_name *pn;
@@ -759,8 +760,8 @@ static int pcs_add_pin(struct pcs_device *pcs, unsigned offset)
 
 	pin = &pcs->pins.pa[i];
 	pn = &pcs->names[i];
-	sprintf(pn->name, "%lx",
-		(unsigned long)pcs->res->start + offset);
+	sprintf(pn->name, "%lx.%d",
+		(unsigned long)pcs->res->start + offset, pin_pos);
 	pin->name = pn->name;
 	pin->number = i;
 	pcs->pins.cur++;
@@ -780,12 +781,14 @@ static int pcs_add_pin(struct pcs_device *pcs, unsigned offset)
 static int pcs_allocate_pin_table(struct pcs_device *pcs)
 {
 	int mux_bytes, nr_pins, i;
+	int num_pins_in_register = 0;
 
 	mux_bytes = pcs->width / BITS_PER_BYTE;
 
 	if (pcs->bits_per_mux) {
 		pcs->bits_per_pin = fls(pcs->fmask);
 		nr_pins = (pcs->size * BITS_PER_BYTE) / pcs->bits_per_pin;
+		num_pins_in_register = pcs->width / pcs->bits_per_pin;
 	} else {
 		nr_pins = pcs->size / mux_bytes;
 	}
@@ -810,14 +813,16 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 		unsigned offset;
 		int res;
 		int byte_num;
+		int pin_pos = 0;
 
 		if (pcs->bits_per_mux) {
 			byte_num = (pcs->bits_per_pin * i) / BITS_PER_BYTE;
 			offset = (byte_num / mux_bytes) * mux_bytes;
+			pin_pos = i % num_pins_in_register;
 		} else {
 			offset = i * mux_bytes;
 		}
-		res = pcs_add_pin(pcs, offset);
+		res = pcs_add_pin(pcs, offset, pin_pos);
 		if (res < 0) {
 			dev_err(pcs->dev, "error adding pins: %i\n", res);
 			return res;
-- 
1.7.4.1

