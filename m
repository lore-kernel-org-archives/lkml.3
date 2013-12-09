Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab3LIPMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:12:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab3LIPMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:12:00 -0500
Date: Mon, 9 Dec 2013 10:10:50 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
cc: linux-kernel@vger.kernel.org, Karl Dahlke <eklhad@comcast.net>
Subject: [PATCH 3.12 v2] Broken terminal due to echo bufferring
Message-ID: <alpine.LRH.2.02.1312091004110.19590@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here I'm sending another version of the patch that removes some unneeded 
code for echo bufferring - 41 lines are removed.



From: mpatocka@redhat.com

I discovered that kernel 3.12 has broken terminal handling.

I created this program to show the problem:
#include <stdio.h>
#include <unistd.h>

int main(void)
{
        int c;
        while ((c = getchar()) != EOF) {
                if (c == '\n') write(1, "prompt>", 7);
        }
        return 0;
}

Each time the user presses enter, the program prints "prompt>". Normally, 
when you press enter, you should see:

prompt>
prompt>
prompt>
prompt>_

However, with kernel 3.12.4, you occasionally see

prompt>
prompt>
prompt>prompt>
_

This bug happens randomly, it is timing-dependent. I am using single-core 
600MHz processor with preemptible kernel, the bug may or may not happen on 
other computers.

This bug is caused by Peter Hurley's echo buffering patches 
(cbfd0340ae1993378fd47179db949e050e16e697). The patches change n_tty.c so 
that it accumulates echoed characters and sends them out in a batch. 
Something like this happens:

* The user presses enter
* n_tty.c adds '\n' to the echo buffer using echo_char_raw
* n_tty.c adds '\n' to the input queue using put_tty_queue
* A process is switched
* Userspace reads '\n' from the terminal input queue
* Userspace writes the string "prompt>" to the terminal
* A process is switched back
* The echo buffer is flushed
* '\n' from the echo buffer is printed.

Echo bufferring is fundamentally wrong idea - you must make sure that you 
flush the echo buffer BEFORE you add a character to input queue and BEFORE 
you send any signal on behalf of that character. If you delay echo, you 
are breaking behavior of various programs because the program output will 
be interleaved with the echoed characters.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com
Cc: stable@kernel.org	# 3.12

---
 drivers/tty/n_tty.c |   71 ++++++++++------------------------------------------
 1 file changed, 15 insertions(+), 56 deletions(-)

