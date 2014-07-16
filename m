Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbaGPL5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:57:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54870 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045AbaGPL53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:57:29 -0400
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: SIGXCPU accounting inaccurate?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201407162057.HGC90620.OFVHLFMOQOtSFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 16 Jul 2014 20:57:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have a question regarding SIGXCPU.

I was expecting that SIGXCPU is generated when current thread's user + sys
exceeded current thread's rlim[RLIMIT_CPU].rlim_cur . But I can observe that,
depending on workloads, SIGXCPU is issued before user + sys exceeds
rlim[RLIMIT_CPU].rlim_cur .

---------- rlimit-test.c start ----------
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/resource.h>
#include <sys/time.h>

static volatile _Bool flag = 0;
static void sighandler(int sig) { flag = 1; }

int main(int argc, char *argv[])
{
	const int fd = open("/dev/zero", O_RDONLY);
	struct rlimit rlim = { 10, RLIM_INFINITY };
	struct rusage ru = { };
	struct timeval tv0 = { }, tv1 = { };
	unsigned long sec = 0;
	unsigned long microsec = 0;
	char c;
	/* Apply CPU usage limit. */
	if (fd == EOF || signal(SIGXCPU, sighandler) == SIG_ERR ||
	    setrlimit(RLIMIT_CPU, &rlim) || gettimeofday(&tv0, NULL))
		return 1;
	/* Consume CPU time. */
	while (!flag)
		c = read(fd, &c, 1);
	/* Gheck CPU usage after exceeding CPU usage limit. */
	if (gettimeofday(&tv1, NULL) || getrusage(RUSAGE_SELF, &ru))
		return 1;
	/* Print CPU usage seen from process. */
	sec = tv1.tv_sec - tv0.tv_sec;
	microsec = tv1.tv_usec - tv0.tv_usec;
	while ((long) microsec < 0) { sec--; microsec += 1000000; }
	printf("wall time: %lu.%06lu\n", sec, microsec);
	sec = ru.ru_utime.tv_sec + ru.ru_stime.tv_sec;
	microsec = ru.ru_utime.tv_usec + ru.ru_stime.tv_usec;
	while (microsec >= 1000000) { sec++; microsec -= 1000000; }
	printf("getrusage: user %lu.%06lu / sys %lu.%06lu / total %lu.%06lu\n",
	       ru.ru_utime.tv_sec, ru.ru_utime.tv_usec, ru.ru_stime.tv_sec,
	       ru.ru_stime.tv_usec, sec, microsec);
	return 0;
}
---------- rlimit-test.c end ----------

  $ cc -Wall -O2 -o rlimit-test rlimit-test.c

(1) If

    $ taskset -c 0 ./rlimit-test

    is executed alone, the result is accurate.

      wall time: 9.998606
      getrusage: user 1.329402 / sys 8.666107 / total 9.995509

      wall time: 9.999678
      getrusage: user 1.338283 / sys 8.656362 / total 9.994645

      wall time: 11.033851
      getrusage: user 1.403173 / sys 9.628063 / total 11.031236

(2) If

    $ taskset -c 0 ./rlimit-test

    is executed in parallel with

    $ taskset -c 0 sh -c 'while :; do :; done'

    , the result remains accurate.

      wall time: 20.465868
      getrusage: user 1.338968 / sys 8.897792 / total 10.236760

      wall time: 19.984542
      getrusage: user 1.336148 / sys 8.657481 / total 9.993629

      wall time: 19.993528
      getrusage: user 1.461475 / sys 8.534938 / total 9.996413

(3) If

    $ taskset -c 0 ./rlimit-test

    is executed in parallel with

    $ taskset -c 0 sh -c 'while :; do /bin/true; done'

    , the result becomes inaccurate (SIGXCPU is issued before
    user + sys exceeds rlim[RLIMIT_CPU].rlim_cur ).

      wall time: 10.055558
      getrusage: user 1.265196 / sys 8.204838 / total 9.470034

      wall time: 10.010175
      getrusage: user 1.315658 / sys 8.142706 / total 9.458364

      wall time: 10.010262
      getrusage: user 1.269611 / sys 8.183938 / total 9.453549

Why SIGXCPU accounting became inaccurate?

Regards.
