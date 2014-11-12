Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaKLQ5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:57:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbaKLQ5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:57:17 -0500
Date: Wed, 12 Nov 2014 17:53:53 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112165352.GA2945@redhat.com>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
 <20141112125158.GB21343@twins.programming.kicks-ass.net>
 <20141112155843.GA24803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112155843.GA24803@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:58:43PM +0100, Stanislaw Gruszka wrote:
> Commit d670ec13178d0 "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
> test case in cost of breaking another one. After that commit, calling
> clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
> of Y time being smaller than X time.
> 
> Below is full reproducer (tst-cpuclock2.c) :
> 
> /* Parameters for the Linux kernel ABI for CPU clocks.  */
>         ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

Looks like # started lines were eaten. Here is reproducer that compile:

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <time.h>
#include <pthread.h>
#include <stdint.h>
#include <inttypes.h>

/* Parameters for the Linux kernel ABI for CPU clocks.  */
#define CPUCLOCK_SCHED          2
#define MAKE_PROCESS_CPUCLOCK(pid, clock) \
        ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

static pthread_barrier_t barrier;

/* Help advance the clock.  */
static void *chew_cpu(void *arg)
{
	pthread_barrier_wait(&barrier);
	while (1) ;

	return NULL;
}

/* Don't use the glibc wrapper.  */
static int do_nanosleep(int flags, const struct timespec *req)
{
	clockid_t clock_id = MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED);

	return syscall(SYS_clock_nanosleep, clock_id, flags, req, NULL);
}

static int64_t tsdiff(const struct timespec *before, const struct timespec *after)
{
	int64_t before_i = before->tv_sec * 1000000000ULL + before->tv_nsec;
	int64_t after_i = after->tv_sec * 1000000000ULL + after->tv_nsec;

	return after_i - before_i;
}

int main(void)
{
	int result = 0;
	pthread_t th;

	pthread_barrier_init(&barrier, NULL, 2);

	if (pthread_create(&th, NULL, chew_cpu, NULL) != 0) {
		perror("pthread_create");
		return 1;
	}

	pthread_barrier_wait(&barrier);

	/* The test.  */
	struct timespec before, after, sleeptimeabs;
	int64_t sleepdiff, diffabs;
	const struct timespec sleeptime = {.tv_sec = 0,.tv_nsec = 100000000 };

	/* The relative nanosleep.  Not sure why this is needed, but its presence
	   seems to make it easier to reproduce the problem.  */
	if (do_nanosleep(0, &sleeptime) != 0) {
		perror("clock_nanosleep");
		return 1;
	}

	/* Get the current time.  */
	if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &before) < 0) {
		perror("clock_gettime[2]");
		return 1;
	}

	/* Compute the absolute sleep time based on the current time.  */
	uint64_t nsec = before.tv_nsec + sleeptime.tv_nsec;
	sleeptimeabs.tv_sec = before.tv_sec + nsec / 1000000000;
	sleeptimeabs.tv_nsec = nsec % 1000000000;

	/* Sleep for the computed time.  */
	if (do_nanosleep(TIMER_ABSTIME, &sleeptimeabs) != 0) {
		perror("absolute clock_nanosleep");
		return 1;
	}

	/* Get the time after the sleep.  */
	if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &after) < 0) {
		perror("clock_gettime[3]");
		return 1;
	}

	/* The time after sleep should always be equal to or after the absolute sleep
	   time passed to clock_nanosleep.  */
	sleepdiff = tsdiff(&sleeptimeabs, &after);
	if (sleepdiff < 0) {
		printf("absolute clock_nanosleep woke too early: %" PRId64 "\n", sleepdiff);
		result = 1;

		printf("Before %llu.%09llu\n", before.tv_sec, before.tv_nsec);
		printf("After  %llu.%09llu\n", after.tv_sec, after.tv_nsec);
		printf("Sleep  %llu.%09llu\n", sleeptimeabs.tv_sec, sleeptimeabs.tv_nsec);
	}

	/* The difference between the timestamps taken before and after the
	   clock_nanosleep call should be equal to or more than the duration of the
	   sleep.  */
	diffabs = tsdiff(&before, &after);
	if (diffabs < sleeptime.tv_nsec) {
		printf("clock_gettime difference too small: %" PRId64 "\n", diffabs);
		result = 1;
	}

	pthread_cancel(th);

	return result;
}


