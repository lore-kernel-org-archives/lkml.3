Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3DOPaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:20 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45548 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3DOPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/9] n_tty: Remove echo_lock
Date: Mon, 15 Apr 2013 11:29:42 -0400
Message-Id: <1366039787-8719-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding data to echo_buf (via add_echo_byte()) is guaranteed to be
single-threaded, since all callers are from the n_tty_receive_buf()
path. Processing the echo_buf can be called from either the
n_tty_receive_buf() path or the n_tty_write() path; however, these
callers are already serialized by output_lock.

Publish cumulative echo_head changes to echo_commit; process echo_buf
from echo_tail to echo_commit; remove echo_lock.

On echo_buf overrun, claim output_lock to serialize changes to
echo_tail.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 75 ++++++++++++++++++++---------------------------------
 1 file changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index cd41733..49ef008 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -106,10 +106,10 @@ struct n_tty_data {
 	/* consumer-published */
 	size_t read_tail;
 
-	/* protected by echo_lock */
 	unsigned char *echo_buf;
 	size_t echo_head;
 	size_t echo_tail;
+	size_t echo_commit;
 
 	/* protected by output lock */
 	unsigned int column;
@@ -117,7 +117,6 @@ struct n_tty_data {
 
 	struct mutex atomic_read_lock;
 	struct mutex output_lock;
-	struct mutex echo_lock;
 };
 
 static inline size_t read_cnt(struct n_tty_data *ldata)
@@ -332,10 +331,7 @@ static void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
-
-	mutex_lock(&ldata->echo_lock);
-	ldata->echo_head = ldata->echo_tail  = 0;
-	mutex_unlock(&ldata->echo_lock);
+	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
 
 	ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
@@ -641,8 +637,7 @@ break_out:
  *	are prioritized.  Also, when control characters are echoed with a
  *	prefixed "^", the pair is treated atomically and thus not separated.
  *
- *	Locking: output_lock to protect column state and space left,
- *		 echo_lock to protect the echo buffer
+ *	Locking: output_lock to protect column state and space left
  */
 
 static void process_echoes(struct tty_struct *tty)
@@ -652,16 +647,15 @@ static void process_echoes(struct tty_struct *tty)
 	size_t tail;
 	unsigned char c;
 
-	if (ldata->echo_head == ldata->echo_tail)
+	if (ldata->echo_commit == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
-	mutex_lock(&ldata->echo_lock);
 
 	space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
-	nr = ldata->echo_head - ldata->echo_tail;
+	nr = ldata->echo_commit - ldata->echo_tail;
 	while (nr > 0) {
 		c = echo_buf(ldata, tail);
 		if (c == ECHO_OP_START) {
@@ -779,13 +773,21 @@ static void process_echoes(struct tty_struct *tty)
 
 	ldata->echo_tail = tail;
 
-	mutex_unlock(&ldata->echo_lock);
 	mutex_unlock(&ldata->output_lock);
 
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
 }
 
+static void commit_echoes(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+
+	smp_mb();
+	ldata->echo_commit = ldata->echo_head;
+	process_echoes(tty);
+}
+
 /**
  *	add_echo_byte	-	add a byte to the echo buffer
  *	@c: unicode byte to echo
@@ -793,13 +795,16 @@ static void process_echoes(struct tty_struct *tty)
  *
  *	Add a character or operation byte to the echo buffer.
  *
- *	Should be called under the echo lock to protect the echo buffer.
+ *	Locks: may claim output_lock to prevent concurrent modify of
+ *	       echo_tail by process_echoes().
  */
 
 static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 {
 	if (ldata->echo_head - ldata->echo_tail == N_TTY_BUF_SIZE) {
 		size_t head = ldata->echo_head;
+
+		mutex_lock(&ldata->output_lock);
 		/*
 		 * Since the buffer start position needs to be advanced,
 		 * be sure to step by a whole operation byte group.
@@ -811,6 +816,7 @@ static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 				ldata->echo_tail += 2;
 		} else
 			ldata->echo_tail++;
+		mutex_unlock(&ldata->output_lock);
 	}
 
 	*echo_buf_addr(ldata, ldata->echo_head++) = c;
@@ -821,16 +827,12 @@ static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
  *	@ldata: n_tty data
  *
  *	Add an operation to the echo buffer to move back one column.
- *
- *	Locking: echo_lock to protect the echo buffer
  */
 
 static void echo_move_back_col(struct n_tty_data *ldata)
 {
-	mutex_lock(&ldata->echo_lock);
 	add_echo_byte(ECHO_OP_START, ldata);
 	add_echo_byte(ECHO_OP_MOVE_BACK_COL, ldata);
-	mutex_unlock(&ldata->echo_lock);
 }
 
 /**
@@ -839,16 +841,12 @@ static void echo_move_back_col(struct n_tty_data *ldata)
  *
  *	Add an operation to the echo buffer to set the canon column
  *	to the current column.
- *
- *	Locking: echo_lock to protect the echo buffer
  */
 
 static void echo_set_canon_col(struct n_tty_data *ldata)
 {
-	mutex_lock(&ldata->echo_lock);
 	add_echo_byte(ECHO_OP_START, ldata);
 	add_echo_byte(ECHO_OP_SET_CANON_COL, ldata);
-	mutex_unlock(&ldata->echo_lock);
 }
 
 /**
@@ -864,15 +862,11 @@ static void echo_set_canon_col(struct n_tty_data *ldata)
  *	of input.  This information will be used later, along with
  *	canon column (if applicable), to go back the correct number
  *	of columns.
- *
- *	Locking: echo_lock to protect the echo buffer
  */
 
 static void echo_erase_tab(unsigned int num_chars, int after_tab,
 			   struct n_tty_data *ldata)
 {
-	mutex_lock(&ldata->echo_lock);
-
 	add_echo_byte(ECHO_OP_START, ldata);
 	add_echo_byte(ECHO_OP_ERASE_TAB, ldata);
 
@@ -884,8 +878,6 @@ static void echo_erase_tab(unsigned int num_chars, int after_tab,
 		num_chars |= 0x80;
 
 	add_echo_byte(num_chars, ldata);
-
-	mutex_unlock(&ldata->echo_lock);
 }
 
 /**
@@ -897,20 +889,16 @@ static void echo_erase_tab(unsigned int num_chars, int after_tab,
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  *
  *	This variant does not treat control characters specially.
- *
- *	Locking: echo_lock to protect the echo buffer
  */
 
 static void echo_char_raw(unsigned char c, struct n_tty_data *ldata)
 {
-	mutex_lock(&ldata->echo_lock);
 	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, ldata);
 		add_echo_byte(ECHO_OP_START, ldata);
 	} else {
 		add_echo_byte(c, ldata);
 	}
-	mutex_unlock(&ldata->echo_lock);
 }
 
 /**
@@ -923,16 +911,12 @@ static void echo_char_raw(unsigned char c, struct n_tty_data *ldata)
  *
  *	This variant tags control characters to be echoed as "^X"
  *	(where X is the letter representing the control char).
- *
- *	Locking: echo_lock to protect the echo buffer
  */
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	mutex_lock(&ldata->echo_lock);
-
 	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, ldata);
 		add_echo_byte(ECHO_OP_START, ldata);
@@ -941,8 +925,6 @@ static void echo_char(unsigned char c, struct tty_struct *tty)
 			add_echo_byte(ECHO_OP_START, ldata);
 		add_echo_byte(c, ldata);
 	}
-
-	mutex_unlock(&ldata->echo_lock);
 }
 
 /**
@@ -1284,7 +1266,7 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 			if (ldata->canon_head == ldata->read_head)
 				echo_set_canon_col(ldata);
 			echo_char(c, tty);
-			process_echoes(tty);
+			commit_echoes(tty);
 		}
 		if (parmrk)
 			put_tty_queue(c, ldata);
@@ -1295,7 +1277,7 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
-			process_echoes(tty);
+			commit_echoes(tty);
 			return;
 		}
 		if (c == STOP_CHAR(tty)) {
@@ -1326,7 +1308,7 @@ send_signal:
 				start_tty(tty);
 			if (L_ECHO(tty)) {
 				echo_char(c, tty);
-				process_echoes(tty);
+				commit_echoes(tty);
 			}
 			isig(signal, tty);
 			return;
@@ -1345,7 +1327,7 @@ send_signal:
 		if (c == ERASE_CHAR(tty) || c == KILL_CHAR(tty) ||
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {
 			eraser(c, tty);
-			process_echoes(tty);
+			commit_echoes(tty);
 			return;
 		}
 		if (c == LNEXT_CHAR(tty) && L_IEXTEN(tty)) {
@@ -1355,7 +1337,7 @@ send_signal:
 				if (L_ECHOCTL(tty)) {
 					echo_char_raw('^', ldata);
 					echo_char_raw('\b', ldata);
-					process_echoes(tty);
+					commit_echoes(tty);
 				}
 			}
 			return;
@@ -1371,7 +1353,7 @@ send_signal:
 				echo_char(read_buf(ldata, tail), tty);
 				tail++;
 			}
-			process_echoes(tty);
+			commit_echoes(tty);
 			return;
 		}
 		if (c == '\n') {
@@ -1382,7 +1364,7 @@ send_signal:
 			}
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				echo_char_raw('\n', ldata);
-				process_echoes(tty);
+				commit_echoes(tty);
 			}
 			goto handle_newline;
 		}
@@ -1411,7 +1393,7 @@ send_signal:
 				if (ldata->canon_head == ldata->read_head)
 					echo_set_canon_col(ldata);
 				echo_char(c, tty);
-				process_echoes(tty);
+				commit_echoes(tty);
 			}
 			/*
 			 * XXX does PARMRK doubling happen for
@@ -1448,7 +1430,7 @@ handle_newline:
 				echo_set_canon_col(ldata);
 			echo_char(c, tty);
 		}
-		process_echoes(tty);
+		commit_echoes(tty);
 	}
 
 	if (parmrk)
@@ -1710,7 +1692,6 @@ static int n_tty_open(struct tty_struct *tty)
 	ldata->overrun_time = jiffies;
 	mutex_init(&ldata->atomic_read_lock);
 	mutex_init(&ldata->output_lock);
-	mutex_init(&ldata->echo_lock);
 
 	/* These are ugly. Currently a malloc failure here can panic */
 	ldata->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-- 
1.8.1.2

