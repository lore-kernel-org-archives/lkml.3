Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3DOPcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:32:19 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45570 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3DOPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:22 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 6/9] n_tty: Process echoes in blocks
Date: Mon, 15 Apr 2013 11:29:44 -0400
Message-Id: <1366039787-8719-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byte-by-byte echo output is painfully slow, requiring a lock/unlock
cycle for every input byte.

Instead, perform the echo output in blocks of 256 characters, and
at least once per flip buffer receive. Enough space is reserved in
the echo buffer to guarantee a full block can be saved without
overrunning the echo output. Overrun is prevented by discarding
the oldest echoes until enough space exists in the echo buffer
to receive at least a full block of new echoes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 70 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c101492..6f507f5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -74,6 +74,11 @@
 #define ECHO_OP_SET_CANON_COL 0x81
 #define ECHO_OP_ERASE_TAB 0x82
 
+#define ECHO_COMMIT_WATERMARK	256
+#define ECHO_BLOCK		256
+#define ECHO_DISCARD_WATERMARK	N_TTY_BUF_SIZE - (ECHO_BLOCK + 32)
+
+
 #undef N_TTY_TRACE
 #ifdef N_TTY_TRACE
 # define n_tty_trace(f, args...)	trace_printk(f, ##args)
@@ -766,15 +771,40 @@ static void __process_echoes(struct tty_struct *tty)
 		}
 	}
 
+	/* If the echo buffer is nearly full (so that the possibility exists
+	 * of echo overrun before the next commit), then discard enough
+	 * data at the tail to prevent a subsequent overrun */
+	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
+		if (echo_buf(ldata, tail == ECHO_OP_START)) {
+			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
+				tail += 3;
+			else
+				tail += 2;
+		} else
+			tail++;
+	}
+
 	ldata->echo_tail = tail;
 }
 
 static void commit_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t nr, old;
+	size_t head;
+
+	head = ldata->echo_head;
+	old = ldata->echo_commit - ldata->echo_tail;
+
+	/* Process committed echoes if the accumulated # of bytes
+	 * is over the threshold (and try again each time another
+	 * block is accumulated) */
+	nr = head - ldata->echo_tail;
+	if (nr < ECHO_COMMIT_WATERMARK || (nr % ECHO_BLOCK > old % ECHO_BLOCK))
+		return;
 
 	mutex_lock(&ldata->output_lock);
-	ldata->echo_commit = ldata->echo_head;
+	ldata->echo_commit = head;
 	__process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
@@ -797,37 +827,29 @@ static void process_echoes(struct tty_struct *tty)
 		tty->ops->flush_chars(tty);
 }
 
+static void flush_echoes(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+
+	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_head)
+		return;
+
+	mutex_lock(&ldata->output_lock);
+	ldata->echo_commit = ldata->echo_head;
+	__process_echoes(tty);
+	mutex_unlock(&ldata->output_lock);
+}
+
 /**
  *	add_echo_byte	-	add a byte to the echo buffer
  *	@c: unicode byte to echo
  *	@ldata: n_tty data
  *
  *	Add a character or operation byte to the echo buffer.
- *
- *	Locks: may claim output_lock to prevent concurrent modify of
- *	       echo_tail by process_echoes().
  */
 
-static void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
+static inline void add_echo_byte(unsigned char c, struct n_tty_data *ldata)
 {
-	if (ldata->echo_head - ldata->echo_tail == N_TTY_BUF_SIZE) {
-		size_t head = ldata->echo_head;
-
-		mutex_lock(&ldata->output_lock);
-		/*
-		 * Since the buffer start position needs to be advanced,
-		 * be sure to step by a whole operation byte group.
-		 */
-		if (echo_buf(ldata, head) == ECHO_OP_START) {
-			if (echo_buf(ldata, head + 1) == ECHO_OP_ERASE_TAB)
-				ldata->echo_tail += 3;
-			else
-				ldata->echo_tail += 2;
-		} else
-			ldata->echo_tail++;
-		mutex_unlock(&ldata->output_lock);
-	}
-
 	*echo_buf_addr(ldata, ldata->echo_head++) = c;
 }
 
@@ -1515,6 +1537,8 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 				break;
 			}
 		}
+
+		flush_echoes(tty);
 		if (tty->ops->flush_chars)
 			tty->ops->flush_chars(tty);
 	}
-- 
1.8.1.2

