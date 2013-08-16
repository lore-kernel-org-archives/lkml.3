Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3HPWxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:53:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51866 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3HPWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Android Kernel Team <kernel-team@android.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 027/133] staging: android: logger: Correct write offset reset on error
Date: Fri, 16 Aug 2013 15:32:49 -0700
Message-Id: <1376692475-28413-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/android/logger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index dbc63cb..316cb2c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -371,7 +371,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -390,6 +390,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now
-- 
1.8.1.2

