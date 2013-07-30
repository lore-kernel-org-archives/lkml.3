Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3G3Jit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:38:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab3G3Jdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Android Kernel Team <kernel-team@android.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 091/106] staging: android: logger: Correct write offset reset on error
Date: Tue, 30 Jul 2013 10:31:50 +0100
Message-Id: <1375176725-5825-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karlis Ogsts <karlis.ogsts@sonymobile.com>

commit 72bb99cfe9c57d2044445fb34bbc95b4c0bae6f2 upstream.

In the situation that a writer fails to copy data from userspace it will reset
the write offset to the value it had before it went to sleep. This discarding
any messages written while aquiring the mutex.

Therefore the reset offset needs to be retrieved after acquiring the mutex.

Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/android/logger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b2e71c6..6a3c74a 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -357,7 +357,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -376,6 +376,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now
-- 
1.8.3.2

