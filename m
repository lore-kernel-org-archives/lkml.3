Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KCN1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:27:30 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:37003 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3KCN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:27:29 -0500
Date: Sun, 3 Nov 2013 14:27:20 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org
Subject: Re: [next:master 23/358] undefined reference to
 `input_led_disconnect'
Message-ID: <20131103132720.GA16764@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
	jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org
References: <5275bf42.KMmrPUiia86VoRbL%fengguang.wu@intel.com>
 <20131103120853.GA1731@localhost>
 <20131103123621.GA9756@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131103123621.GA9756@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Sun 03 Nov 2013 13:36:21 +0100, a écrit :
> So in the end it would probably be simpler to just stuff leds.c along
> input.c in input.ko or built-in. CONFIG_INPUT_LEDS will thus become a
> bool.  I'm working on that now.

Here it is.  This replaces both
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch

(input-route-kbd-leds-through-the-generic-leds-layer-fix.patch is still
needed)

Samuel



Link input/leds.c along input/input.c instead of separate module

input.c needs to call leds.c and vice-versa, so it is simpler to stuff
them together. INPUT_LEDS thus now depends on LEDS_CLASS being available
enough for input.ko.

This also documents the new leds field.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff -u a/drivers/input/Makefile b/drivers/input/Makefile
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -6,6 +6,9 @@
 
 obj-$(CONFIG_INPUT)		+= input-core.o
 input-core-y := input.o input-compat.o input-mt.o ff-core.o
+ifeq ($(CONFIG_INPUT_LEDS),y)
+input-core-y += leds.o
+endif
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
@@ -16,7 +19,6 @@
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
 obj-$(CONFIG_INPUT_EVDEV)	+= evdev.o
 obj-$(CONFIG_INPUT_EVBUG)	+= evbug.o
-obj-$(CONFIG_INPUT_LEDS)	+= leds.o
 
 obj-$(CONFIG_INPUT_KEYBOARD)	+= keyboard/
 obj-$(CONFIG_INPUT_MOUSE)	+= mouse/
diff -u a/drivers/input/Kconfig b/drivers/input/Kconfig
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -179,8 +179,8 @@
 source "drivers/input/keyboard/Kconfig"
 
 config INPUT_LEDS
-	tristate "LED Support"
-	depends on LEDS_CLASS
+	bool "LED Support"
+	depends on LEDS_CLASS = INPUT || LEDS_CLASS = y
 	select LEDS_TRIGGERS
 	default y
 	help
diff -u a/include/linux/input.h b/include/linux/input.h
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -79,6 +79,7 @@
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
  * @sw: reflects current state of device's switches
+ * @leds: leds objects for the device's LEDs
  * @open: this method is called when the very first user calls
  *	input_open_device(). The driver must prepare the device
  *	to start generating events (start polling thread,
