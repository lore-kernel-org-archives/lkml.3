Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBNVe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:34:29 -0500
Received: from e2big.org ([198.61.226.133]:55487 "EHLO e2big.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaBNVe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:34:27 -0500
X-Greylist: delayed 2571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2014 16:34:27 EST
Date: Fri, 14 Feb 2014 21:51:26 +0100
From: Ulrik De Bie <ulrik.debie-os@e2big.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jonathan Aquilina <eagles051387@gmail.com>,
        Ulrik De Bie <ulrik_opensource-kernel@yahoo.com>
Subject: [PATCH] Input: Support in the elantech driver of the trackpoint
 present on for instance Lenovo L530
Message-ID: <20140214205126.GB15526@lantern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry it took me some time to have an email addres that would allow clean
mails. Below you can find the updated patch previously sent on linux-input
mailinglist. David Herrman asked to resent this patch as a proper git patch so
here it is now. 

It also available on https://github.com/ulrikdb/linux.git elantech_trackpoint
from commit 38dbfb59d1175ef458d006556061adeaa8751b72 (Linus 3.14-rc1) up to 
d69e103a35c944721966105790d14adf79098a4c 

Please when responding please send either to linux-input or put Ulrik De Bie <ulrik.debie-os@e2big.org> in CC:, Thanks.


The Lenovo L530 trackpoint does not work out of the box. It gives sync errors
as shown below when the trackpoint or trackpoint mouse buttons are pressed and
no input is received by userspace:
[   29.010641] psmouse serio1: Touchpad at isa0060/serio1/input0 lost sync at byte 6
The touchpad does work.

The alternative is to do a downgrade to generic ps/2 mouse (modprobe psmouse proto=bare)
but this has the disadvantage that touchpad can't be disabled (I want trackpoint, not touchpad).

With this patch, the trackpoint is provided as another input device; currently called 'TPPS/2 IBM TrackPoint'
The trackpoint now succesfully works and I can disable the touchpad with synclient TouchPadOff=1
The patch will also output messages that do not follow the expected pattern.
In the mean time I've seen 2 unknown packets occasionally:
0x04 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00
0x00 , 0x00 , 0x00 , 0x02 , 0x00 , 0x00
I don't know what those are for, but they can be safely ignored.

Currently all packets that are not known to v3 touchpad and where packet[3] (the fourth byte) lowest
nibble is 6 are now recognized as PACKET_TRACKPOINT and processed by the new elantech_report_trackpoint.

This has been verified to work on a laptop where the touchpad/trackpoint combined identify themselves as:
psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x350f02)
psmouse serio1: elantech: Synaptics capabilities query result 0xb9, 0x15, 0x0c.

Since I can't send clean email from yahoo, I've switched to a different email address: ulrik.debie-os@e2big.org
Signed-off-by: Ulrik De Bie <ulrik_opensource-kernel@yahoo.com>
Signed-off-by: Ulrik De Bie <ulrik.debie-os@e2big.org>

Signed-off-by: Ulrik De Bie <ulrik.debie-os@e2big.org>
---
 drivers/input/mouse/elantech.c | 78 +++++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/elantech.h |  3 ++
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index ef1cf52..21d693b 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -402,6 +402,54 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
 	input_sync(dev);
 }
 
