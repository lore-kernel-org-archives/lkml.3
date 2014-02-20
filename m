Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaBTInM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:43:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54971 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaBTImi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:38 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-db-5305bffc2730
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 5/6] timerfd: Add support for deferrable timers
Date: Thu, 20 Feb 2014 12:40:32 +0400
Message-id: <1392885633-7787-6-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Nd0/+1mDDTZPUrKYe/c8i8Wc9WvY
	LC623maxOLhV06L/VyerxfUvz1ktzvzWtTjb9Ibd4vKuOWwWmzdNZXbg8pjQ/4nR4861PWwe
	786dY/c4MeM3i8eXPXuZPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSuj8fJSpoI3AhXTH99j
	b2Dcw9vFyMEhIWAi0T5LpYuRE8gUk7hwbz1bFyMXh5DAUkaJ/U9b2CGcHiaJn8sPs4M0sAkY
	SOy7ZwvSICLgI7Fr4kcmkBpmgSeMEqsP3mECSQgLOEnMvbQKzGYRUJW4/Hg6mM0r4CbRdOIg
	O8RiBYk5k2xATE4Bd4mGJzYgFUJAFQ+2/GGZwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpe
	cn7uJkZI+H3Zwbj4mNUhRgEORiUe3ojrLMFCrIllxZW5hxglOJiVRHh5MlmDhXhTEiurUovy
	44tKc1KLDzEycXBKNTAu6vj50zjV8MykjUFi3fsVl7K15b3VdNnyvc2M90hHaa+K9rfW6Jn2
	kiobPq0M33vnt43lnKZD0R/i9Hz2VXk/UJgr/P3WYWMTvwRZU8dbaX7VMw9GrVzpItfgO2tB
	6cP3cX38b/+YiL8L9bj5d2/NrEUvfP937eVY9esz5zxvc1UOrjUvmBmUWIozEg21mIuKEwEQ
	OBntHQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@enomsg.org>

This patch implements a userland-side API for generic deferrable timers,
per linux/timer.h:

 * A deferrable timer will work normally when the system is busy, but
 * will not cause a CPU to come out of idle just to service it; instead,
 * the timer will be serviced when the CPU eventually wakes up with a
 * subsequent non-deferrable timer.

These timers are crucial for power saving, i.e. periodic tasks that want
to work in background when the system is under use, but don't want to
cause wakeups themselves.

The deferred timers are somewhat orthogonal to high-res external timers,
since the deferred timer is tied to the system load, not just to some
external decrementer source.

Currently, the implementation is based on high resolution timers.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 3561ce7..c132fd2 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -231,7 +231,7 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
 
 static u64 timerfd_rearm(struct timerfd_ctx *ctx)
 {
-	u64 orun;
+	u64 orun = 0;
 
 	if (isalarm(ctx)) {
 		orun += alarm_forward_now(
@@ -326,7 +326,10 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	    (clockid != CLOCK_MONOTONIC &&
 	     clockid != CLOCK_REALTIME &&
 	     clockid != CLOCK_REALTIME_ALARM &&
-	     clockid != CLOCK_BOOTTIME_ALARM))
+	     clockid != CLOCK_BOOTTIME_ALARM &&
+	     clockid != CLOCK_REALTIME_DEFERRABLE &&
+	     clockid != CLOCK_MONOTONIC_DEFERRABLE &&
+	     clockid != CLOCK_BOOTTIME_DEFERRABLE))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -354,7 +357,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	return ufd;
 }
 
-static int do_timerfd_settime(int ufd, int flags, 
+static int do_timerfd_settime(int ufd, int flags,
 		const struct itimerspec *new,
 		struct itimerspec *old)
 {
-- 
1.7.9.5

