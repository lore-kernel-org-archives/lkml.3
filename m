Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3HNSYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:24:39 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:36305 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758610Ab3HNSXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:23:36 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v4 3/3] sata, highbank: send extra clock cycles in SGPIO patterns
Date: Wed, 14 Aug 2013 13:23:32 -0500
Message-Id: <1376504612-17340-3-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SGPIO PICs don't follow the standard very well and expect a certain
number of clock cycles or port frames in each SGPIO pattern. Add two
optional parameters in the DTB that can provide the number of extra
clock cycles to be sent before and after SGPIO pattern. Read those
parameters from the DTB and send the extra clock cycles.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
Changes from v3
	Renumbered the patch series since the first two got accepted.
Changes from v2
	None.
Changes from v1
	Added an example to the bindings.
	Forced the pre-clocks and post-clocks values to 0 if there is an
error while reading them or the values aren't in the DTB.

 Documentation/devicetree/bindings/ata/sata_highbank.txt |  6 ++++++
 drivers/ata/sata_highbank.c                             | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
index c84833e..aa83407 100644
--- a/Documentation/devicetree/bindings/ata/sata_highbank.txt
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -23,6 +23,10 @@ Optional properties:
 - calxeda,tx-atten  : a u32 array that contains TX attenuation override
 			codes, one per port. The upper 3 bytes are always
 			0 and thus ignored.
+- calxeda,pre-clocks : a u32 that indicates the number of additional clock
+			cycles to transmit before sending an SGPIO pattern
+- calxeda,post-clocks: a u32 that indicates the number of additional clock
+			cycles to transmit after sending an SGPIO pattern
 
 Example:
         sata@ffe08000 {
@@ -35,4 +39,6 @@ Example:
 		calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
 		calxeda,led-order = <4 0 1 2 3>;
 		calxeda,tx-atten = <0xff 22 0xff 0xff 23>;
+		calxeda,pre-clocks = <10>;
+		calxeda,post-clocks = <0>;
         };
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index a7c8038..7f5e5d9 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -84,6 +84,9 @@ static DEFINE_SPINLOCK(sgpio_lock);
 
 struct ecx_plat_data {
 	u32		n_ports;
+	/* number of extra clocks that the SGPIO PIC controller expects */
+	u32		pre_clocks;
+	u32		post_clocks;
 	unsigned	sgpio_gpio[SGPIO_PINS];
 	u32		sgpio_pattern;
 	u32		port_to_sgpio[SGPIO_PORTS];
@@ -160,6 +163,9 @@ static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
 	spin_lock_irqsave(&sgpio_lock, flags);
 	ecx_parse_sgpio(pdata, ap->port_no, state);
 	sgpio_out = pdata->sgpio_pattern;
+	for (i = 0; i < pdata->pre_clocks; i++)
+		ecx_led_cycle_clock(pdata);
+
 	gpio_set_value(pdata->sgpio_gpio[SLOAD], 1);
 	ecx_led_cycle_clock(pdata);
 	gpio_set_value(pdata->sgpio_gpio[SLOAD], 0);
@@ -172,6 +178,8 @@ static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
 		sgpio_out >>= 1;
 		ecx_led_cycle_clock(pdata);
 	}
+	for (i = 0; i < pdata->post_clocks; i++)
+		ecx_led_cycle_clock(pdata);
 
 	/* save off new led state for port/slot */
 	emp->led_state = state;
@@ -206,6 +214,11 @@ static void highbank_set_em_messages(struct device *dev,
 	of_property_read_u32_array(np, "calxeda,led-order",
 						pdata->port_to_sgpio,
 						pdata->n_ports);
+	if (of_property_read_u32(np, "calxeda,pre-clocks", &pdata->pre_clocks))
+		pdata->pre_clocks = 0;
+	if (of_property_read_u32(np, "calxeda,post-clocks",
+				&pdata->post_clocks))
+		pdata->post_clocks = 0;
 
 	/* store em_loc */
 	hpriv->em_loc = 0;
-- 
1.8.1.2