+static void elantech_report_trackpoint(struct psmouse *psmouse,
+				       int packet_type)
+{
+	/* byte 0:  0   0 ~sx ~sy   0   M   R   L */
+	/* byte 1: sx   0   0   0   0   0   0   0 */
+	/* byte 2: sy   0   0   0   0   0   0   0 */
+	/* byte 3:  0   0  sy  sx   0   1   1   0 */
+	/* byte 4: x7  x6  x5  x4  x3  x2  x1  x0 */
+	/* byte 5: y7  y6  y5  y4  y3  y2  y1  y0 */
+
+	/*
+	 * x and y are written in two's complement spread
+	 * over 9 bits with sx/sy the relative top bit and
+	 * x7..x0 and y7..y0 the lower bits.
+	 * The sign of y is opposite to what the input driver
+	 * expects for a relative movement
+	 */
+
+	struct elantech_data *etd = psmouse->private;
+	struct input_dev *dev2 = etd->dev2;
+	unsigned char *packet = psmouse->packet;
+	int x, y;
+	input_report_key(dev2, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev2, BTN_RIGHT, packet[0] & 0x02);
+	input_report_key(dev2, BTN_MIDDLE, packet[0] & 0x04);
+	x = (s32) ((u32) ((packet[1] & 0x80) ? 0UL : 0xFFFFFF00UL) | (u32)
+		   packet[4]);
+	y = -(s32) ((u32) ((packet[2] & 0x80) ? 0UL : 0xFFFFFF00UL) | (u32)
+		    packet[5]);
+	input_report_rel(dev2, REL_X, x);
+	input_report_rel(dev2, REL_Y, y);
+	switch ((((u32) packet[0] & 0xF8) << 24) | ((u32) packet[1] << 16)
+		| (u32) packet[2] << 8 | (u32) packet[3]) {
+	case 0x00808036UL:
+	case 0x10008026UL:
+	case 0x20800016UL:
+	case 0x30000006UL:
+		break;
+	default:
+		/* Dump unexpected packet sequences if debug=1 (default) */
+		if (etd->debug == 1)
+			elantech_packet_dump(psmouse);
+		break;
+	}
+
+	input_sync(dev2);
+}
+
 /*
  * Interpret complete data packets and report absolute mode input events for
  * hardware version 3. (12 byte packets for two fingers)
@@ -700,8 +748,11 @@ static int elantech_packet_check_v3(struct psmouse *psmouse)
 
 		if ((packet[0] & 0x0c) == 0x0c && (packet[3] & 0xce) == 0x0c)
 			return PACKET_V3_TAIL;
+		if ((packet[3]&0x0f) == 0x06)
+			return PACKET_TRACKPOINT;
 	}
 
+
 	return PACKET_UNKNOWN;
 }
 
@@ -783,7 +834,10 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
 		if (packet_type == PACKET_UNKNOWN)
 			return PSMOUSE_BAD_DATA;
 
-		elantech_report_absolute_v3(psmouse, packet_type);
+		if (packet_type == PACKET_TRACKPOINT)
+			elantech_report_trackpoint(psmouse, packet_type);
+		else
+			elantech_report_absolute_v3(psmouse, packet_type);
 		break;
 
 	case 4:
@@ -1400,10 +1454,15 @@ int elantech_init(struct psmouse *psmouse)
 	struct elantech_data *etd;
 	int i, error;
 	unsigned char param[3];
+	struct input_dev *dev2;
 
 	psmouse->private = etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
 	if (!etd)
 		return -ENOMEM;
+	dev2 = input_allocate_device();
+	if (!dev2)
+		goto init_fail;
+	etd->dev2 = dev2;
 
 	psmouse_reset(psmouse);
 
@@ -1463,9 +1522,26 @@ int elantech_init(struct psmouse *psmouse)
 	psmouse->reconnect = elantech_reconnect;
 	psmouse->pktsize = etd->hw_version > 1 ? 6 : 4;
 
+	snprintf(etd->phys, sizeof(etd->phys), "%s/input1",
+		psmouse->ps2dev.serio->phys);
+	dev2->phys = etd->phys;
+	dev2->name = "TPPS/2 IBM TrackPoint";
+	dev2->id.bustype = BUS_I8042;
+	dev2->id.vendor  = 0x0002;
+	dev2->id.product = PSMOUSE_ELANTECH;
+	dev2->id.version = 0x0000;
+	dev2->dev.parent = &psmouse->ps2dev.serio->dev;
+	dev2->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
+	dev2->keybit[BIT_WORD(BTN_LEFT)] =
+		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+
+	if (input_register_device(etd->dev2))
+		goto init_fail;
 	return 0;
 
  init_fail:
+	input_free_device(dev2);
 	kfree(etd);
 	return -1;
 }
diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index 036a04a..27cf191 100644
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -94,6 +94,7 @@
 #define PACKET_V4_HEAD			0x05
 #define PACKET_V4_MOTION		0x06
 #define PACKET_V4_STATUS		0x07
+#define PACKET_TRACKPOINT		0x08
 
 /*
  * track up to 5 fingers for v4 hardware
@@ -114,6 +115,8 @@ struct finger_pos {
 };
 
 struct elantech_data {
+	struct input_dev *dev2;		/* Relative device */
+	char	phys[32];
 	unsigned char reg_07;
 	unsigned char reg_10;
 	unsigned char reg_11;
-- 
1.8.5.3

