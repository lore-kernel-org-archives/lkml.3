Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab3FTL1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:27:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2729 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab3FTL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:27:40 -0400
X-Spam-Score: -100.8
Message-ID: <51C2E6F9.80107@asianux.com>
Date: Thu, 20 Jun 2013 19:26:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since copy_to_user() will check 'value', we do not need check it outside
again,  so can save one comparing instruction at least.

Also can let code simpler and easier for readers: if checking parameter
'value', it will easily lead readers to think about why not return
-EINVAL instead of -EFAULT, when checking parameter failed.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/itimer.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/itimer.c b/kernel/itimer.c
index 8d262b4..3b12271 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -102,15 +102,14 @@ int do_getitimer(int which, struct itimerval *value)
 
 SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
 {
-	int error = -EFAULT;
+	int error;
 	struct itimerval get_buffer;
 
-	if (value) {
-		error = do_getitimer(which, &get_buffer);
-		if (!error &&
-		    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
-			error = -EFAULT;
-	}
+	error = do_getitimer(which, &get_buffer);
+	if (!error &&
+	    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
+		error = -EFAULT;
+
 	return error;
 }
 
-- 
1.7.7.6
