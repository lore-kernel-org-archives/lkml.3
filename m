Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3GVVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:01:52 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3228 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673Ab3GVVBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:01:49 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 17:01:49 EDT
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <john.stultz@linaro.org>,
        <devel@driverdev.osuosl.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH] staging: android: logger: Correct write offset reset on error
Date: Mon, 22 Jul 2013 13:51:42 -0700
Message-ID: <1374526302-21371-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karlis Ogsts <karlis.ogsts@sonymobile.com>

In the situation that a writer fails to copy data from userspace it will reset
the write offset to the value it had before it went to sleep. This discarding
any messages written while aquiring the mutex.

Therefore the reset offset needs to be retrieved after acquiring the mutex.

Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/staging/android/logger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 080abf2..a8c3444 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -469,7 +469,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -490,6 +490,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now
-- 
1.8.2.2

