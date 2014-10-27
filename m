Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJ0Sw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:52:26 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63033 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJ0SwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:52:24 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3.18-rc2] staging: android: logger: Fix log corruption regression
Date: Mon, 27 Oct 2014 18:51:43 +0000
Message-Id: <1414435903-20002-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit cd678fce4280 ("switch logger to ->write_iter()"), any
attempt to write to the log results in the log data being written over
its own metadata, thus rendering the log unreadable.

The problem was first detected when I ran an Android userspace on the
v3.18-rc1 kernel. However the issue can also be observed with a
non-Android userspace by using echo/cat to write to/from /dev/log_main .

This patch resolves the problem by using a temporary to track the status
of not-yet-committed writes to the log buffer.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/staging/android/logger.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 28b93d3..a673ffa 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -420,7 +420,7 @@ static ssize_t logger_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct logger_log *log = file_get_log(iocb->ki_filp);
 	struct logger_entry header;
 	struct timespec now;
-	size_t len, count;
+	size_t len, count, w_off;

 	count = min_t(size_t, iocb->ki_nbytes, LOGGER_ENTRY_MAX_PAYLOAD);

@@ -452,11 +452,14 @@ static ssize_t logger_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	memcpy(log->buffer + log->w_off, &header, len);
 	memcpy(log->buffer, (char *)&header + len, sizeof(header) - len);

-	len = min(count, log->size - log->w_off);
+	/* Work with a copy until we are ready to commit the whole entry */
+	w_off =  logger_offset(log, log->w_off + sizeof(struct logger_entry));

-	if (copy_from_iter(log->buffer + log->w_off, len, from) != len) {
+	len = min(count, log->size - w_off);
+
+	if (copy_from_iter(log->buffer + w_off, len, from) != len) {
 		/*
-		 * Note that by not updating w_off, this abandons the
+		 * Note that by not updating log->w_off, this abandons the
 		 * portion of the new entry that *was* successfully
 		 * copied, just above.  This is intentional to avoid
 		 * message corruption from missing fragments.
@@ -470,7 +473,7 @@ static ssize_t logger_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EFAULT;
 	}

-	log->w_off = logger_offset(log, log->w_off + count);
+	log->w_off = logger_offset(log, w_off + count);
 	mutex_unlock(&log->mutex);

 	/* wake up any blocked readers */
--
1.9.3

