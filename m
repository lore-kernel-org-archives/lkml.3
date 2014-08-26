Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbaHZJRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:17:33 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:49134 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975AbaHZJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:17:31 -0400
Date: Tue, 26 Aug 2014 11:17:25 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCHv2][input-led] Defer input led work to workqueue
Message-ID: <20140826091725.GA23293@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
	Sabrina Dubroca <sd@queasysnail.net>, Valdis.Kletnieks@vt.edu,
	Vincent Donnefort <vdonnefort@gmail.com>,
	Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
