Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3BXUqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 15:46:33 -0500
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:54257
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755634Ab3BXUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 15:46:32 -0500
X-Greylist: delayed 1607 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2013 15:46:32 EST
From: Kevin Baradon <kevin.baradon@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 1/2] media/rc/imon.c: make send_packet() delay configurable
Date: Sun, 24 Feb 2013 21:19:29 +0100
Message-Id: <1361737170-4687-2-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
References: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some imon devices (like 15c2:0036) need a higher delay between send_packet calls.
Default value is still 5ms to avoid regressions on already working hardware.

Also use interruptible wait to avoid load average going too high (and let caller handle signals).

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 78d109b..a3e66a0 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -347,6 +347,11 @@ module_param(pad_stabilize, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD "
 		 "presses in arrow key mode. 0=disable, 1=enable (default).");
 
+static unsigned int send_packet_delay = 5;
+module_param(send_packet_delay, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(send_packet_delay, "Minimum delay between send_packet() calls "
+		 "(default 5ms)");
+
 /*
  * In certain use cases, mouse mode isn't really helpful, and could actually
  * cause confusion, so allow disabling it when the IR device is open.
@@ -535,12 +540,15 @@ static int send_packet(struct imon_context *ictx)
 	kfree(control_req);
 
 	/*
-	 * Induce a mandatory 5ms delay before returning, as otherwise,
+	 * Induce a mandatory delay before returning, as otherwise,
 	 * send_packet can get called so rapidly as to overwhelm the device,
 	 * particularly on faster systems and/or those with quirky usb.
+	 * Do not use TASK_UNINTERRUPTIBLE as this routine is called quite often
+	 * and doing so will increase load average slightly. Caller will handle
+	 * signals itself.
 	 */
-	timeout = msecs_to_jiffies(5);
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	timeout = msecs_to_jiffies(send_packet_delay);
+	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(timeout);
 
 	return retval;
-- 
1.7.10.4

