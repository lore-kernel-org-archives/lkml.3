Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3KZVx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:53:57 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:51406 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3KZVxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:53:55 -0500
Date: Tue, 26 Nov 2013 14:53:49 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: tty/serial eating \n regression in 3.13-rc1
Message-ID: <20131126215349.GA4818@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

I have been testing 3.13-rc1 and I noticed a change in behavior in the
tty/serial layer. Specifically I have a login running on serial that
presents the usual login:/password: prompt.

3.10.12 does this:

login: admin
password: 
prompt>

While 3.13-rc1 does this:

login: admin
password: prompt>

That is to say, a \n got lost. I have also noticed while using the
serial console that '\n's are occasionally lost, and the lossage is
highly repeatable and seemingly based on number of chars being output
in a burst, eg entering 'foo bar' at a shell prompt might loose the \n,
while entering 'foo bar ' will not.

I ran a full git bisect search and determined that the attached patch
introduced the problem.

This seems like a bug - at least the commit comment seems like it
should not cause any change in behaviour. I can reproduce it and help
debug, if you can give some guidance, I am not a tty layer expert :)

I have seen this bug on ppc with an out-of-tree serial driver, and on
ARM kirkwood with the serial8250 driver. I did the bisection search on
PPC.

good 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376 Linux 3.10
bad 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae Linux 3.13-rc1
good 6e4664525b1db28f8c4e1130957f70a94c19213e Linux 3.11
bad 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 Linux 3.12

bad cc998ff8811530be521f6b316f37ab7676a07938
bad 816434ec4a674fcdb3c2221a6dffdc8f34020550
good 751144271f4b63d5de9005ea4e5e6e5c7c6fd629
bad 40031da445fb4d269af9c7c445b2adf674f171e7
bad f66c83d059d1ed90968caa81d401f160912b063a

bad 1ef39808ca27837017a433f94aa7055cb8490e80 serial: sirf: add DT-binding document to describle detailed properties
bad 10d8b34a421716d55a4ff7c2d427c35e88b8fd60 serial: max310x: Driver rework
good 0f56bd2f6a97d8b0eb5c8f9bc04b83a6c16d1d48 tty: Use non-atomic state to signal flip buffer flush pending
bad a1dd30e9b4c38a4a177106741b03ac6a55777286 n_tty: Special case EXTPROC receive_buf() as raw mode
bad 29c7c5ca36d9c132cf9c37a09bc43626e790fb4c n_tty: Eliminate counter in __process_echoes
good addaebccf63a8c9f7c7a62ce1ceb9da4307c5a1c n_tty: Use separate head and tail indices for echo_buf
good 019ebdf9f26fd2e43b9e1af576835183e95dc82e n_tty: Eliminate echo_commit memory barrier
bad bc5b1ec5860a9bf52842be4a3a9d96e19f06c11d (*) n_tty: Only flush echo output if actually output
bad cbfd0340ae1993378fd47179db949e050e16e697 n_tty: Process echoes in blocks

==> cbfd0340ae1993378fd47179db949e050e16e697

Thanks,
Jason

>From cbfd0340ae1993378fd47179db949e050e16e697 Mon Sep 17 00:00:00 2001
From: Peter Hurley <peter@hurleysoftware.com>
Date: Sat, 15 Jun 2013 10:04:26 -0400
Subject: [PATCH] n_tty: Process echoes in blocks

Byte-by-byte echo output is painfully slow, requiring a lock/unlock
cycle for every input byte.

Instead, perform the echo output in blocks of 256 characters, and
at least once per flip buffer receive. Enough space is reserved in
the echo buffer to guarantee a full block can be saved without
overrunning the echo output. Overrun is prevented by discarding
the oldest echoes until enough space exists in the echo buffer
to receive at least a full block of new echoes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c | 70 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0f76b90..20983af 100644
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

