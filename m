Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3FOOF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:05:26 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40189 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3FOOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:04:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 1/9] n_tty: Remove unused echo_overrun field
Date: Sat, 15 Jun 2013 10:04:21 -0400
Message-Id: <1371305069-5366-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The echo_overrun field is only assigned and never tested; remove it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 2321d6a..160d9d2 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -96,7 +96,6 @@ struct n_tty_data {
 
 	/* must hold exclusive termios_rwsem to reset these */
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
-	unsigned char echo_overrun:1;
 
 	/* shared by producer and consumer */
 	char *read_buf;
@@ -325,7 +324,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 
 	mutex_lock(&ldata->echo_lock);
-	ldata->echo_pos = ldata->echo_cnt = ldata->echo_overrun = 0;
+	ldata->echo_pos = ldata->echo_cnt = 0;
 	mutex_unlock(&ldata->echo_lock);
 
 	ldata->erasing = 0;
@@ -781,14 +780,11 @@ static void process_echoes(struct tty_struct *tty)
 	if (nr == 0) {
 		ldata->echo_pos = 0;
 		ldata->echo_cnt = 0;
-		ldata->echo_overrun = 0;
 	} else {
 		int num_processed = ldata->echo_cnt - nr;
 		ldata->echo_pos += num_processed;
 		ldata->echo_pos &= N_TTY_BUF_SIZE - 1;
 		ldata->echo_cnt = nr;
-		if (num_processed > 0)
-			ldata->echo_overrun = 0;
 	}
 
 	mutex_unlock(&ldata->echo_lock);
@@ -834,8 +830,6 @@ static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 			ldata->echo_pos++;
 		}
 		ldata->echo_pos &= N_TTY_BUF_SIZE - 1;
-
-		ldata->echo_overrun = 1;
 	} else {
 		new_byte_pos = ldata->echo_pos + ldata->echo_cnt;
 		new_byte_pos &= N_TTY_BUF_SIZE - 1;
-- 
1.8.1.2

