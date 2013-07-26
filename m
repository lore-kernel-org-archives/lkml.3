Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3GZP1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:27:23 -0400
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:50458 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3GZP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:27:19 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 5/5] sata, highbank: send extra clock cycles in SGPIO patterns
Date: Fri, 26 Jul 2013 10:11:58 -0500
Message-Id: <1374851518-4802-5-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SGPIO PICs don't follow the standard very well and expect a
certain number of clock cycles or port frames in each SGPIO pattern.
Add two optional parameters in the DTB that can provide the number of
extra clock cycles to be sent before and after each SGPIO pattern.
Read those parameters from the DTB and send the extra clock cycles.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 Documentation/devicetree/bindings/ata/sata_highbank.txt |  4 ++++
 drivers/ata/sata_highbank.c                             | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
index d692e9e..a05eb92 100644
--- a/Documentation/devicetree/bindings/ata/sata_highbank.txt
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -22,6 +22,10 @@ Optional properties:
 			SGPIO bitstream.
 - calxeda,tx-atten  : a u8 array that contains TX attenuation override
 			codes, one per port.
+- calxeda,pre-clocks : a u32 that indicates the number of additional clock
+			cycles to transmit before sending an SGPIO pattern
+- calxeda,post-clocks: a u32 that indicates the number of additional clock
+			cycles to transmit after sending an SGPIO pattern
 
 Example:
         sata@ffe08000 {
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 4c8444f..0ca27fe 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -82,9 +82,11 @@ static DEFINE_SPINLOCK(sgpio_lock);
 #define SGPIO_PINS			3
 #define SGPIO_PORTS			8
 
-/* can be cast as an ahci_host_priv for compatibility with most functions */
 struct ecx_plat_data {
 	u32		n_ports;
+	/* number of extra clocks that the SGPIO PIC controller expects */
+	u32		pre_clocks;
+	u32		post_clocks;
 	unsigned	sgpio_gpio[SGPIO_PINS];
 	u32		sgpio_pattern;
 	u32		port_to_sgpio[SGPIO_PORTS];
@@ -144,7 +146,7 @@ static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
 	struct ecx_plat_data *pdata = (struct ecx_plat_data *) hpriv->plat_data;
 	struct ahci_port_priv *pp = ap->private_data;
 	unsigned long flags;
-	int pmp, i;
+	int pmp, i, patt_len;
 	struct ahci_em_priv *emp;
 	u32 sgpio_out;
 
@@ -161,6 +163,9 @@ static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
 	spin_lock_irqsave(&sgpio_lock, flags);
 	ecx_parse_sgpio(pdata, ap->port_no, state);
 	sgpio_out = pdata->sgpio_pattern;
+	for (i = 0; i < pdata->pre_clocks; i++)
+		ecx_led_cycle_clock(pdata);
+
 	gpio_set_value(pdata->sgpio_gpio[SLOAD], 1);
 	ecx_led_cycle_clock(pdata);
 	gpio_set_value(pdata->sgpio_gpio[SLOAD], 0);
@@ -168,11 +173,14 @@ static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
 	 * bit-bang out the SGPIO pattern, by consuming a bit and then
 	 * clocking it out.
 	 */
-	for (i = 0; i < (SGPIO_SIGNALS * pdata->n_ports); i++) {
+	patt_len = SGPIO_SIGNALS * pdata->n_ports;
+	for (i = 0; i < patt_len; i++) {
 		gpio_set_value(pdata->sgpio_gpio[SDATA], sgpio_out & 1);
 		sgpio_out >>= 1;
 		ecx_led_cycle_clock(pdata);
 	}
+	for (i = 0; i < pdata->post_clocks; i++)
+		ecx_led_cycle_clock(pdata);
 
 	/* save off new led state for port/slot */
 	emp->led_state = state;
@@ -207,6 +215,8 @@ static void highbank_set_em_messages(struct device *dev,
 	of_property_read_u32_array(np, "calxeda,led-order",
 						pdata->port_to_sgpio,
 						pdata->n_ports);
+	of_property_read_u32(np, "calxeda,pre-clocks", &pdata->pre_clocks);
+	of_property_read_u32(np, "calxeda,post-clocks", &pdata->post_clocks);
 
 	/* store em_loc */
 	hpriv->em_loc = 0;
-- 
1.8.1.2

