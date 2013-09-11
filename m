Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3IKXMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:12:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3IKXKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:10:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4hm95Fx-EiAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=b1g25_LNKFoA:10 a=P9AO8p_xAAAA:8 a=n8i27M1mAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=erSWKhhUCcwA:10 a=rXZLD9m7qZoA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.114787881@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [095/251] staging: android: logger: Correct write offset reset on error
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0095-staging-android-logger-Correct-write-offset-reset-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Karlis Ogsts <karlis.ogsts@sonymobile.com>

[ Upstream commit 72bb99cfe9c57d2044445fb34bbc95b4c0bae6f2 ]

In the situation that a writer fails to copy data from userspace it will reset
the write offset to the value it had before it went to sleep. This discarding
any messages written while aquiring the mutex.

Therefore the reset offset needs to be retrieved after acquiring the mutex.

Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/android/logger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index f7b8237d5..e5b797c 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -359,7 +359,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t ppos)
 {
 	struct logger_log *log = file_get_log(iocb->ki_filp);
-	size_t orig = log->w_off;
+	size_t orig;
 	struct logger_entry header;
 	struct timespec now;
 	ssize_t ret = 0;
@@ -378,6 +378,8 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	mutex_lock(&log->mutex);
 
+	orig = log->w_off;
+
 	/*
 	 * Fix up any readers, pulling them forward to the first readable
 	 * entry after (what will be) the new write offset. We do this now
-- 
1.7.10.4


