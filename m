Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbaFEAVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:21:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaFDXWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 132/228] Input: i8042 - add firmware_id support
Date: Wed,  4 Jun 2014 16:22:41 -0700
Message-Id: <20140604232352.259915582@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a7c5868c3482127cb308c779b8a6460a3353c17f upstream.

Fill in the new serio firmware_id sysfs attribute for pnp instantiated
8042 serio ports.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |   15 +++++++++++++++
 drivers/input/serio/i8042.c           |    6 ++++++
 2 files changed, 21 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -702,6 +702,17 @@ static int i8042_pnp_aux_irq;
 static char i8042_pnp_kbd_name[32];
 static char i8042_pnp_aux_name[32];
 
+static void i8042_pnp_id_to_string(struct pnp_id *id, char *dst, int dst_size)
+{
+	strlcpy(dst, "PNP:", dst_size);
+
+	while (id) {
+		strlcat(dst, " ", dst_size);
+		strlcat(dst, id->id, dst_size);
+		id = id->next;
+	}
+}
+
 static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 {
 	if (pnp_port_valid(dev, 0) && pnp_port_len(dev, 0) == 1)
@@ -718,6 +729,8 @@ static int i8042_pnp_kbd_probe(struct pn
 		strlcat(i8042_pnp_kbd_name, ":", sizeof(i8042_pnp_kbd_name));
 		strlcat(i8042_pnp_kbd_name, pnp_dev_name(dev), sizeof(i8042_pnp_kbd_name));
 	}
+	i8042_pnp_id_to_string(dev->id, i8042_kbd_firmware_id,
+			       sizeof(i8042_kbd_firmware_id));
 
 	/* Keyboard ports are always supposed to be wakeup-enabled */
 	device_set_wakeup_enable(&dev->dev, true);
@@ -742,6 +755,8 @@ static int i8042_pnp_aux_probe(struct pn
 		strlcat(i8042_pnp_aux_name, ":", sizeof(i8042_pnp_aux_name));
 		strlcat(i8042_pnp_aux_name, pnp_dev_name(dev), sizeof(i8042_pnp_aux_name));
 	}
+	i8042_pnp_id_to_string(dev->id, i8042_aux_firmware_id,
+			       sizeof(i8042_aux_firmware_id));
 
 	i8042_pnp_aux_devices++;
 	return 0;
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -87,6 +87,8 @@ MODULE_PARM_DESC(debug, "Turn i8042 debu
 #endif
 
 static bool i8042_bypass_aux_irq_test;
+static char i8042_kbd_firmware_id[128];
+static char i8042_aux_firmware_id[128];
 
 #include "i8042.h"
 
@@ -1218,6 +1220,8 @@ static int __init i8042_create_kbd_port(
 	serio->dev.parent	= &i8042_platform_device->dev;
 	strlcpy(serio->name, "i8042 KBD port", sizeof(serio->name));
 	strlcpy(serio->phys, I8042_KBD_PHYS_DESC, sizeof(serio->phys));
+	strlcpy(serio->firmware_id, i8042_kbd_firmware_id,
+		sizeof(serio->firmware_id));
 
 	port->serio = serio;
 	port->irq = I8042_KBD_IRQ;
@@ -1244,6 +1248,8 @@ static int __init i8042_create_aux_port(
 	if (idx < 0) {
 		strlcpy(serio->name, "i8042 AUX port", sizeof(serio->name));
 		strlcpy(serio->phys, I8042_AUX_PHYS_DESC, sizeof(serio->phys));
+		strlcpy(serio->firmware_id, i8042_aux_firmware_id,
+			sizeof(serio->firmware_id));
 		serio->close = i8042_port_close;
 	} else {
 		snprintf(serio->name, sizeof(serio->name), "i8042 AUX%d port", idx);


