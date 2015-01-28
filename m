Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbbA1Bi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbbA1BiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.14 16/77] time: settimeofday: Validate the values of tv from user
Date: Tue, 27 Jan 2015 17:26:54 -0800
Message-Id: <20150128012746.451910908@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/time.h |   13 +++++++++++++
 kernel/time.c        |    4 ++++
 2 files changed, 17 insertions(+)

--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -173,6 +173,19 @@ extern void getboottime(struct timespec
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
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -195,6 +195,10 @@ SYSCALL_DEFINE2(settimeofday, struct tim
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


