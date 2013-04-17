Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692Ab3DQBYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:24:16 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35500 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab3DQBYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:24:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] posix_timers: Fix racy timer delta caching on task exit
Date: Wed, 17 Apr 2013 03:24:03 +0200
Message-Id: <1366161843-26098-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366161843-26098-1-git-send-email-fweisbec@gmail.com>
References: <1366161843-26098-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task exits, we perform a caching of the remaining cputime delta
before expiring of its timers.

This is done from the following places:

* When the task is reaped. We iterate through its list of
  posix cpu timers and store the remaining timer delta to
  the timer struct instead of the absolute value.
  (See posix_cpu_timers_exit() / posix_cpu_timers_exit_group() )

* When we call posix_cpu_timer_get() or posix_cpu_timer_schedule().
  If the timer's task is considered dying when watched from these
  places, the same conversion from absolute to relative expiry time
  is performed. Then the given task's reference is released.
  (See clear_dead_task() ).

The relevance of this caching is questionable but this is another
and deeper debate.

The big issue here is that these two sources of caching don't mix
up very well together.

More specifically, the caching can easily be done twice, resulting
in a wrong delta as it gets spuriously substracted a second time by
the elapsed clock. This can happen in the following scenario:

1) The task exits and gets reaped: we call posix_cpu_timers_exit()
   and the absolute timer expiry values are converted to a relative
   delta.

2) timer_gettime() -> posix_cpu_timer_get() is called and relies on
   clear_dead_task() because  tsk->exit_state == EXIT_DEAD.
   The delta gets substracted again by the elapsed clock and we return
   a wrong result.

To fix this, just remove the caching done on task reaping time.  It
doesn't bring much value on its own.  The caching done from
posix_cpu_timer_get/schedule is enough.

And it would also be hard to get it really right: we could make it put and
clear the target task in the timer struct so that readers know if they are
dealing with a relative cached of absolute value.  But it would be racy.
The only safe way to do it would be to lock the itimer->it_lock so that we
know nobody reads the cputime expiry value while we modify it and its
target task reference.  Doing so would involve some funny workarounds to
avoid circular lock against the sighand lock.  There is just no reason to
maintain this.

The user visible effect of this patch can be observed by running the
following code: it creates a subthread that launches a posix cputimer
which expires after 10 seconds. But then the subthread only busy loops for 2
seconds and exits. The parent reaps the subthread and read the timer value.
Its expected value should the be the initial timer's expiration value
minus the cputime elapsed in the subthread. Roughly 10 - 2 = 8 seconds:

	#include <sys/time.h>
	#include <stdio.h>
	#include <unistd.h>
	#include <time.h>
	#include <pthread.h>

	static timer_t id;
	static struct itimerspec val = { .it_value.tv_sec = 10, }, new;

	static void *thread(void *unused)
	{
		int err;
		struct timeval start, end, diff;

		timer_create(CLOCK_THREAD_CPUTIME_ID, NULL, &id);
		if (err < 0) {
			perror("Can't create timer\n");
			return NULL;
		}

		/* Arm 10 sec timer */
		err = timer_settime(id, 0, &val, NULL);
		if (err < 0) {
			perror("Can't set timer\n");
			return NULL;
		}

		/* Exit after 2 seconds of execution */
		gettimeofday(&start, NULL);
	        do {
			gettimeofday(&end, NULL);
			timersub(&end, &start, &diff);
		} while (diff.tv_sec < 2);

		return NULL;
	}

	int main(int argc, char **argv)
	{
		pthread_t pthread;
		int err;

		err = pthread_create(&pthread, NULL, thread, NULL);
		if (err) {
			perror("Can't create thread\n");
			return -1;
		}
		pthread_join(pthread, NULL);
		/* Just wait a little bit to make sure the child got reaped */
		sleep(1);
		err = timer_gettime(id, &new);
		if (err)
			perror("Can't get timer value\n");
		printf("%d %ld\n", new.it_value.tv_sec, new.it_value.tv_nsec);

		return 0;
	}

Before the patch:

       $ ./posix_cpu_timers
       6 2278074

After the patch:

      $ ./posix_cpu_timers
      8 1158766

Before the patch, the elapsed time got two more seconds spuriously accounted.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index afd79a9..877439b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -387,14 +387,8 @@ static void cleanup_timers_list(struct list_head *head,
 {
 	struct cpu_timer_list *timer, *next;
 
-	list_for_each_entry_safe(timer, next, head, entry) {
+	list_for_each_entry_safe(timer, next, head, entry)
 		list_del_init(&timer->entry);
-		if (timer->expires < curr) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= curr;
-		}
-	}
 }
 
 /*
@@ -442,15 +436,21 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *timer, unsigned long long now)
+static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
 {
+	struct cpu_timer_list *timer = &itimer->it.cpu;
+
 	/*
 	 * That's all for this thread or process.
 	 * We leave our residual in expires to be reported.
 	 */
-	put_task_struct(timer->it.cpu.task);
-	timer->it.cpu.task = NULL;
-	timer->it.cpu.expires -= now;
+	put_task_struct(timer->task);
+	timer->task = NULL;
+	if (timer->expires < now) {
+		timer->expires = 0;
+	} else {
+		timer->expires -= now;
+	}
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
-- 
1.7.5.4

