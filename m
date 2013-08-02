Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3HBKJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab3HBKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: [ 36/99] staging: android: logger: Correct write offset reset on error
Date: Fri,  2 Aug 2013 18:07:49 +0800
Message-Id: <20130802100231.104534668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/android/logger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -469,7 +469,7 @@ static ssize_t logger_aio_write(struct k
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -490,6 +490,8 @@ static ssize_t logger_aio_write(struct k
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now


