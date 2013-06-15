Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3FOOW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:22:26 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40478 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3FOOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:21:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 03/20] n_tty: Move buffers into n_tty_data
Date: Sat, 15 Jun 2013 10:21:19 -0400
Message-Id: <1371306096-5571-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce pointer reloading and improve locality-of-reference;
allocate read_buf and echo_buf within struct n_tty_data.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index b8851b6..3daf9f0 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -105,9 +105,9 @@ struct n_tty_data {
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 
 	/* shared by producer and consumer */
-	char *read_buf;
+	char read_buf[N_TTY_BUF_SIZE];
 	DECLARE_BITMAP(read_flags, N_TTY_BUF_SIZE);
-	unsigned char *echo_buf;
+	unsigned char echo_buf[N_TTY_BUF_SIZE];
 
 	int minimum_to_wake;
 
@@ -1694,9 +1694,7 @@ static void n_tty_close(struct tty_struct *tty)
 	if (tty->link)
 		n_tty_packet_mode_flush(tty);
 
-	kfree(ldata->read_buf);
-	kfree(ldata->echo_buf);
-	kfree(ldata);
+	vfree(ldata);
 	tty->disc_data = NULL;
 }
 
@@ -1714,7 +1712,8 @@ static int n_tty_open(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata;
 
-	ldata = kzalloc(sizeof(*ldata), GFP_KERNEL);
+	/* Currently a malloc failure here can panic */
+	ldata = vmalloc(sizeof(*ldata));
 	if (!ldata)
 		goto err;
 
@@ -1722,16 +1721,14 @@ static int n_tty_open(struct tty_struct *tty)
 	mutex_init(&ldata->atomic_read_lock);
 	mutex_init(&ldata->output_lock);
 
-	/* These are ugly. Currently a malloc failure here can panic */
-	ldata->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-	ldata->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-	if (!ldata->read_buf || !ldata->echo_buf)
-		goto err_free_bufs;
-
 	tty->disc_data = ldata;
 	reset_buffer_flags(tty->disc_data);
 	ldata->column = 0;
+	ldata->canon_column = 0;
 	ldata->minimum_to_wake = 1;
+	ldata->num_overrun = 0;
+	ldata->no_room = 0;
+	ldata->lnext = 0;
 	tty->closing = 0;
 	/* indicate buffer work may resume */
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
@@ -1739,10 +1736,6 @@ static int n_tty_open(struct tty_struct *tty)
 	tty_unthrottle(tty);
 
 	return 0;
-err_free_bufs:
-	kfree(ldata->read_buf);
-	kfree(ldata->echo_buf);
-	kfree(ldata);
 err:
 	return -ENOMEM;
 }
-- 
1.8.1.2

