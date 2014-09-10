Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaIJBbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:31:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55668 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaIJBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:31:14 -0400
From: Richard Larocque <rlarocque@google.com>
To: tglx@linutronix.de, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, Richard Larocque <rlarocque@google.com>
Subject: [PATCH 0/3] alarmtimer: Fix some non-standard alarm timer behavior
Date: Tue,  9 Sep 2014 18:31:02 -0700
Message-Id: <1410312665-25381-1-git-send-email-rlarocque@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on some changes to posix-timers.c in an attempt to better
support CRIU.  Along the way, I've discovered some issues with the posix alarm
timers that should be fixed independent of any other work.

It seems that there was an older issue with the setting of relative timeouts
with timer_settime().  That was addressed around 3.16 with
16927776ae757d0d132bdbfabbfe2c498342bd59 ("alarmtimer: Fix bug where relative
alarm timers were treated as absolute").  That fixed the setting of times, but
it doesn't fix the retrieval of times.

According to the man pages (and POSIX), timer_gettime() is supposed to return
the time left until the timeout, not the absolute time at which the timeout is
expected to fire.  The non-ALARM clocks correctly show relative times, but
CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM do not.

A second issue with these timers is that they call posix_event_timer() without
checking the value of it_sigev_notify.  This is a problem, because
it_sigev_notify could be SIGEV_NONE, in which case the signal should not be
delivered.  The non-alarm timers don't need to check it_sigev_notify in their
timeout handling code path, because they never schedule timeouts for those
kinds of timers in the first place.

See below for a program that demonstrates these behaviors, and some sample output.

The third patch in this stack is the odd one out.  I suspect that there's
a locking issue in the alarm timer code, and this is my attempt to fix it.
It's not quite related to the first two, but it does conflict with one of them,
so I figured I should include it in this patch stack.

PS: This is my first upstream patch, so please excuse any etiquette violations.

Richard Larocque (3):
  alarmtimer: Return relative times in timer_gettime
  alarmtimer: Do not signal SIGEV_NONE timers
  alarmtimer: Lock k_itimer during timer callback

 kernel/time/alarmtimer.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)
--------
/* timer_gettime_test.c: A program to test the behavior of timer_gettime() */

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

static void do_show_timer(clockid_t which_clock);

int main() {
        printf("CLOCK_REALTIME\n");
        do_show_timer(CLOCK_REALTIME);
        printf("\n");

        printf("CLOCK_BOOTTIME\n");
        do_show_timer(CLOCK_BOOTTIME);
        printf("\n");

        printf("CLOCK_REALTIME_ALARM\n");
        do_show_timer(CLOCK_REALTIME_ALARM);
        printf("\n");

        printf("CLOCK_BOOTTIME_ALARM\n");
        do_show_timer(CLOCK_BOOTTIME_ALARM);
        printf("\n");
}

static void do_show_timer(clockid_t which_clock) {
        struct sigevent sevp;
        timer_t timerid;
        struct itimerspec in, out;
        struct timespec ts;
        int i;

        /*
         * SIGEV_NONE is supposed to prevent signal delivery, but it doesn't.
         * Set signo to SIGSTOP to make the received signal obvious but
         * harmless.
         */
        sevp.sigev_notify = SIGEV_NONE;
        sevp.sigev_signo = SIGSTOP;

        if (timer_create(which_clock, &sevp, &timerid) != 0) {
                perror("timer_create");
                exit(EXIT_FAILURE);
        }

        if (timer_gettime(timerid, &out) != 0) {
                perror("timer_gettime");
                exit(EXIT_FAILURE);
        }
        printf("before timer start: %ld.%09ld\n",
                        out.it_value.tv_sec, out.it_value.tv_nsec);

        /* Use absolute times to sidestep bug in older kernels. */
        clock_gettime(which_clock, &ts);

        in.it_value.tv_sec = ts.tv_sec + 3600;
        in.it_value.tv_nsec = ts.tv_nsec;
        in.it_interval.tv_sec = 0;
        in.it_interval.tv_nsec = 0;
        if (timer_settime(timerid, TIMER_ABSTIME, &in, NULL)) {
                perror("timer_settime");
                exit(EXIT_FAILURE);
        }

        for (i = 0; i < 3; ++i) {
                if (timer_gettime(timerid, &out) != 0) {
                        perror("timer_gettime");
                        exit(EXIT_FAILURE);
                }
                printf("step %d: %ld.%09ld\n",
                                i, out.it_value.tv_sec, out.it_value.tv_nsec);
                sleep(1);
        }

        in.it_value.tv_sec = ts.tv_sec;
        in.it_value.tv_nsec = ts.tv_nsec;
        in.it_interval.tv_sec = 0;
        in.it_interval.tv_nsec = 0;
        if (timer_settime(timerid, TIMER_ABSTIME, &in, NULL)) {
                perror("timer_settime");
                exit(EXIT_FAILURE);
        }

        if (timer_gettime(timerid, &out) != 0) {
                perror("timer_gettime");
                exit(EXIT_FAILURE);
        }
        printf("after expiry: %ld.%09ld\n",
                        out.it_value.tv_sec, out.it_value.tv_nsec);

        timer_delete(timerid);
}
--------
ihrt16:~# ./timer_gettime_test 
CLOCK_REALTIME
before timer start: 0.000000000
step 0: 3599.999987035
step 1: 3598.999824068
step 2: 3597.999588143
after expiry: 0.000000000

CLOCK_BOOTTIME
before timer start: 0.000000000
step 0: 3599.999996257
step 1: 3598.999871706
step 2: 3597.999753939
after expiry: 0.000000000

CLOCK_REALTIME_ALARM
before timer start: 0.000000000
step 0: 1410314715.145776868
step 1: 1410314715.145776868
step 2: 1410314715.145776868

[1]+  Stopped                 ./timer_gettime_test
ihrt16:~# fg
./timer_gettime_test
after expiry: 1410311115.145776868

CLOCK_BOOTTIME_ALARM
before timer start: 0.000000000
step 0: 3923.018128712
step 1: 3923.018128712
step 2: 3923.018128712

[1]+  Stopped                 ./timer_gettime_test
ihrt16:~# fg
./timer_gettime_test
after expiry: 323.018128712

ihrt16:~# 
-- 
2.1.0.rc2.206.gedb03e5

