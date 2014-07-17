Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbaGQOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:09:57 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:43605 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbaGQOJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:09:17 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] printk: insert newline in devkmsg_read()
Date: Thu, 17 Jul 2014 09:09:10 -0500
Message-Id: <1405606151-19875-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405606151-19875-1-git-send-email-elder@linaro.org>
References: <1405606151-19875-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a log record has LOG_PREFIX set, its predecessor record should be
terminated if it was marked LOG_CONT.  In devkmsg_read(), this
condition was being ignored, which would lead to such records
showing up combined when reading /dev/kmsg.  Fix this oversight.

Reported-by: Petr Mládek <pmladek@suse.cz>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e5ee1cb..3174ba9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	char cont;
 	size_t len;
 	ssize_t ret;
+	bool insert_newline;
 
 	if (!user)
 		return -EBADF;
@@ -626,7 +627,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	else
 		cont = '-';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
+	/* Insert a newline if we're terminating the previous record early */
+	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
+	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
+		      insert_newline ? "\n" : "",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
 	user->prev = msg->flags;
-- 
1.9.1

