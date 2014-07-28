Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaG1Na0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:30:26 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:59672 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG1N3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:24 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/7] printk: LOG_CONT and LOG_NEWLINE are opposites
Date: Mon, 28 Jul 2014 08:29:17 -0500
Message-Id: <1406554160-9562-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two log record flags--LOG_CONT and LOG_NEWLINE--are mutually
exclusive.  That is, one or the other is always set, but they are
never both set at the same time in a log record flags field.  What
follows is a great deal of explanation that aims to prove this
assertion.

Having that knowledge allows us to simplify a bit of logic, and with
a little more work (in follow-on patches) it allows us to do without
a flag value, simplifying things.


Log record flags are held in the "cont" continuation buffer, as well
as in "syslog_prev" and "console_prev".  Those are discussed later.

Other than that, log record flags are only set in log_store():
    msg->flags = flags & 0x1f;
There are 5 places log_store() is called:  twice from cont_flush();
and three times from vprintk_emit().

Only two single-flag values are ever passed to cont_flush():
LOG_CONT; and LOG_NEWLINE.  That passed-in value is provided to
log_store() either as-is, or modified to include LOG_NOCONS.  There
are thus four possible flag combinations supplied to log_store() by
cont_flush():  LOG_CONT; LOG_NEWLINE; LOG_CONT|LOG_NOCONS; or
LOG_NEWLINE|LOG_NOCONS.

The first call vprintk_emit() makes to log_store() passes a flags
value of LOG_PREFIX|LOG_NEWLINE.  The second and third calls pass a
locally-computed "lflags" value, possibly with LOG_CONT added.  The
only possible flag combinations held in "lflags" are:  0;
LOG_NEWLINE; LOG_PREFIX; or LOG_NEWLINE|LOG_PREFIX.  If LOG_NEWLINE
is not set, LOG_CONT flag is added in the call to log_store().  So
there are four possible flag combinations supplied by vprintk_emit():
LOG_CONT; LOG_NEWLINE; LOG_PREFIX|LOG_CONT; or LOG_PREFIX|LOG_NEWLINE.

Therefore log_store() is never provided (so never records) a flag
value that contains both LOG_CONT and LOG_NEWLINE, and one of those
flags is always present.


Meanwhile, the "cont" flags field is only ever assigned value 0, or
a value passed to cont_flush().  The value of cont.flags is only
ever *used* if cont.flushed is true, and that only gets set after
the cont.flags field is assigned to the value passed to
cont_flush().  As mentioned above, cont_flush() is never provided
more than one flag value, and it's always either LOG_NEWLINE
or LOG_CONT.  Therefore, for all intents and purposes, cont.flags
only ever holds LOG_NEWLINE or LOG_CONT.

The only values assigned to "syslog_prev" and "console_prev" are the
initial value LOG_NEWLINE or the flags value from a log record.  So
none of these ever hold LOG_CONT and LOG_NEWLINE at the same time.

This proves that at LOG_CONT and LOG_NEWLINE are in fact mutually
exclusive flags.

This patch makes the following changes:
    - Changes two spots in msg_print_txt() so they no longer bother
      checking for LOG_NEWLINE once its known that LOG_CONT is set.
    - Changes two |= assignments in vprintk_emit() to be simple
      assignments instead, because the result is known to be the
      same and it makes it obvious no other flags are involved.
    - Assigns LOG_CONT to "lflags" in vprintk_emit() if it does not
      contain LOG_NEWLINE (rather than just adding it at the time
      of the call to log_store()).
    - Adds a short explanatory comment.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5c32938..4b063c8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1006,11 +1006,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 		prefix = false;
 
 	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
+		if (prev & LOG_CONT)
 			prefix = false;
-
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
+		newline = false;
 	}
 
 	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
@@ -1657,10 +1655,16 @@ asmlinkage int vprintk_emit(int facility, int level,
 	text_len += vscnprintf(text + text_len,
 			       sizeof(textbuf) - text_len, fmt, args);
 
-	/* mark and strip a trailing newline */
+	/*
+	 * If there's a trailing newline, flag it and strip it off.
+	 * Otherwise we assume this is a partial log message, to be
+	 * continued with the next call.
+	 */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
-		lflags |= LOG_NEWLINE;
+		lflags = LOG_NEWLINE;
+	} else {
+		lflags = LOG_CONT;
 	}
 
 	/* strip kernel syslog prefix and extract log level or control flags */
@@ -1690,7 +1694,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		level = default_message_loglevel;
 
 	if (dict)
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
+		lflags = LOG_PREFIX|LOG_NEWLINE;
 
 	if (!(lflags & LOG_NEWLINE)) {
 		/*
@@ -1704,8 +1708,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		if (cont_add(facility, level, text, text_len))
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level,
-						 lflags | LOG_CONT, 0,
+			printed_len += log_store(facility, level, lflags, 0,
 						 dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
-- 
1.9.1

