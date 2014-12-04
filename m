Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaLDAXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:23:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44529 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLDAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:23:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] time: settimeofday: validate the values of tv from user
Date: Wed,  3 Dec 2014 19:22:48 -0500
Message-Id: <1417652569-1649-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unvalidated user input is multiplied by a constant, which can result in
an undefined behaviour for large values. While this is validated later,
we should avoid triggering undefined behaviour.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/time.h |   13 +++++++++++++
 kernel/time/time.c   |    4 ++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/time.h b/include/linux/time.h
index 203c2ad..851d822 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -110,6 +110,19 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+static inline bool timeval_valid(const struct timeval *tv)
+{
+	/* Dates before 1970 are bogus */
+	if (tv->tv_sec < 0)
+		return false;
+
+	/* Can't have more miliseconds then a second */
+	if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
+		return false;
+
+	return true;
+}
+
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 58c4c7c..d54ca39 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -200,6 +200,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
 	if (tv) {
 		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
 			return -EFAULT;
+
+		if (!timeval_valid(&user_tv))
+			return -EINVAL;
+
 		new_ts.tv_sec = user_tv.tv_sec;
 		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
 	}
-- 
1.7.10.4

