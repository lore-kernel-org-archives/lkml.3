Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3A2B7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:59:07 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:60254 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598Ab3A2B7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 1/6] staging/fwserial: Remove bandwidth limit logic
Date: Mon, 28 Jan 2013 20:57:44 -0500
Message-Id: <1359424669-5723-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
References: <20130107232206.GA15244@kroah.com>
 <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Self-limiting asynchronous bandwidth (via reducing the payload)
is not necessary and does not work, because
 1) asynchronous traffic will absorb all available bandwidth (less that
    being used for isochronous traffic)
 2) isochronous arbitration always wins.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c |  3 ---
 drivers/staging/fwserial/fwserial.h | 15 ++++++---------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index e5e8f2f..233bb56 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -40,12 +40,10 @@ static int num_ttys = 4;	    /* # of std ttys to create per fw_card    */
 				    /* - doubles as loopback port index       */
 static bool auto_connect = true;    /* try to VIRT_CABLE to every peer        */
 static bool create_loop_dev = true; /* create a loopback device for each card */
-bool limit_bw;			    /* limit async bandwidth to 20% of max    */
 
 module_param_named(ttys, num_ttys, int, S_IRUGO | S_IWUSR);
 module_param_named(auto, auto_connect, bool, S_IRUGO | S_IWUSR);
 module_param_named(loop, create_loop_dev, bool, S_IRUGO | S_IWUSR);
-module_param(limit_bw, bool, S_IRUGO | S_IWUSR);
 
 /*
  * Threshold below which the tty is woken for writing
@@ -2931,4 +2929,3 @@ MODULE_DEVICE_TABLE(ieee1394, fwserial_id_table);
 MODULE_PARM_DESC(ttys, "Number of ttys to create for each local firewire node");
 MODULE_PARM_DESC(auto, "Auto-connect a tty to each firewire node discovered");
 MODULE_PARM_DESC(loop, "Create a loopback device, fwloop<n>, with ttys");
-MODULE_PARM_DESC(limit_bw, "Limit bandwidth utilization to 20%.");
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index caa1c1e..e157318 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -351,7 +351,6 @@ struct fw_serial {
 #define TTY_DEV_NAME		    "fwtty"	/* ttyFW was taken           */
 static const char tty_dev_name[] =  TTY_DEV_NAME;
 static const char loop_dev_name[] = "fwloop";
-extern bool limit_bw;
 
 struct tty_driver *fwtty_driver;
 
@@ -370,18 +369,16 @@ static inline void fwtty_bind_console(struct fwtty_port *port,
 
 /*
  * Returns the max send async payload size in bytes based on the unit device
- * link speed - if set to limit bandwidth to max 20%, use lookup table
+ * link speed. Self-limiting asynchronous bandwidth (via reducing the payload)
+ * is not necessary and does not work, because
+ *   1) asynchronous traffic will absorb all available bandwidth (less that
+ *	being used for isochronous traffic)
+ *   2) isochronous arbitration always wins.
  */
 static inline int link_speed_to_max_payload(unsigned speed)
 {
-	static const int max_async[] = { 307, 614, 1229, 2458, };
-	BUILD_BUG_ON(ARRAY_SIZE(max_async) - 1 != SCODE_800);
-
 	speed = clamp(speed, (unsigned) SCODE_100, (unsigned) SCODE_800);
-	if (limit_bw)
-		return max_async[speed];
-	else
-		return 1 << (speed + 9);
+	return 1 << (speed + 9);
 }
 
 #endif /* _FIREWIRE_FWSERIAL_H */
-- 
1.8.1.1

