Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab3GDQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 12:47:18 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54693 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3GDQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 12:46:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/7] posix_timers: fix racy timer delta caching on task exit
Date: Thu,  4 Jul 2013 18:46:24 +0200
Message-Id: <1372956385-25396-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
References: <1372956385-25396-1-git-send-email-fweisbec@gmail.com>
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
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 4ebd8ad..c7f31aa 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -404,14 +404,8 @@ static void cleanup_timers_list(struct list_head *head,
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
@@ -459,15 +453,21 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
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

