Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823Ab3DOPfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:35:55 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45986 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353Ab3DOPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/20] n_tty: Move buffers into n_tty_data
Date: Mon, 15 Apr 2013 11:32:34 -0400
Message-Id: <1366039971-8770-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
 <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
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
index bfb04d3..8aac758 100644
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
 
@@ -1692,9 +1692,7 @@ static void n_tty_close(struct tty_struct *tty)
 	if (tty->link)
 		n_tty_packet_mode_flush(tty);
 
-	kfree(ldata->read_buf);
-	kfree(ldata->echo_buf);
-	kfree(ldata);
+	vfree(ldata);
 	tty->disc_data = NULL;
 }
 
@@ -1712,7 +1710,8 @@ static int n_tty_open(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata;
 
-	ldata = kzalloc(sizeof(*ldata), GFP_KERNEL);
+	/* Currently a malloc failure here can panic */
+	ldata = vmalloc(sizeof(*ldata));
 	if (!ldata)
 		goto err;
 
@@ -1720,16 +1719,14 @@ static int n_tty_open(struct tty_struct *tty)
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
@@ -1737,10 +1734,6 @@ static int n_tty_open(struct tty_struct *tty)
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

