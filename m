Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaJAVjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:39:06 -0400
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:32888 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaJAVjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:39:03 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2014 17:39:03 EDT
Date: Wed, 1 Oct 2014 23:29:10 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20141001212910.GE9598@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20141001114257.f0f6a94508bdd7df83602eda@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141001114257.f0f6a94508bdd7df83602eda@linux-foundation.org>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Wed 01 Oct 2014 11:42:57 -0700, a écrit :
> On Mon, 31 Mar 2014 14:23:23 +0200 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > This permits to reassign keyboard LEDs to something else than keyboard "leds"
> > state, by adding keyboard led and modifier triggers connected to a series
> > of VT input LEDs, themselves connected to VT input triggers, which
> > per-input device LEDs use by default.  Userland can thus easily change the LED
> > behavior of (a priori) all input devices, or of particular input devices.
> > 
> > This also permits to fix #7063 from userland by using a modifier to implement
> > proper CapsLock behavior and have the keyboard caps lock led show that modifier
> > state.
> 
> When this patch is combined with current linux-next I'm getting the
> below lockdep splat.  Config: http://ozlabs.org/~akpm/config-akpm2.txt

Yes, this was reported and I sent a fix some time ago (Tue, 26 Aug 2014
11:17:25 +0200), here is the patch again:

Subject: Defer input led work to workqueue

When the kbd changes its led state (e.g. caps lock), this triggers
(led_trigger_event) the kbd-capsl trigger, which is by default
used by the vt::capsl LED, which triggers (led_trigger_event) the
vt-capsl trigger. These two nested led_trigger_event calls take a
trig->leddev_list_lock lock and thus lockdep complains.

Actually the user can make the vt::capsl LED use its own vt-capsl
trigger and thus build a loop.  This produces an immediate oops.

This changeset defers the second led_trigger_event call into a
workqueue, which avoids the nested locking altogether.  This does
not prevent the user from shooting himself in the foot by creating a
vt::capsl <-> vt-capsl loop, but the only consequence is the workqueue
threads eating some CPU until the user breaks the loop, which is not too
bad.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- a/drivers/input/leds.c
+++ b/drivers/input/leds.c
@@ -100,13 +100,24 @@ static unsigned long vt_led_registered[B
 /* Number of input devices having each LED */
 static int vt_led_references[LED_CNT];
 
+static int vt_led_state[LED_CNT];
+static struct work_struct vt_led_work[LED_CNT];
+
+static void vt_led_cb(struct work_struct *work)
+{
+	int led = work - vt_led_work;
+
+	led_trigger_event(&vt_led_triggers[led], vt_led_state[led]);
+}
+
 /* VT LED state change, tell the VT trigger.  */
 static void vt_led_set(struct led_classdev *cdev,
 			  enum led_brightness brightness)
 {
 	int led = cdev - vt_leds;
 
-	led_trigger_event(&vt_led_triggers[led], !!brightness);
+	vt_led_state[led] = !!brightness;
+	schedule_work(&vt_led_work[led]);
 }
 
 /* LED state change for some keyboard, notify that keyboard.  */
@@ -244,6 +255,22 @@ void input_led_disconnect(struct input_d
 	mutex_unlock(&vt_led_registered_lock);
 }
 
+static int __init input_led_init(void)
+{
+	unsigned i;
+
+	for (i = 0; i < LED_CNT; i++)
+		INIT_WORK(&vt_led_work[i], vt_led_cb);
+
+	return 0;
+}
+
+static void __exit input_led_exit(void)
+{
+}
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for input layer");
 MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
+module_init(input_led_init);
+module_exit(input_led_exit);

