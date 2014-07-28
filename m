Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaG1N3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:29:30 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60955 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaG1N31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:27 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 6/7] printk: honor LOG_PREFIX in msg_print_text()
Date: Mon, 28 Jul 2014 08:29:19 -0500
Message-Id: <1406554160-9562-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a problem similar to what was addressed in the
previous patch.

All paths that read and format log records (for consoles, and for
reading via syslog and /dev/kmsg) go through msg_print_text().  That
function starts with some logic to determine whether the given log
record when formatted should begin with a "prefix" string, and
whether it should end with a newline.  That logic has a bug.

The LOG_PREFIX flag in a log record indicates that when it's
formatted, a log record should include a prefix.  This is used to
force a record to begin a new line--even if its preceding log record
contained LOG_CONT (indicating its content should be combined with
the next record).

Like the previous patch, the problem occurs when these flags are
all set:
    prev & LOG_CONT
    msg->flags & LOG_PREFIX
    msg->flags & LOG_CONT
In that case, "prefix" should be true but it is not.

The fix involves checking LOG_PREFIX when a message has its LOG_CONT
flag set, and in that case allowing "prefix" to become false only
if LOG_PREFIX is not set.  I.e., the logic for "prefix" would become:

    if (prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
        prefix = false;
    if (msg->flags & LOG_CONT)
        if (prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
            prefix = false;

However, note that this makes the (msg->flags & LOG_CONT) block
redunant--it's handled by the test just above it.  The result
becomes quite a bit simpler than before.

The following table concisely defines the problem:

     prev | msg  | msg  ||
     CONT |PREFIX| CONT ||prefix
    ------+------+------++------
     clear| clear| clear||  true
     clear| clear|  set ||  true
     clear|  set | clear||  true
     clear|  set |  set ||  true
      set | clear| clear|| false
      set | clear|  set || false
      set |  set | clear||  true
      set |  set |  set || false    <-- should be true

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1eb07f4..982873b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1006,11 +1006,8 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
 		prefix = false;
 
-	if (msg->flags & LOG_CONT) {
-		if (prev & LOG_CONT)
-			prefix = false;
+	if (msg->flags & LOG_CONT)
 		newline = false;
-	}
 
 	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
 		if (buf)
-- 
1.9.1

