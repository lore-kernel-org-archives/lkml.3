Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3BDETB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:19:01 -0500
Received: from science.horizon.com ([71.41.210.146]:59534 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753826Ab3BDES6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:18:58 -0500
Date: 3 Feb 2013 23:18:57 -0500
Message-ID: <20130204041857.12347.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jslaby@suse.cz, linux-serial@vger.kernel.org
Subject: Re: 3.8-rc regression with pps-ldisc due to 70ece7a731
Cc: giometti@linux.it, lasaine@lvk.cs.msu.su, linux-kernel@vger.kernel.org,
        linux@horizon.com
In-Reply-To: <20130204010303.24971.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI, here is the (ugly and appears to crash) sort of patch
I was contemplating.

You may consider this Signed-off-by: in the narrow technical sense that I
can certify the origin of the code, but obviously I do not consider it
a candidate for upstream merging.  It is posted here in the hopes that
its sheer hideousness will inspire someone else to show that they can
do better.

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 19083ef..c149c70 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -73,7 +73,10 @@
 #define ECHO_OP_SET_CANON_COL 0x81
 #define ECHO_OP_ERASE_TAB 0x82
 
+struct pps_device;	/* Used by drivers/pps/clients/pps-ldisc.c */
+
 struct n_tty_data {
+	struct pps_device *pps;	/* First so pps-ldisc doesn't have to know offset. */
 	unsigned int column;
 	unsigned long overrun_time;
 	int num_overrun;
@@ -1636,6 +1639,7 @@ static int n_tty_open(struct tty_struct *tty)
 	mutex_init(&ldata->output_lock);
 	mutex_init(&ldata->echo_lock);
 	spin_lock_init(&ldata->read_lock);
+	//tty->pps = NULL;	/* Done by kzalloc */
 
 	/* These are ugly. Currently a malloc failure here can panic */
 	ldata->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
@@ -1646,10 +1650,10 @@ static int n_tty_open(struct tty_struct *tty)
 	tty->disc_data = ldata;
 	reset_buffer_flags(tty);
 	tty_unthrottle(tty);
-	ldata->column = 0;
+	//ldata->column = 0;	/* Done by kzalloc */
 	n_tty_set_termios(tty, NULL);
 	tty->minimum_to_wake = 1;
-	tty->closing = 0;
+	//tty->closing = 0;	/* Done by kzalloc */
 
 	return 0;
 err_free_bufs:
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 79451f2..b5c6dd8 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -31,9 +31,16 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = *(struct pps_device **)tty->disc_data;
 
-	BUG_ON(pps == NULL);
+	/* Because we set the pps field *after* the tty is opened, there's
+	 * a race window during which this can happen.
+	 */
+	if (pps == NULL) {
+		pr_err("Race condition triggered, pps = NULL");
+		return;
+	}
+//	BUG_ON(pps == NULL);
 
 	/* Now do the PPS event report */
 	pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
@@ -67,7 +74,6 @@ static int pps_tty_open(struct tty_struct *tty)
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
 		return -ENOMEM;
 	}
-	tty->disc_data = pps;
 
 	/* Should open N_TTY ldisc too */
 	ret = alias_n_tty_open(tty);
@@ -75,13 +81,13 @@ static int pps_tty_open(struct tty_struct *tty)
 		pr_err("cannot open tty ldisc \"%s\"\n", info.path);
 		goto err_unregister;
 	}
+	*(struct pps_device **)tty->disc_data = pps;
 
 	dev_info(pps->dev, "source \"%s\" added\n", info.path);
 
 	return 0;
 
 err_unregister:
-	tty->disc_data = NULL;
 	pps_unregister_source(pps);
 	return ret;
 }
@@ -90,11 +96,11 @@ static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = *(struct pps_device **)tty->disc_data;
 
+	*(struct pps_device **)tty->disc_data = NULL;
 	alias_n_tty_close(tty);
 
-	tty->disc_data = NULL;
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
 }
