Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaBWRD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 12:03:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44664 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaBWRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:03:24 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        benjamin.tissoires@redhat.com,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] input: Use platform-provided devices as i8042 serio parents
Date: Sun, 23 Feb 2014 12:03:16 -0500
Message-Id: <1393174996-27764-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i8042 devices exposed via platform firmware interfaces such as ACPI or
Device Tree may provide additional information of use to userspace. Right
now we don't associate the serio devices with the firmware device, and so
there's no straightforward way for userspace to make use of that
information. This patch simply moves the serio parent device to the firmware
provided device.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/serio/i8042-sparcio.h   |  2 ++
 drivers/input/serio/i8042-x86ia64io.h |  2 ++
 drivers/input/serio/i8042.c           | 12 ++++++++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index d6aa4c6..7bd8e2c 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -65,6 +65,7 @@ static int sparc_i8042_probe(struct platform_device *op)
 			kbd_iobase = of_ioremap(&kbd->resource[0],
 						0, 8, "kbd");
 			kbd_res = &kbd->resource[0];
+			i8042_kbd_parent = &kbd->dev;
 		} else if (!strcmp(dp->name, OBP_PS2MS_NAME1) ||
 			   !strcmp(dp->name, OBP_PS2MS_NAME2)) {
 			struct platform_device *ms = of_find_device_by_node(dp);
@@ -72,6 +73,7 @@ static int sparc_i8042_probe(struct platform_device *op)
 			if (irq == 0xffffffff)
 				irq = op->archdata.irqs[0];
 			i8042_aux_irq = irq;
+			i8042_aux_parent = &ms->dev;
 		}
 
 		dp = dp->sibling;
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 0ec9abb..47dcdf1 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -723,6 +723,7 @@ static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	device_set_wakeup_enable(&dev->dev, true);
 
 	i8042_pnp_kbd_devices++;
+	i8042_kbd_parent = &dev->dev;
 	return 0;
 }
 
@@ -744,6 +745,7 @@ static int i8042_pnp_aux_probe(struct pnp_dev *dev, const struct pnp_device_id *
 	}
 
 	i8042_pnp_aux_devices++;
+	i8042_aux_parent = &dev->dev;
 	return 0;
 }
 
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 020053f..86da76f 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -87,6 +87,8 @@ MODULE_PARM_DESC(debug, "Turn i8042 debugging mode on and off");
 #endif
 
 static bool i8042_bypass_aux_irq_test;
+static struct device *i8042_kbd_parent;
+static struct device *i8042_aux_parent;
 
 #include "i8042.h"
 
@@ -1215,7 +1217,10 @@ static int __init i8042_create_kbd_port(void)
 	serio->stop		= i8042_stop;
 	serio->close		= i8042_port_close;
 	serio->port_data	= port;
-	serio->dev.parent	= &i8042_platform_device->dev;
+	if (i8042_kbd_parent)
+		serio->dev.parent	= i8042_kbd_parent;
+	else
+		serio->dev.parent	= &i8042_platform_device->dev;
 	strlcpy(serio->name, "i8042 KBD port", sizeof(serio->name));
 	strlcpy(serio->phys, I8042_KBD_PHYS_DESC, sizeof(serio->phys));
 
@@ -1240,7 +1245,10 @@ static int __init i8042_create_aux_port(int idx)
 	serio->start		= i8042_start;
 	serio->stop		= i8042_stop;
 	serio->port_data	= port;
-	serio->dev.parent	= &i8042_platform_device->dev;
+	if (i8042_aux_parent)
+		serio->dev.parent	= i8042_aux_parent;
+	else
+		serio->dev.parent	= &i8042_platform_device->dev;
 	if (idx < 0) {
 		strlcpy(serio->name, "i8042 AUX port", sizeof(serio->name));
 		strlcpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
-- 
1.8.5.3

