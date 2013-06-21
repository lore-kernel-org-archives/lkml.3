Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400Ab3FUKcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:32:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17825 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3FUKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:32:12 -0400
X-Spam-Score: -100.8
Message-ID: <51C42B75.7040204@asianux.com>
Date: Fri, 21 Jun 2013 18:31:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] kernel/itimer.c: remove the checking 'value' statement
References: <51C2E6F9.80107@asianux.com> <alpine.DEB.2.02.1306201458100.4013@ionos.tec.linutronix.de> <51C3B4B4.90603@asianux.com>
In-Reply-To: <51C3B4B4.90603@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since copy_to_user() will process "bad address" internally, we need not
check 'value' again, then can save one comparing instruction at least.

For some embedded system with NOMMU, 'NULL' may not mean "bad address"
(EFAULT), so recommend to let copy_to_user() to check 'EFAULT' in this
case, completely.

Removing the checking code, also can let it simpler and clearer to
readers.


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

