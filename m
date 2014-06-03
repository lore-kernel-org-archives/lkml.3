Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaFCHS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:18:26 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:6617 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbaFCHSZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:18:25 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'len.brown@intel.com'" <len.brown@intel.com>,
        "'pavel@ucw.cz'" <pavel@ucw.cz>, "'rjw@sisk.pl'" <rjw@sisk.pl>,
        "'linux-pm@vger.kernel.org'" <linux-pm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Tue, 3 Jun 2014 15:18:17 +0800
Subject: autosleep suspend too frquent problem
Thread-Topic: autosleep suspend too frquent problem
Thread-Index: Ac9++/3NXCWrWGSCR/KXZz7WgtQ7xQ==
Message-ID: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

I found sd card sometimes are damaged/ destroyed 
On our devices .
And seems it is caused by kernel's frequently suspend/resume,
Because during suspend/resume, the driver will suspend/resume sdcard
Very frequently, this will damaged the sdcard sometimes, and the damage
is not recoverable ..

Sometimes kernel will enter suspend and exit suspend very frequently,
Especially when the system is in idle, but some driver is not idle,
And it will  wake up the system by irq frequently.
By our power test result, if system enter suspend /resume very frequently,
Will consume more power , because it will enable /disable many devices
During a short time .

I make a patch to prevent the system to enter suspend/resume state
More than one time during 2 seconds：

diff --git a/kernel/power/autosleep.c b/kernel/power/autosleep.c
index ca304046..78fb06a 100644
--- a/kernel/power/autosleep.c
+++ b/kernel/power/autosleep.c
@@ -11,7 +15,7 @@
 #include <linux/pm_wakeup.h>

 #include "power.h"
-
+#define SUSPEND_TIME_SLICE (2 * HZ)
 static suspend_state_t autosleep_state;
 static struct workqueue_struct *autosleep_wq;
 /*
@@ -26,7 +30,8 @@ static struct wakeup_source *autosleep_ws;
 static void try_to_suspend(struct work_struct *work)
 {
        unsigned int initial_count, final_count;
-
+       int ret;
+       static unsigned long last_suspend_exit_time;
        if (!pm_get_wakeup_count(&initial_count, true))
                goto out;

@@ -43,8 +48,24 @@ static void try_to_suspend(struct work_struct *work)
        }
        if (autosleep_state >= PM_SUSPEND_MAX)
                hibernate();
-       else
-               pm_suspend(autosleep_state);
+       else {
+               if (last_suspend_exit_time == 0 ||
+                       time_after(jiffies,
+                               last_suspend_exit_time + SUSPEND_TIME_SLICE)) {
+suspend:
+                       ret = pm_suspend(autosleep_state);
+                       if (ret == 0)
+                               last_suspend_exit_time = jiffies;
+               } else {
+                       unsigned long sleep_time =
+                               SUSPEND_TIME_SLICE -
+                               (jiffies - last_suspend_exit_time);
+                       if (sleep_time > 0)
+                               schedule_timeout_uninterruptible(sleep_time);
+                       else
+                               goto suspend;
+               }
+       }

        mutex_unlock(&autosleep_lock);


seems works ok ,
my question is that should we change the autosleep module to make sure
not enter suspend/resume  in a short time,
or it is driver's problems? The driver should not wake up system
very frequently ?

Thanks



Wang Yalin
Engineer
OSDD
Sony Mobile Communications