Index: linux-3.12.4/drivers/tty/n_tty.c
===================================================================
--- linux-3.12.4.orig/drivers/tty/n_tty.c	2013-12-09 15:47:22.401049994 +0100
+++ linux-3.12.4/drivers/tty/n_tty.c	2013-12-09 16:03:10.964942268 +0100
@@ -92,7 +92,6 @@ struct n_tty_data {
 	size_t read_head;
 	size_t canon_head;
 	size_t echo_head;
-	size_t echo_commit;
 	DECLARE_BITMAP(char_map, 256);
 
 	/* private to n_tty_receive_overrun (single-threaded) */
@@ -335,7 +334,7 @@ static inline void put_tty_queue(unsigne
 static void reset_buffer_flags(struct n_tty_data *ldata)
 {
 	ldata->read_head = ldata->canon_head = ldata->read_tail = 0;
-	ldata->echo_head = ldata->echo_tail = ldata->echo_commit = 0;
+	ldata->echo_head = ldata->echo_tail = 0;
 	ldata->line_start = 0;
 
 	ldata->erasing = 0;
@@ -655,7 +654,7 @@ static size_t __process_echoes(struct tt
 	old_space = space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
-	while (ldata->echo_commit != tail) {
+	while (ldata->echo_head != tail) {
 		c = echo_buf(ldata, tail);
 		if (c == ECHO_OP_START) {
 			unsigned char op;
@@ -766,7 +765,7 @@ static size_t __process_echoes(struct tt
 	/* If the echo buffer is nearly full (so that the possibility exists
 	 * of echo overrun before the next commit), then discard enough
 	 * data at the tail to prevent a subsequent overrun */
-	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
+	while (ldata->echo_head - tail >= ECHO_DISCARD_WATERMARK) {
 		if (echo_buf(ldata, tail) == ECHO_OP_START) {
 			if (echo_buf(ldata, tail + 1) == ECHO_OP_ERASE_TAB)
 				tail += 3;
@@ -780,37 +779,12 @@ static size_t __process_echoes(struct tt
 	return old_space - space;
 }
 
-static void commit_echoes(struct tty_struct *tty)
-{
-	struct n_tty_data *ldata = tty->disc_data;
-	size_t nr, old, echoed;
-	size_t head;
-
-	head = ldata->echo_head;
-	old = ldata->echo_commit - ldata->echo_tail;
-
-	/* Process committed echoes if the accumulated # of bytes
-	 * is over the threshold (and try again each time another
-	 * block is accumulated) */
-	nr = head - ldata->echo_tail;
-	if (nr < ECHO_COMMIT_WATERMARK || (nr % ECHO_BLOCK > old % ECHO_BLOCK))
-		return;
-
-	mutex_lock(&ldata->output_lock);
-	ldata->echo_commit = head;
-	echoed = __process_echoes(tty);
-	mutex_unlock(&ldata->output_lock);
-
-	if (echoed && tty->ops->flush_chars)
-		tty->ops->flush_chars(tty);
-}
-
 static void process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t echoed;
 
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
+	if (ldata->echo_head == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
@@ -821,19 +795,6 @@ static void process_echoes(struct tty_st
 		tty->ops->flush_chars(tty);
 }
 
-static void flush_echoes(struct tty_struct *tty)
-{
-	struct n_tty_data *ldata = tty->disc_data;
-
-	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_head)
-		return;
-
-	mutex_lock(&ldata->output_lock);
-	ldata->echo_commit = ldata->echo_head;
-	__process_echoes(tty);
-	mutex_unlock(&ldata->output_lock);
-}
-
 /**
  *	add_echo_byte	-	add a byte to the echo buffer
  *	@c: unicode byte to echo
@@ -1230,7 +1191,7 @@ n_tty_receive_signal_char(struct tty_str
 		start_tty(tty);
 	if (L_ECHO(tty)) {
 		echo_char(c, tty);
-		commit_echoes(tty);
+		process_echoes(tty);
 	}
 	isig(signal, tty);
 	return;
@@ -1262,7 +1223,7 @@ n_tty_receive_char_special(struct tty_st
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
-			commit_echoes(tty);
+			process_echoes(tty);
 			return 0;
 		}
 		if (c == STOP_CHAR(tty)) {
@@ -1301,7 +1262,7 @@ n_tty_receive_char_special(struct tty_st
 		if (c == ERASE_CHAR(tty) || c == KILL_CHAR(tty) ||
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {
 			eraser(c, tty);
-			commit_echoes(tty);
+			process_echoes(tty);
 			return 0;
 		}
 		if (c == LNEXT_CHAR(tty) && L_IEXTEN(tty)) {
@@ -1311,7 +1272,7 @@ n_tty_receive_char_special(struct tty_st
 				if (L_ECHOCTL(tty)) {
 					echo_char_raw('^', ldata);
 					echo_char_raw('\b', ldata);
-					commit_echoes(tty);
+					process_echoes(tty);
 				}
 			}
 			return 1;
@@ -1326,13 +1287,13 @@ n_tty_receive_char_special(struct tty_st
 				echo_char(read_buf(ldata, tail), tty);
 				tail++;
 			}
-			commit_echoes(tty);
+			process_echoes(tty);
 			return 0;
 		}
 		if (c == '\n') {
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				echo_char_raw('\n', ldata);
-				commit_echoes(tty);
+				process_echoes(tty);
 			}
 			goto handle_newline;
 		}
@@ -1352,7 +1313,7 @@ n_tty_receive_char_special(struct tty_st
 				if (ldata->canon_head == ldata->read_head)
 					echo_set_canon_col(ldata);
 				echo_char(c, tty);
-				commit_echoes(tty);
+				process_echoes(tty);
 			}
 			/*
 			 * XXX does PARMRK doubling happen for
@@ -1383,7 +1344,7 @@ handle_newline:
 				echo_set_canon_col(ldata);
 			echo_char(c, tty);
 		}
-		commit_echoes(tty);
+		process_echoes(tty);
 	}
 
 	if (parmrk)
@@ -1409,7 +1370,7 @@ n_tty_receive_char_inline(struct tty_str
 		if (ldata->canon_head == ldata->read_head)
 			echo_set_canon_col(ldata);
 		echo_char(c, tty);
-		commit_echoes(tty);
+		process_echoes(tty);
 	}
 	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 	if (parmrk)
@@ -1437,7 +1398,7 @@ n_tty_receive_char_fast(struct tty_struc
 		if (ldata->canon_head == ldata->read_head)
 			echo_set_canon_col(ldata);
 		echo_char(c, tty);
-		commit_echoes(tty);
+		process_echoes(tty);
 	}
 	put_tty_queue(c, ldata);
 }
@@ -1661,9 +1622,7 @@ static void __receive_buf(struct tty_str
 		else
 			n_tty_receive_buf_standard(tty, cp, fp, count);
 
-		flush_echoes(tty);
-		if (tty->ops->flush_chars)
-			tty->ops->flush_chars(tty);
+		process_echoes(tty);
 	}
 
 	if ((!ldata->icanon && (read_cnt(ldata) >= ldata->minimum_to_wake)) ||
