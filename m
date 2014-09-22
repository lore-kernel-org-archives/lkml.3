Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIVHps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:45:48 -0400
Received: from sonata.ens-lyon.org ([140.77.166.138]:33698 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaIVHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:45:46 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 03:45:45 EDT
Date: Mon, 22 Sep 2014 09:37:26 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Kari Suvanto <kari.tj.suvanto@gmail.com>
Cc: "Hugh Dickins <hughd@google.com>Sabrina Dubroca" <sd@queasysnail.net>,
        Valdis.Kletnieks@vt.edu, Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Message-ID: <20140922073726.GQ3349@type.wlan.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Kari Suvanto <kari.tj.suvanto@gmail.com>,
	"Hugh Dickins <hughd@google.com>Sabrina Dubroca" <sd@queasysnail.net>,
	Valdis.Kletnieks@vt.edu, Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <541FD018.107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541FD018.107@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kari Suvanto, le Mon 22 Sep 2014 10:30:32 +0300, a écrit :
> >Ew. I'll have a look.
> 
> Any update on this one?

I have already sent it, yes, on Tue, 26 Aug 2014 11:17:25 +0200, here it
is again.

Samuel

Subject: [PATCHv2][input-led] Defer input led work to workqueue

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

---

Difference with v1: uses schedule_work instead of its own workqueue.

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

