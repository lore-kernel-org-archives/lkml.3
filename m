Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3BFP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:57:54 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:35268 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757495Ab3BFP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:57:01 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 1/4] pps: Decouple N_PPS from N_TTY
Date: Wed,  6 Feb 2013 10:55:13 -0500
Message-Id: <1360166116-30797-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
References: <20130204010303.24971.qmail@science.horizon.com>
 <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPS (Pulse-Per-Second) line discipline has developed a number of
unhealthy attachments to core tty data and functions, ultimately leading
to its breakage.

Remove header file linkage.
Make ldisc api extension generic.
Fix attendant build breakage in
    drivers/staging/speakup/selection.c
    drivers/tty/tty_buffer.c
    drivers/tty/n_tty.c

Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@braille.uwo.ca>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/pps/clients/pps-ldisc.c     |  8 +++++---
 drivers/staging/speakup/selection.c |  1 +
 drivers/tty/n_tty.c                 |  3 ++-
 drivers/tty/serial/serial_core.c    | 20 +++++++++-----------
 drivers/tty/tty_buffer.c            |  1 +
 include/linux/serial_core.h         |  1 -
 include/linux/tty_ldisc.h           | 11 ++++-------
 7 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 79451f2..27d7ca1 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -28,15 +28,17 @@
 
 #define PPS_TTY_MAGIC		0x0001
 
-static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
-				struct pps_event_time *ts)
+static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
 {
+	struct pps_event_time ts;
 	struct pps_device *pps = (struct pps_device *)tty->disc_data;
 
+	pps_get_ts(&ts);
+
 	BUG_ON(pps == NULL);
 
 	/* Now do the PPS event report */
-	pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
+	pps_event(pps, &ts, status ? PPS_CAPTUREASSERT :
 			PPS_CAPTURECLEAR, NULL);
 
 	dev_dbg(pps->dev, "PPS %s at %lu\n",
diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index d6558fa..72afc05 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -2,6 +2,7 @@
 #include <linux/consolemap.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/device.h> /* for dev_warn */
 #include <linux/selection.h>
 
 #include "speakup.h"
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index e269296..911ccb5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -49,6 +49,7 @@
 #include <linux/file.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/ratelimit.h>
 
 
 /* number of characters left in xmit buffer before select has we have room */
@@ -2198,7 +2199,7 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
  *	n_tty_inherit_ops	-	inherit N_TTY methods
  *	@ops: struct tty_ldisc_ops where to save N_TTY methods
  *
- *	Used by a generic struct tty_ldisc_ops to easily inherit N_TTY
+ *	Enables 'subclass' line discipline to 'inherit' N_TTY
  *	methods.
  */
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ca98a3f..457f1a6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2726,31 +2726,29 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	struct uart_state *state = uport->state;
 	struct tty_port *port = &state->port;
 	struct tty_ldisc *ld = NULL;
-	struct pps_event_time ts;
 	struct tty_struct *tty = port->tty;
 
-	if (tty)
-	        ld = tty_ldisc_ref(tty);
-	if (ld && ld->ops->dcd_change)
-		pps_get_ts(&ts);
-
 	uport->icount.dcd++;
+
 #ifdef CONFIG_HARD_PPS
 	if ((uport->flags & UPF_HARDPPS_CD) && status)
 		hardpps();
 #endif
 
+	if (tty) {
+		ld = tty_ldisc_ref(tty);
+		if (ld && ld->ops->dcd_change)
+			ld->ops->dcd_change(tty, status);
+		if (ld)
+			tty_ldisc_deref(ld);
+	}
+
 	if (port->flags & ASYNC_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&port->open_wait);
 		else if (tty)
 			tty_hangup(tty);
 	}
-
-	if (ld && ld->ops->dcd_change)
-		ld->ops->dcd_change(tty, status, &ts);
-	if (ld)
-		tty_ldisc_deref(ld);
 }
 EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
 
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 61ec4dd..bb11993 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -16,6 +16,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/ratelimit.h>
 
 /**
  *	tty_buffer_free_all		-	free buffers used by a tty
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index d971421..87d4bbc 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -29,7 +29,6 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
-#include <linux/pps_kernel.h>
 #include <uapi/linux/serial_core.h>
 
 struct uart_port;
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index fb79dd8d..455a0d7 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -100,16 +100,14 @@
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
  *
- * void (*dcd_change)(struct tty_struct *tty, unsigned int status,
- *			struct pps_event_time *ts)
+ * void (*dcd_change)(struct tty_struct *tty, unsigned int status)
  *
- *	Tells the discipline that the DCD pin has changed its status and
- *	the relative timestamp. Pointer ts cannot be NULL.
+ *	Tells the discipline that the DCD pin has changed its status.
+ *	Used exclusively by the N_PPS (Pulse-Per-Second) line discipline.
  */
 
 #include <linux/fs.h>
 #include <linux/wait.h>
-#include <linux/pps_kernel.h>
 #include <linux/wait.h>
 
 struct tty_ldisc_ops {
@@ -144,8 +142,7 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
-	void	(*dcd_change)(struct tty_struct *, unsigned int,
-				struct pps_event_time *);
+	void	(*dcd_change)(struct tty_struct *, unsigned int);
 
 	struct  module *owner;
 	
-- 
1.8.1.2

