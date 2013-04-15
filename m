Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3DOPaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:23 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45543 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3DOPaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/9] n_tty: Replace echo_cnt with computed value
Date: Mon, 15 Apr 2013 11:29:41 -0400
Message-Id: <1366039787-8719-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for lockless echo_buf handling; compute current byte count
of echo_buf from head and tail indices.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 85334f8..cd41733 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -110,7 +110,6 @@ struct n_tty_data {
 	unsigned char *echo_buf;
 	size_t echo_head;
 	size_t echo_tail;
-	unsigned int echo_cnt;
 
 	/* protected by output lock */
 	unsigned int column;
@@ -335,7 +334,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 
 	mutex_lock(&ldata->echo_lock);
-	ldata->echo_head = ldata->echo_tail = ldata->echo_cnt = 0;
+	ldata->echo_head = ldata->echo_tail  = 0;
 	mutex_unlock(&ldata->echo_lock);
 
 	ldata->erasing = 0;
@@ -653,7 +652,7 @@ static void process_echoes(struct tty_struct *tty)
 	size_t tail;
 	unsigned char c;
 
-	if (!ldata->echo_cnt)
+	if (ldata->echo_head == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
@@ -662,7 +661,7 @@ static void process_echoes(struct tty_struct *tty)
 	space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
-	nr = ldata->echo_cnt;
+	nr = ldata->echo_head - ldata->echo_tail;
 	while (nr > 0) {
 		c = echo_buf(ldata, tail);
 		if (c == ECHO_OP_START) {
@@ -779,7 +778,6 @@ static void process_echoes(struct tty_struct *tty)
 	}
 
 	ldata->echo_tail = tail;
-	ldata->echo_cnt = nr;
 
 	mutex_unlock(&ldata->echo_lock);
 	mutex_unlock(&ldata->output_lock);
@@ -800,24 +798,20 @@ static void process_echoes(struct tty_struct *tty)
 
 static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 {
-	if (ldata->echo_cnt == N_TTY_BUF_SIZE) {
+	if (ldata->echo_head - ldata->echo_tail == N_TTY_BUF_SIZE) {
 		size_t head = ldata->echo_head;
 		/*
 		 * Since the buffer start position needs to be advanced,
 		 * be sure to step by a whole operation byte group.
 		 */
 		if (echo_buf(ldata, head) == ECHO_OP_START) {
-			if (echo_buf(ldata, head + 1) == ECHO_OP_ERASE_TAB) {
+			if (echo_buf(ldata, head + 1) == ECHO_OP_ERASE_TAB)
 				ldata->echo_tail += 3;
-				ldata->echo_cnt -= 2;
-			} else {
+			else
 				ldata->echo_tail += 2;
-				ldata->echo_cnt -= 1;
-			}
 		} else
 			ldata->echo_tail++;
-	} else
-		ldata->echo_cnt++;
+	}
 
 	*echo_buf_addr(ldata, ldata->echo_head++) = c;
 }
-- 
1.8.1.2

