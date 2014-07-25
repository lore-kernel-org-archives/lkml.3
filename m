Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbaGYQtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:49:53 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65369 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbaGYQtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:49:51 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH] staging: dgnc: remove commented code
Date: Sat, 26 Jul 2014 01:49:01 +0900
Message-Id: <1406306941-3053-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes commented code in dgnc driver.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_cls.c   |    5 +-
 drivers/staging/dgnc/dgnc_trace.c |  123 -------------------------------------
 drivers/staging/dgnc/dgnc_trace.h |   10 ---
 drivers/staging/dgnc/dgnc_tty.c   |   18 ------
 drivers/staging/dgnc/digi.h       |    1 -
 5 files changed, 1 insertion(+), 156 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index 8e265c2..4b65306 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -1046,10 +1046,7 @@ static void cls_flush_uart_read(struct channel_t *ch)
 	 * I believe this is a BUG in this UART.
 	 * So for now, we will leave the code #ifdef'ed out...
 	 */
-#if 0
-	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR),
-					 &ch->ch_cls_uart->isr_fcr);
-#endif
+
 	udelay(10);
 }
 
diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
index 2f62f2a..d764154 100644
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ b/drivers/staging/dgnc/dgnc_trace.c
@@ -50,129 +50,6 @@ static int dgnc_trcbufi = 0;		/* index of the tilde at the end of */
 static DEFINE_SPINLOCK(dgnc_tracef_lock);
 #endif
 
