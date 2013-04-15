Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3DOPaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:11 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45534 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3DOPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/9] n_tty: Use separate head and tail indices for echo_buf
Date: Mon, 15 Apr 2013 11:29:40 -0400
Message-Id: <1366039787-8719-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a single index to track the current echo_buf position,
use a head index when adding to the buffer and a tail index when
consuming from the buffer. Allow these head and tail indices to wrap
at max representable value; perform modulo reduction via helper
functions when accessing the buffer.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 88 +++++++++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 53 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index e9a392a..85334f8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -108,7 +108,8 @@ struct n_tty_data {
 
 	/* protected by echo_lock */
 	unsigned char *echo_buf;
-	unsigned int echo_pos;
+	size_t echo_head;
+	size_t echo_tail;
 	unsigned int echo_cnt;
 
 	/* protected by output lock */
@@ -135,6 +136,16 @@ static inline unsigned char *read_buf_addr(struct n_tty_data *ldata, size_t i)
 	return &ldata->read_buf[i & (N_TTY_BUF_SIZE - 1)];
 }
 
+static inline unsigned char echo_buf(struct n_tty_data *ldata, size_t i)
+{
+	return ldata->echo_buf[i & (N_TTY_BUF_SIZE - 1)];
+}
+
+static inline unsigned char *echo_buf_addr(struct n_tty_data *ldata, size_t i)
+{
+	return &ldata->echo_buf[i & (N_TTY_BUF_SIZE - 1)];
+}
+
 static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 			       unsigned char __user *ptr)
 {
@@ -324,7 +335,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
 
 	mutex_lock(&ldata->echo_lock);
-	ldata->echo_pos = ldata->echo_cnt = 0;
+	ldata->echo_head = ldata->echo_tail = ldata->echo_cnt = 0;
 	mutex_unlock(&ldata->echo_lock);
 
 	ldata->erasing = 0;
@@ -639,8 +650,8 @@ static void process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int	space, nr;
+	size_t tail;
 	unsigned char c;
-	unsigned char *cp, *buf_end;
 
 	if (!ldata->echo_cnt)
 		return;
@@ -650,14 +661,12 @@ static void process_echoes(struct tty_struct *tty)
 
 	space = tty_write_room(tty);
 
-	buf_end = ldata->echo_buf + N_TTY_BUF_SIZE;
-	cp = ldata->echo_buf + ldata->echo_pos;
+	tail = ldata->echo_tail;
 	nr = ldata->echo_cnt;
 	while (nr > 0) {
-		c = *cp;
+		c = echo_buf(ldata, tail);
 		if (c == ECHO_OP_START) {
 			unsigned char op;
-			unsigned char *opp;
 			int no_space_left = 0;
 
 			/*
@@ -665,18 +674,13 @@ static void process_echoes(struct tty_struct *tty)
 			 * operation, get the next byte, which is either the
 			 * op code or a control character value.
 			 */
-			opp = cp + 1;
-			if (opp == buf_end)
-				opp -= N_TTY_BUF_SIZE;
-			op = *opp;
+			op = echo_buf(ldata, tail + 1);
 
 			switch (op) {
 				unsigned int num_chars, num_bs;
 
 			case ECHO_OP_ERASE_TAB:
-				if (++opp == buf_end)
-					opp -= N_TTY_BUF_SIZE;
-				num_chars = *opp;
+				num_chars = echo_buf(ldata, tail + 2);
 
 				/*
 				 * Determine how many columns to go back
@@ -702,20 +706,20 @@ static void process_echoes(struct tty_struct *tty)
 					if (ldata->column > 0)
 						ldata->column--;
 				}
-				cp += 3;
+				tail += 3;
 				nr -= 3;
 				break;
 
 			case ECHO_OP_SET_CANON_COL:
 				ldata->canon_column = ldata->column;
-				cp += 2;
+				tail += 2;
 				nr -= 2;
 				break;
 
 			case ECHO_OP_MOVE_BACK_COL:
 				if (ldata->column > 0)
 					ldata->column--;
-				cp += 2;
+				tail += 2;
 				nr -= 2;
 				break;
 
@@ -728,7 +732,7 @@ static void process_echoes(struct tty_struct *tty)
 				tty_put_char(tty, ECHO_OP_START);
 				ldata->column++;
 				space--;
-				cp += 2;
+				tail += 2;
 				nr -= 2;
 				break;
 
@@ -750,7 +754,7 @@ static void process_echoes(struct tty_struct *tty)
 				tty_put_char(tty, op ^ 0100);
 				ldata->column += 2;
 				space -= 2;
-				cp += 2;
+				tail += 2;
 				nr -= 2;
 			}
 
@@ -769,24 +773,13 @@ static void process_echoes(struct tty_struct *tty)
 				tty_put_char(tty, c);
 				space -= 1;
 			}
-			cp += 1;
+			tail += 1;
 			nr -= 1;
 		}
-
-		/* When end of circular buffer reached, wrap around */
-		if (cp >= buf_end)
-			cp -= N_TTY_BUF_SIZE;
 	}
 
-	if (nr == 0) {
-		ldata->echo_pos = 0;
-		ldata->echo_cnt = 0;
-	} else {
-		int num_processed = ldata->echo_cnt - nr;
-		ldata->echo_pos += num_processed;
-		ldata->echo_pos &= N_TTY_BUF_SIZE - 1;
-		ldata->echo_cnt = nr;
-	}
+	ldata->echo_tail = tail;
+	ldata->echo_cnt = nr;
 
 	mutex_unlock(&ldata->echo_lock);
 	mutex_unlock(&ldata->output_lock);
@@ -807,37 +800,26 @@ static void process_echoes(struct tty_struct *tty)
 
 static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 {
-	int	new_byte_pos;
-
 	if (ldata->echo_cnt == N_TTY_BUF_SIZE) {
-		/* Circular buffer is already at capacity */
-		new_byte_pos = ldata->echo_pos;
-
+		size_t head = ldata->echo_head;
 		/*
 		 * Since the buffer start position needs to be advanced,
 		 * be sure to step by a whole operation byte group.
 		 */
-		if (ldata->echo_buf[ldata->echo_pos] == ECHO_OP_START) {
-			if (ldata->echo_buf[(ldata->echo_pos + 1) &
-					  (N_TTY_BUF_SIZE - 1)] ==
-						ECHO_OP_ERASE_TAB) {
-				ldata->echo_pos += 3;
+		if (echo_buf(ldata, head) == ECHO_OP_START) {
+			if (echo_buf(ldata, head + 1) == ECHO_OP_ERASE_TAB) {
+				ldata->echo_tail += 3;
 				ldata->echo_cnt -= 2;
 			} else {
-				ldata->echo_pos += 2;
+				ldata->echo_tail += 2;
 				ldata->echo_cnt -= 1;
 			}
-		} else {
-			ldata->echo_pos++;
-		}
-		ldata->echo_pos &= N_TTY_BUF_SIZE - 1;
-	} else {
-		new_byte_pos = ldata->echo_pos + ldata->echo_cnt;
-		new_byte_pos &= N_TTY_BUF_SIZE - 1;
+		} else
+			ldata->echo_tail++;
+	} else
 		ldata->echo_cnt++;
-	}
 
-	ldata->echo_buf[new_byte_pos] = c;
+	*echo_buf_addr(ldata, ldata->echo_head++) = c;
 }
 
 /**
-- 
1.8.1.2

