Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaKCIho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:37:44 -0500
Received: from domu-toccata.ens-lyon.fr ([140.77.166.138]:54175 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaKCIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:37:40 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 03:37:40 EST
Date: Mon, 3 Nov 2014 09:30:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] next: input: Fix build error seen if input-core is built
 as module
Message-ID: <20141103083046.GA10653@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	John Crispin <blogic@openwrt.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1414993997-19179-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414993997-19179-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Guenter Roeck, le Sun 02 Nov 2014 21:53:17 -0800, a écrit :
> The following build error may be seen if input-core is built as module:
> 
> drivers/input/leds.o: In function `init_module':
> leds.c:(.init.text+0x0): multiple definition of `init_module'
> drivers/input/input.o:input.c:(.init.text+0x0): first defined here
> drivers/input/leds.o: In function `cleanup_module':
> leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/input/input.o:input.c:(.exit.text+0x0): first defined here
> make[2]: *** [drivers/input/input-core.o] Error 1

I have already submitted a patch to fix it, here it is again:



Now that input/leds.c is compiled into the input.ko module in the mm
tree, its init and exit function must be called by input.ko's init and
exit functions, instead of duplicating the module init/exit hooks, which
leads to the following build error when input is built as a module:

leds.c:(.init.text+0x0): multiple definition of `init_module'
leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'

This also adds a proper clean of the vt_led_work queues in the exit
function.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---

This is a follow-up to the following reports:

Re: [next:master 9776/10302] leds.c:(.init.text+0x0): multiple definition of `init_module'
Re: [next:master 9391/10970] leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'

and to be applied over the existing
input-route-kbd-leds-through-the-generic-leds-layer-fix-2
please.

Thanks!
Samuel

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2427,6 +2427,8 @@ static int __init input_init(void)
 		goto fail2;
 	}
 
+	input_led_init();
+
 	return 0;
 
  fail2:	input_proc_exit();
@@ -2436,6 +2438,7 @@ static int __init input_init(void)
 
 static void __exit input_exit(void)
 {
+	input_led_exit();
 	input_proc_exit();
 	unregister_chrdev_region(MKDEV(INPUT_MAJOR, 0),
 				 INPUT_MAX_CHAR_DEVICES);
--- a/drivers/input/leds.c
+++ b/drivers/input/leds.c
@@ -255,22 +255,18 @@ void input_led_disconnect(struct input_d
 	mutex_unlock(&vt_led_registered_lock);
 }
 
-static int __init input_led_init(void)
+void __init input_led_init(void)
 {
 	unsigned i;
 
 	for (i = 0; i < LED_CNT; i++)
 		INIT_WORK(&vt_led_work[i], vt_led_cb);
-
-	return 0;
 }
 
-static void __exit input_led_exit(void)
+void __exit input_led_exit(void)
 {
-}
+	unsigned i;
 
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("User LED support for input layer");
-MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
-module_init(input_led_init);
-module_exit(input_led_exit);
+	for (i = 0; i < LED_CNT; i++)
+		cancel_work_sync(&vt_led_work[i]);
+}
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -536,11 +536,18 @@ int input_ff_create_memless(struct input
 
 #ifdef CONFIG_INPUT_LEDS
 
+void input_led_init(void);
+void input_led_exit(void);
+
 int input_led_connect(struct input_dev *dev);
 void input_led_disconnect(struct input_dev *dev);
 
 #else
 
+static inline void input_led_init(void) { }
+
+static inline void input_led_exit(void) { }
+
 static inline int input_led_connect(struct input_dev *dev)
 {
 	return 0;
