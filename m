Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab3B1PNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:13:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab3B1Orm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 047/139] pps: Use pps_lookup_dev to reduce ldisc coupling
Date: Thu, 28 Feb 2013 14:43:17 +0000
Message-Id: <1362062689-2567-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pps/clients/pps-ldisc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 79451f2..60cee9e 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -31,7 +31,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	BUG_ON(pps == NULL);
 
@@ -67,9 +67,9 @@ static int pps_tty_open(struct tty_struct *tty)
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
@@ -81,7 +81,6 @@ static int pps_tty_open(struct tty_struct *tty)
 	return 0;
 
 err_unregister:
-	tty->disc_data = NULL;
 	pps_unregister_source(pps);
 	return ret;
 }
@@ -90,11 +89,10 @@ static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	struct pps_device *pps = (struct pps_device *)tty->disc_data;
+	struct pps_device *pps = pps_lookup_dev(tty);
 
 	alias_n_tty_close(tty);
 
-	tty->disc_data = NULL;
 	dev_info(pps->dev, "removed\n");
 	pps_unregister_source(pps);
 }
-- 
1.8.1.2

