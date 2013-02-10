Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276Ab3BLOzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:55:50 -0500
Received: from science.horizon.com ([71.41.210.146]:57532 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761264Ab3BLOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:38 -0500
MBOX-Line: From a4f07ac1d45cc5d85159722d059585c4e829ec42 Mon Sep 17 00:00:00 2001
Message-Id: <a4f07ac1d45cc5d85159722d059585c4e829ec42.1360677367.git.linux@horizon.com>
In-Reply-To: <cover.1360677367.git.linux@horizon.com>
References: <cover.1360677367.git.linux@horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Sun, 10 Feb 2013 04:43:41 -0500
Subject: [PATCH v2 4/9] pps: Don't crash the machine when exiting will do
To: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPS is not really the must-have subsystem that warrants crashing
the machine if the ldisc interface is broken.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/pps/clients/pps-ldisc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 60cee9e..a94f73e 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -25,6 +25,7 @@
 #include <linux/serial_core.h>
 #include <linux/tty.h>
 #include <linux/pps_kernel.h>
+#include <linux/bug.h>
 
 #define PPS_TTY_MAGIC		0x0001
 
@@ -33,7 +34,12 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 {
 	struct pps_device *pps = pps_lookup_dev(tty);
 
-	BUG_ON(pps == NULL);
+	/*
+	 * This should never fail, but the ldisc locking is very
+	 * convoluted, so don't crash just in case.
+	 */
+	if (WARN_ON_ONCE(pps == NULL))
+		return;
 
 	/* Now do the PPS event report */
 	pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
@@ -93,6 +99,9 @@ static void pps_tty_close(struct tty_struct *tty)
 
 	alias_n_tty_close(tty);
 
+	if (WARN_ON(!pps))
+		return;
+
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
 }
-- 
1.8.1.3

