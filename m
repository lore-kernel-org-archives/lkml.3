Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab3B0BPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:15:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033Ab3BZX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George Spelvin <linux@horizon.com>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [ 028/150] pps: Use pps_lookup_dev to reduce ldisc coupling
Date: Tue, 26 Feb 2013 15:54:45 -0800
Message-Id: <20130226235527.151182391@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit 03a7ffe4e542310838bac70ef85acc17536b6d7c upstream.

Now that N_TTY uses tty->disc_data for its private data,
'subclass' ldiscs cannot use ->disc_data for their own private data.
(This is a regression is v3.8-rc1)

Use pps_lookup_dev to associate the tty with the pps source instead.

This fixes a crashing regression in 3.8-rc1.

Signed-off-by: George Spelvin <linux@horizon.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pps/clients/pps-ldisc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -31,7 +31,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	BUG_ON(pps == NULL);
 
@@ -67,9 +67,9 @@ static int pps_tty_open(struct tty_struc
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
 		return -ENOMEM;
 	}
-	tty->disc_data = pps;
+	pps->lookup_cookie = tty;
 
-	/* Should open N_TTY ldisc too */
+	/* Now open the base class N_TTY ldisc */
 	ret = alias_n_tty_open(tty);
 	if (ret < 0) {
 		pr_err("cannot open tty ldisc \"%s\"\n", info.path);
@@ -81,7 +81,6 @@ static int pps_tty_open(struct tty_struc
 	return 0;
 
 err_unregister:
-	tty->disc_data = NULL;
 	pps_unregister_source(pps);
 	return ret;
 }
@@ -90,11 +89,10 @@ static void (*alias_n_tty_close)(struct
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	alias_n_tty_close(tty);
 
-	tty->disc_data = NULL;
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
 }


