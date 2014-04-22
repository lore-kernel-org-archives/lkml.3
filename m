Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbaDVOFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:05:51 -0400
Received: from imap.devoid-pointer.net ([31.31.77.140]:49529 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbaDVOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:29 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 20/24] input: Port gamecon to ff-memless-next
Date: Tue, 22 Apr 2014 16:00:05 +0200
Message-Id: <1398175209-9565-21-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port gamecon to ff-memless-next

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
---
 drivers/input/joystick/Kconfig   |  2 +-
 drivers/input/joystick/gamecon.c | 57 ++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..2dd3ba1 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -221,7 +221,7 @@ config JOYSTICK_DB9
 config JOYSTICK_GAMECON
 	tristate "Multisystem, NES, SNES, N64, PSX joysticks and gamepads"
 	depends on PARPORT
-	select INPUT_FF_MEMLESS
+	select INPUT_FF_MEMLESS_NEXT
 	---help---
 	  Say Y here if you have a Nintendo Entertainment System gamepad,
 	  Super Nintendo Entertainment System gamepad, Nintendo 64 gamepad,
diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index e68e497..209d0fb 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -40,6 +40,7 @@
 #include <linux/input.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/input/ff-memless-next.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("NES, SNES, N64, MultiSystem, PSX gamepad driver");
@@ -47,6 +48,7 @@ MODULE_LICENSE("GPL");
 
 #define GC_MAX_PORTS		3
 #define GC_MAX_DEVICES		5
+#define FF_UPDATE_RATE 50
 
 struct gc_config {
 	int args[GC_MAX_DEVICES + 1];
@@ -263,43 +265,48 @@ static void gc_n64_process_packet(struct gc *gc)
 }
 
 static int gc_n64_play_effect(struct input_dev *dev, void *data,
-			      struct ff_effect *effect)
+			      const struct mlnx_effect_command *command)
 {
+	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
 	int i;
 	unsigned long flags;
 	struct gc *gc = input_get_drvdata(dev);
 	struct gc_subdev *sdev = data;
 	unsigned char target = 1 << sdev->idx; /* select desired pin */
+	unsigned int cmd;
 
-	if (effect->type == FF_RUMBLE) {
-		struct ff_rumble_effect *rumble = &effect->u.rumble;
-		unsigned int cmd =
-			rumble->strong_magnitude || rumble->weak_magnitude ?
-			GC_N64_CMD_01 : GC_N64_CMD_00;
+	switch (command->cmd) {
+	case MLNX_START_RUMBLE:
+		cmd = (rumble_force->strong || rumble_force->weak) ? GC_N64_CMD_01 : GC_N64_CMD_00;
+		break;
+	case MLNX_STOP_RUMBLE:
+		cmd = GC_N64_CMD_00;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-		local_irq_save(flags);
+	local_irq_save(flags);
 
-		/* Init Rumble - 0x03, 0x80, 0x01, (34)0x80 */
-		gc_n64_send_command(gc, GC_N64_CMD_03, target);
+	/* Init Rumble - 0x03, 0x80, 0x01, (34)0x80 */
+	gc_n64_send_command(gc, GC_N64_CMD_03, target);
+	gc_n64_send_command(gc, GC_N64_CMD_80, target);
+	gc_n64_send_command(gc, GC_N64_CMD_01, target);
+	for (i = 0; i < 32; i++)
 		gc_n64_send_command(gc, GC_N64_CMD_80, target);
-		gc_n64_send_command(gc, GC_N64_CMD_01, target);
-		for (i = 0; i < 32; i++)
-			gc_n64_send_command(gc, GC_N64_CMD_80, target);
-		gc_n64_send_stop_bit(gc, target);
+	gc_n64_send_stop_bit(gc, target);
 
-		udelay(GC_N64_DELAY);
-
-		/* Now start or stop it - 0x03, 0xc0, 0zx1b, (32)0x01/0x00 */
-		gc_n64_send_command(gc, GC_N64_CMD_03, target);
-		gc_n64_send_command(gc, GC_N64_CMD_c0, target);
-		gc_n64_send_command(gc, GC_N64_CMD_1b, target);
-		for (i = 0; i < 32; i++)
-			gc_n64_send_command(gc, cmd, target);
-		gc_n64_send_stop_bit(gc, target);
+	udelay(GC_N64_DELAY);
 
-		local_irq_restore(flags);
+	/* Now start or stop it - 0x03, 0xc0, 0zx1b, (32)0x01/0x00 */
+	gc_n64_send_command(gc, GC_N64_CMD_03, target);
+	gc_n64_send_command(gc, GC_N64_CMD_c0, target);
+	gc_n64_send_command(gc, GC_N64_CMD_1b, target);
+	for (i = 0; i < 32; i++)
+		gc_n64_send_command(gc, cmd, target);
+	gc_n64_send_stop_bit(gc, target);
 
-	}
+	local_irq_restore(flags);
 
 	return 0;
 }
@@ -317,7 +324,7 @@ static int __init gc_n64_init_ff(struct input_dev *dev, int i)
 
 	input_set_capability(dev, EV_FF, FF_RUMBLE);
 
-	err = input_ff_create_memless(dev, sdev, gc_n64_play_effect);
+	err = input_ff_create_mlnx(dev, sdev, gc_n64_play_effect, FF_UPDATE_RATE);
 	if (err) {
 		kfree(sdev);
 		return err;
-- 
1.9.2