-
-#if 0
-
-#if !defined(TRC_TO_KMEM) && !defined(TRC_TO_CONSOLE)
-
-void dgnc_tracef(const char *fmt, ...)
-{
-	return;
-}
-
-#else /* !defined(TRC_TO_KMEM) && !defined(TRC_TO_CONSOLE) */
-
-void dgnc_tracef(const char *fmt, ...)
-{
-	va_list		ap;
-	char		buf[TRC_MAXMSG+1];
-	size_t		lenbuf;
-	int		i;
-	static int	failed = FALSE;
-# if defined(TRC_TO_KMEM)
-	unsigned long	 flags;
-#endif
-
-	if (failed)
-		return;
-# if defined(TRC_TO_KMEM)
-	DGNC_LOCK(dgnc_tracef_lock, flags);
-#endif
-
-	/* Format buf using fmt and arguments contained in ap. */
-	va_start(ap, fmt);
-	i = vsprintf(buf, fmt,  ap);
-	va_end(ap);
-	lenbuf = strlen(buf);
-
-# if defined(TRC_TO_KMEM)
-	{
-		static int	 initd = 0;
-
-		/*
-		 * Now, in addition to (or instead of) printing this stuff out
-		 * (which is a buffered operation), also tuck it away into a
-		 * corner of memory which can be examined post-crash in kdb.
-		 */
-		if (!initd) {
-			dgnc_trcbuf = (char *) vmalloc(dgnc_trcbuf_size);
-			if (!dgnc_trcbuf) {
-				failed = TRUE;
-				printk("dgnc: tracing init failed!\n");
-				return;
-			}
-
-			memset(dgnc_trcbuf, '\0',  dgnc_trcbuf_size);
-			dgnc_trcbufi = 0;
-			initd++;
-
-			printk("dgnc: tracing enabled - " TRC_DTRC
-				" 0x%lx 0x%x\n",
-				(unsigned long)dgnc_trcbuf,
-				dgnc_trcbuf_size);
-		}
-
-#  if defined(TRC_ON_OVERFLOW_WRAP_AROUND)
-		/*
-		 * This is the less CPU-intensive way to do things.  We simply
-		 * wrap around before we fall off the end of the buffer.  A
-		 * tilde (~) demarcates the current end of the trace.
-		 *
-		 * This method should be used if you are concerned about race
-		 * conditions as it is less likely to affect the timing of
-		 * things.
-		 */
-
-		if (dgnc_trcbufi + lenbuf >= dgnc_trcbuf_size) {
-			/* We are wrapping, so wipe out the last tilde. */
-			dgnc_trcbuf[dgnc_trcbufi] = '\0';
-			/* put the new string at the beginning of the buffer */
-			dgnc_trcbufi = 0;
-		}
-
-		strcpy(&dgnc_trcbuf[dgnc_trcbufi], buf);
-		dgnc_trcbufi += lenbuf;
-		dgnc_trcbuf[dgnc_trcbufi] = '~';
-
-#  elif defined(TRC_ON_OVERFLOW_SHIFT_BUFFER)
-		/*
-		 * This is the more CPU-intensive way to do things.  If we
-		 * venture into the last 1/8 of the buffer, we shift the
-		 * last 7/8 of the buffer forward, wiping out the first 1/8.
-		 * Advantage: No wrap-around, only truncation from the
-		 * beginning.
-		 *
-		 * This method should not be used if you are concerned about
-		 * timing changes affecting the behaviour of the driver (ie,
-		 * race conditions).
-		 */
-		strcpy(&dgnc_trcbuf[dgnc_trcbufi], buf);
-		dgnc_trcbufi += lenbuf;
-		dgnc_trcbuf[dgnc_trcbufi] = '~';
-		dgnc_trcbuf[dgnc_trcbufi+1] = '\0';
-
-		/* If we're near the end of the trace buffer... */
-		if (dgnc_trcbufi > (dgnc_trcbuf_size/8)*7) {
-			/* Wipe out the first eighth to make some more room. */
-			strcpy(dgnc_trcbuf, &dgnc_trcbuf[dgnc_trcbuf_size/8]);
-			dgnc_trcbufi = strlen(dgnc_trcbuf)-1;
-			/* Plop overflow message at the top of the buffer. */
-			bcopy(TRC_OVERFLOW, dgnc_trcbuf, strlen(TRC_OVERFLOW));
-		}
-#  else
-#   error "TRC_ON_OVERFLOW_WRAP_AROUND or TRC_ON_OVERFLOW_SHIFT_BUFFER?"
-#  endif
-	}
-	DGNC_UNLOCK(dgnc_tracef_lock, flags);
-
-# endif /* defined(TRC_TO_KMEM) */
-}
-
-#endif /* !defined(TRC_TO_KMEM) && !defined(TRC_TO_CONSOLE) */
-
-#endif
-
-
 /*
  * dgnc_tracer_free()
  *
diff --git a/drivers/staging/dgnc/dgnc_trace.h b/drivers/staging/dgnc/dgnc_trace.h
index efed88a..4f4e2b9 100644
--- a/drivers/staging/dgnc/dgnc_trace.h
+++ b/drivers/staging/dgnc/dgnc_trace.h
@@ -28,16 +28,6 @@
 
 #include "dgnc_driver.h"
 
-#if 0
-
-# if !defined(TRC_TO_KMEM) && !defined(TRC_TO_CONSOLE)
-   void dgnc_tracef(const char *fmt, ...);
-# else
-   void dgnc_tracef(const char *fmt, ...);
-# endif
-
-#endif
-
 void dgnc_tracer_free(void);
 
 #endif
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 714a069..453efce 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -2107,24 +2107,6 @@ static int dgnc_tty_write(struct tty_struct *tty,
 		ch->ch_w_head = head;
 	}
 
-#if 0
-	/*
-	 * If this is the print device, and the
-	 * printer is still on, we need to turn it
-	 * off before going idle.
-	 */
-	if (count == orig_count) {
-		if ((un->un_type == DGNC_PRINT) && (ch->ch_flags & CH_PRON)) {
-			head &= tmask;
-			ch->ch_w_head = head;
-			dgnc_wmove(ch, ch->ch_digi.digi_offstr,
-				(int) ch->ch_digi.digi_offlen);
-			head = (ch->ch_w_head) & tmask;
-			ch->ch_flags &= ~CH_PRON;
-		}
-	}
-#endif
-
 	/* Update printer buffer empty time. */
 	if ((un->un_type == DGNC_PRINT) && (ch->ch_digi.digi_maxcps > 0)
 	    && (ch->ch_digi.digi_bufsize > 0)) {
diff --git a/drivers/staging/dgnc/digi.h b/drivers/staging/dgnc/digi.h
index 282908f..2527918 100644
--- a/drivers/staging/dgnc/digi.h
+++ b/drivers/staging/dgnc/digi.h
@@ -402,7 +402,6 @@ struct digi_getcounter {
 
 #define EV_IPU		0x0010		/* !<Input paused unconditionally by user */
 #define EV_IPS		0x0020		/* !<Input paused by high/low water marks */
-/* #define EV_IPH	0x0040		//!<Input paused w/ hardware */
 #define EV_IPA		0x0400		/* !<Input paused by pattern alarm module */
 
 #define EV_TXB		0x0040		/* !<Transmit break pending */
-- 
1.7.9.5

