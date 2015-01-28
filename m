Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbbA2JAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755038AbbA2JAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 150/176] time: settimeofday: Validate the values of tv from user
Date: Wed, 28 Jan 2015 15:29:40 +0100
Message-Id: <cc81198cf96e55b1344ef451d223a47a35f3c0ea.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6ada1fc0e1c4775de0e043e1bd3ae9d065491aa5 upstream.

An unvalidated user input is multiplied by a constant, which can result in
an undefined behaviour for large values. While this is validated later,
we should avoid triggering undefined behaviour.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
[jstultz: include trivial milisecond->microsecond correction noticed
by Andy]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/time.h | 13 +++++++++++++
 kernel/time.c        |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b2e5af..7d532a32ff3a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -173,6 +173,19 @@ extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 extern void get_monotonic_boottime(struct timespec *ts);
 
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
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
diff --git a/kernel/time.c b/kernel/time.c
index 3c49ab45f822..3eb322e518a3 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -195,6 +195,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
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
2.2.2

