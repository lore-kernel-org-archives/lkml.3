Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaKCFx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:53:27 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:42752 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaKCFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:53:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        John Crispin <blogic@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] next: input: Fix build error seen if input-core is built as module
Date: Sun,  2 Nov 2014 21:53:17 -0800
Message-Id: <1414993997-19179-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54571855.0032,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build error may be seen if input-core is built as module:

drivers/input/leds.o: In function `init_module':
leds.c:(.init.text+0x0): multiple definition of `init_module'
drivers/input/input.o:input.c:(.init.text+0x0): first defined here
drivers/input/leds.o: In function `cleanup_module':
leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'
drivers/input/input.o:input.c:(.exit.text+0x0): first defined here
make[2]: *** [drivers/input/input-core.o] Error 1

leds.c is now part of input-core and can therefore not have its own
module initialization code. Initialize it from input.c instead.

Fixes: 6766fb48654c ("input: route kbd LEDs through the generic LEDs layer")
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: John Crispin <blogic@openwrt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Problem is seen in linux-next and mmotm.

I am perfectly fine if the patch is merged into the original patch,
or if a different fix for the problem is implemented, as long as it
gets fixed.

 drivers/input/input.c | 4 ++++
 drivers/input/leds.c  | 9 +++------
 drivers/input/leds.h  | 7 +++++++
 3 files changed, 14 insertions(+), 6 deletions(-)
 create mode 100644 drivers/input/leds.h

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 0ffaa87..20e3793 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include "input-compat.h"
+#include "leds.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
 MODULE_DESCRIPTION("Input core");
@@ -2428,6 +2429,8 @@ static int __init input_init(void)
 		goto fail2;
 	}
 
+	input_led_init();
+
 	return 0;
 
  fail2:	input_proc_exit();
@@ -2437,6 +2440,7 @@ static int __init input_init(void)
 
 static void __exit input_exit(void)
 {
+	input_led_exit();
 	input_proc_exit();
 	unregister_chrdev_region(MKDEV(INPUT_MAJOR, 0),
 				 INPUT_MAX_CHAR_DEVICES);
diff --git a/drivers/input/leds.c b/drivers/input/leds.c
index dca4a50..726570a 100644
--- a/drivers/input/leds.c
+++ b/drivers/input/leds.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/input.h>
+#include "leds.h"
 
 /*
  * Keyboard LEDs are propagated by default like the following example:
@@ -255,22 +256,18 @@ void input_led_disconnect(struct input_dev *dev)
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
 }
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for input layer");
 MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
-module_init(input_led_init);
-module_exit(input_led_exit);
diff --git a/drivers/input/leds.h b/drivers/input/leds.h
new file mode 100644
index 0000000..d341b6b
--- /dev/null
+++ b/drivers/input/leds.h
@@ -0,0 +1,7 @@
+#ifndef INPUT_LEDS_H
+#define INPUT_LEDS_H
+
+void input_led_init(void);
+void input_led_exit(void);
+
+#endif /* INPUT_LEDS_H */
-- 
1.9.1

