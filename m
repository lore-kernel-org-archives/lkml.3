Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbbAGSNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:13:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34670 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbbAGSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:12:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/2] time: settimeofday: Validate the values of tv from user
Date: Wed,  7 Jan 2015 10:12:19 -0800
Message-Id: <1420654340-3009-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
References: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

An unvalidated user input is multiplied by a constant, which can result in
an undefined behaviour for large values. While this is validated later,
we should avoid triggering undefined behaviour.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
[jstultz: include trivial milisecond->microsecond correction noticed
by Andy]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h | 13 +++++++++++++
 kernel/time/time.c   |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/time.h b/include/linux/time.h
index 8c42cf8..5989b0e 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -99,6 +99,19 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
+static inline bool timeval_valid(const struct timeval *tv)
+{
+	/* Dates before 1970 are bogus */
+	if (tv->tv_sec < 0)
+		return false;
+
+	/* Can't have more microseconds then a second */
+	if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
+		return false;
+
+	return true;
+}
+
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20f..22d5d3b 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -196,6 +196,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
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
1.9.1

