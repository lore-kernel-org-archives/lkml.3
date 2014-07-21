Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaGUNDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:03:48 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54810 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaGUNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:02:43 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/7] printk: honor LOG_PREFIX in devkmsg_read()
Date: Mon, 21 Jul 2014 08:02:39 -0500
Message-Id: <1405947761-26004-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405947761-26004-1-git-send-email-elder@linaro.org>
References: <1405947761-26004-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In devkmsg_read(), a variable "cont" holds a character that's used
to indicate whether a given log line is a "continuation", that is,
whether a log record should be merged with the one before or after
it.  If a record should be merged with its successor (but not its
predecessor) that character is 'c'.  And the line following such a
'c' log record is normally marked with a '+' to show it is continues
its predecessor.  Any other cases are marked '-', indicating the
log record stands on its own.

There is an exception.  If a log record is marked LOG_PREFIX, it
indicates that this record represents a new log entry, implicitly
terminating the predecessor--even if the predecessor would otherwise
have been continued.  So a record marked LOG_PREFIX (that is not
also marked LOG_CONT) should have '-' for its "cont" variable.

The logic that determines this "continuation" character has a bug
that gets that exceptional case wrong.

The specific case that produces the wrong result is when all of
these conditions are non-zero:
    user->prev & LOG_CONT
    msg->flags & LOG_PREFIX
    msg->flags & LOG_CONT
The bug is that despite the message's LOG_PREFIX flag, the
"cont" character is getting set to '+' rather than 'c'.

The problem is that the message's LOG_PREFIX flag is getting
ignored if its LOG_CONT flag is also set.  Rearrange the logic
here to produce the correct result.

The following table concisely defines the problem:

     prev | msg  | msg  ||"cont"
     CONT |PREFIX| CONT || char
    ------+------+------++------
     clear| clear| clear||  '-'
     clear| clear|  set ||  'c'
     clear|  set | clear||  '-'
     clear|  set |  set ||  'c'
      set | clear| clear||  '+'
      set | clear|  set ||  '+'
      set |  set | clear||  '-'
      set |  set |  set ||  '+'     <-- should be 'c'

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 217a02a..e9e5104 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -572,7 +572,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	struct printk_log *msg;
 	u64 ts_usec;
 	size_t i;
-	char cont = '-';
+	char cont;
 	size_t len;
 	ssize_t ret;
 	bool insert_newline;
@@ -620,11 +620,12 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
 	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
-		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
+	if ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
 		cont = '+';
+	else if (msg->flags & LOG_CONT)
+		cont = 'c';
+	else
+		cont = '-';
 
 	/* Insert a newline if the previous line was not terminated properly */
 	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
-- 
1.9.1

