Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbaGPR1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:27:08 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:61042 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbaGPR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:27:04 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] printk: LOG_CONT and LOG_NEWLINE are separate
Date: Wed, 16 Jul 2014 12:26:57 -0500
Message-Id: <1405531620-9983-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405531620-9983-1-git-send-email-elder@linaro.org>
References: <1405531620-9983-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two log record flags--LOG_CONT and LOG_NEWLINE--are never both set
at the same time in a log record flags field.  What follows is a
great deal of explanation that aims to prove this assertion.

Having that knowledge allows us to simplify a bit of logic though,
and with a little more work (in follow-on patches) it allows us to
do without some flag values, considerably simplifying things.

So this patch leverages the one-or-the-other nature of these two
flags to simplify a small bit of logic.  It makes a some other small
changes to make it obvious that a few things in surrounding (and
related) code are invariant.

Log record flags are held in the "cont" continuation buffer, as well
as in "syslog_prev" and "console_prev".  Those are discussed later.
Other than that, log record flags are only set in log_store():
        msg->flags = flags & 0x1f;
There are 5 places log_store() is called:  twice from cont_flush();
and three times from vprintk_emit().

Only two single-flag values are ever passed to cont_flush():
LOG_CONT; and LOG_NEWLINE.  That passed-in value is provided by
cont_flush() to log_store() either as-is, or modified to include
LOG_NOCONS.  There are thus four possible flag combinations supplied
to log_store() by cont_flush():  LOG_CONT; LOG_NEWLINE;
LOG_CONT|LOG_NOCONS; or LOG_NEWLINE|LOG_NOCONS.

The first call vprintk_emit() makes to log_store() passes a flags
value of LOG_PREFIX|LOG_NEWLINE.  The second and third calls pass a
computed "lflags" value, possibly with LOG_CONT added.  The only
possible flag combinations held in "lflags" are:  0; LOG_NEWLINE;
LOG_PREFIX; or LOG_NEWLINE|LOG_PREFIX.  And the LOG_CONT flag is
added only when LOG_NEWLINE is not set.  So there are six possible
flag combinations supplied by cont_flush():  0; LOG_NEWLINE;
LOG_PREFIX; LOG_CONT; LOG_PREFIX|LOG_CONT; or LOG_PREFIX|LOG_NEWLINE.

Therefore log_store() is never provided (so never records) a flag
value that contains both LOG_CONT and LOG_NEWLINE.

Meanwhile, the "cont" flags field is only ever assigned value 0, or
a value passed to cont_flush().  As mentioned above, cont_flush() is
never provided more than one flag value.  The only values assigned
to "syslog_prev" and "console_prev" are 0 or the flags value from
a log record.  So none of these ever hold LOG_CONT and LOG_NEWLINE
at the same time.

This proves that at most one of LOG_CONT and LOG_NEWLINE will ever
be set in a log record flags field.  And as a result, we know that
LOG_CONT being set implies LOG_NEWLINE is not set (and vice versa).

This patch makes the following changes:
    - Changes two spots in msg_print_txt() so they no longer bother
      checking for LOG_NEWLINE once its known that LOG_CONT is set.
    - Changes two |= assignments in vprintk_emit() to be simple
      assignments instead, because the result is known to be the
      same and it makes it obvious no other flags are involved.
    - Explicitly pass NULL rather than "dict" (and 0 as its length)
      to log_store() in one spot in vprintk_emit(), because we know
      the value of dict at that point is always NULL.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..301ade3 100644
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
 
 	do {
@@ -1642,7 +1640,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
-		lflags |= LOG_NEWLINE;
+		lflags = LOG_NEWLINE;
 	}
 
 	/* strip kernel syslog prefix and extract log level or control flags */
@@ -1672,7 +1670,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		level = default_message_loglevel;
 
 	if (dict)
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
+		lflags = LOG_PREFIX|LOG_NEWLINE;
 
 	if (!(lflags & LOG_NEWLINE)) {
 		/*
@@ -1688,7 +1686,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		else
 			printed_len += log_store(facility, level,
 						 lflags | LOG_CONT, 0,
-						 dict, dictlen, text, text_len);
+						 NULL, 0, text, text_len);
 	} else {
 		bool stored = false;
 
-- 
1.9.1

