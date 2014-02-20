Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbaBTQZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:25:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27644 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbaBTQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:44 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-82-53062c4b5693
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v4 5/6] timerfd: Add support for deferrable timers
Date: Thu, 20 Feb 2014 20:23:44 +0400
Message-id: <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4NV1vHbZggwvnZC3m3j3PYjFn/Ro2
	i4utt1ksDm7VtLj+5TmrxZnfuhZnm96wW1zeNYfNYvOmqcwOnB4T+j8xety5tofN4925c+we
	J2b8ZvHo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujM7785kK/vNV/H77jrWBsY2ni5GTQ0LA
	RGL7iZ3sELaYxIV769m6GLk4hASWMkps+TuFGcLpYZKYO2sTUIaDg03AQGLfPVuQBhEBH4ld
	Ez8ygdQwC1xmlDjX+4QJJCEs4CSxqWsVC4jNIqAqcevkLlYQm1fAXeLYxXPsIHMkBBQk5kyy
	ATE5BTwkutbJgFQIAVUcWXiObQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIcH2
	dQfj0mNWhxgFOBiVeHhPSrEFC7EmlhVX5h5ilOBgVhLhdVcBCvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamBc1fhIJWxG7hd+Yc+LCxa7vXk2c9el5Vs3ML07LGGpduHYi4O7ik0XWBx7Ivyj3v3D
	ht8v2nOOPPtX9Sw67NcMmfu3P5cvMX1utjpx66+0tSuPf7rkfOVfXavof/cH0b7XZrvOi1UK
	iWi4/2rvlSefls+U4c97HfQp699rs0sTNWeunLNa4cmLuLNKLMUZiYZazEXFiQDSItJLFAIA	AA==
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

Currently, the implementation is based on high resolution timers. It
provides the same overrun count as for none deferrable timers. What's why
it doesn't not bring any new functionality into timerfd implementation,
except clockid validation.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 fs/timerfd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 4a349cb..c132fd2 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
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

