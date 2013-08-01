Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3HAKLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab3HAKLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:11:15 -0400
Date: Thu, 1 Aug 2013 18:10:19 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] posix_cpu_timers: fix timer never expires when executes
 clock_nanosleep
Message-ID: <20130801101018.GJ6721@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7439b90b0794c016b29356f0e232f7413ef7b60 Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com> 
Date: Thu, 1 Aug 2013 11:39:04 +0800

When use the current process pid as the clockid, then executes
clock_nanosleep syscall the timer will never expire. Kernel should
prevent user doing like this and this patch is supposed to fix it.I
wrote a simple case to test it:

    #include <time.h>
    #include <errno.h>
    #include <unistd.h>
    #include <sys/types.h>

    #define CPU_CLOCK_PROF           0
    #define CPU_CLOCK_VIRT           1
    #define CPU_CLOCK_SCHED          2

    #define CPU_CLOCK_THREAD         4
    #define PID_TO_CLOCKID(pid, clock) ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

    int main(void)
    {
            int ret;
            pid_t pid;
            clockid_t clk;
            struct timespec ts;

            ts.tv_sec = 1;
            ts.tv_nsec = 0;

            pid = getpid();
            clk = PID_TO_CLOCKID(pid, CPU_CLOCK_PROF);
            if ((ret = clock_nanosleep(clk, 0, &ts, NULL)) != 0) {
                    perror("clock_nanosleep");
                    return ret;
            }

            return 0;
    }

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
---
 kernel/posix-cpu-timers.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..cc03290 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1413,9 +1413,9 @@ static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 	/*
 	 * Diagnose required errors first.
 	 */
-	if (CPUCLOCK_PERTHREAD(which_clock) &&
-	    (CPUCLOCK_PID(which_clock) == 0 ||
-	     CPUCLOCK_PID(which_clock) == current->pid))
+	if (CPUCLOCK_PID(which_clock) == current->pid ||
+	    (CPUCLOCK_PERTHREAD(which_clock) &&
+	     CPUCLOCK_PID(which_clock) == 0))
 		return -EINVAL;
 
 	error = do_cpu_nanosleep(which_clock, flags, rqtp, &it);
-- 
1.7.11.7


-- 
Best Regards,
Dong Zhu
