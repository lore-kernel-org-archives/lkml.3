Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaGAAMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:12:47 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63740 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaGAAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406271249510.5170@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
 <alpine.DEB.2.10.1406271249510.5170@nanos>
From: Austin Schuh <austin@peloton-tech.com>
Date: Mon, 30 Jun 2014 17:12:22 -0700
Message-ID: <CANGgnMYcSoJa32CdGBxvj0c3NEnU=S=DD35YmZAtn8miCtK6kw@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 26 Jun 2014, Austin Schuh wrote:
>> If I'm reading the rt patch correctly, wq_worker_sleeping was moved
>> out of __schedule to sched_submit_work.  It looks like that changes
>> the conditions under which wq_worker_sleeping is called.  It used to
>> be called whenever a task was going to sleep (I think).  It looks like
>> it is called now if the task is going to sleep, and if the task isn't
>> blocked on a PI mutex (I think).
>>
>> If I try the following experiment
>>
>>  static inline void sched_submit_work(struct task_struct *tsk)
>>  {
>> +   if (tsk->state && tsk->flags & PF_WQ_WORKER) {
>> +     wq_worker_sleeping(tsk);
>> +     return;
>> +   }
>>
>> and then remove the call later in the function, I am able to pass my test.
>>
>> Unfortunately, I then get a recursive pool spinlock BUG_ON after a
>> while (as I would expect), and it all blows up.
>
> Well, that's why the check for !pi_blocked_on is there.
>
>> I'm not sure where to go from there.  Any changes to the workpool to
>> try to fix that will be hard, or could affect latency significantly.
>
> Completely untested patch below.
>
> Thanks,
>
>         tglx
>
> --------------------->
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 8749d20..621329a 100644
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index be0ef50..0ca9d97 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -849,25 +882,18 @@ void wq_worker_sleeping(struct task_struct *task)
>                 return;
>
>         worker->sleeping = 1;
> -       spin_lock_irq(&pool->lock);
> +
>         /*
>          * The counterpart of the following dec_and_test, implied mb,
>          * worklist not empty test sequence is in insert_work().
>          * Please read comment there.
> -        *
> -        * NOT_RUNNING is clear.  This means that we're bound to and
> -        * running on the local cpu w/ rq lock held and preemption
> -        * disabled, which in turn means that none else could be
> -        * manipulating idle_list, so dereferencing idle_list without pool
> -        * lock is safe.
>          */
>         if (atomic_dec_and_test(&pool->nr_running) &&
>             !list_empty(&pool->worklist)) {

What guarantees that this pool->worklist access is safe?  Preemption
isn't disabled.

I'm seeing some inconsistency when accessing the idle list.  You seem
to only disable preemption when writing to the idle list?  I'm unsure
if I'm missing something, or what.  With that question in mind, I took
a stab at adding locking around all the idle_list calls.

I went through and double checked to make sure that rt_lock_idle_list
and rt_unlock_idle_list surround all idle_list or entry accesses.  The
following are places where I think you should be locking, but aren't.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8900da8..314a098 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -778,8 +805,12 @@ static bool too_many_workers(struct worker_pool *pool)
  * nr_idle and idle_list may disagree if idle rebinding is in
  * progress.  Never return %true if idle_list is empty.
  */
- if (list_empty(&pool->idle_list))
+ rt_lock_idle_list(pool);
+ if (list_empty(&pool->idle_list)) {
+ rt_unlock_idle_list(pool);
  return false;
+ }
+ rt_unlock_idle_list(pool);

  return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
@@ -788,7 +819,7 @@ static bool too_many_workers(struct worker_pool *pool)
  * Wake up functions.
  */

-/* Return the first worker.  Safe with preemption disabled */
+/* Return the first worker.  Preemption must be disabled */
 static struct worker *first_worker(struct worker_pool *pool)
 {
  if (unlikely(list_empty(&pool->idle_list)))
@@ -1567,10 +1598,16 @@ static void worker_enter_idle(struct worker *worker)
 {
  struct worker_pool *pool = worker->pool;

- if (WARN_ON_ONCE(worker->flags & WORKER_IDLE) ||
-    WARN_ON_ONCE(!list_empty(&worker->entry) &&
- (worker->hentry.next || worker->hentry.pprev)))
- return;
+ if (WARN_ON_ONCE(worker->flags & WORKER_IDLE)) return;
+
+ rt_lock_idle_list(pool);
+ if (WARN_ON_ONCE(!list_empty(&worker->entry))) {
+ rt_unlock_idle_list(pool);
+ if (worker->hentry.next || worker->hentry.pprev)
+ return;
+ } else {
+ rt_unlock_idle_list(pool);
+ }

  /* can't use worker_set_flags(), also called from start_worker() */
  worker->flags |= WORKER_IDLE;
@@ -1882,7 +1925,9 @@ static void idle_worker_timeout(unsigned long __pool)
  unsigned long expires;

  /* idle_list is kept in LIFO order, check the last one */
+ rt_lock_idle_list(pool);
  worker = list_entry(pool->idle_list.prev, struct worker, entry);
+ rt_unlock_idle_list(pool);
  expires = worker->last_active + IDLE_WORKER_TIMEOUT;

  if (time_before(jiffies, expires))
@@ -2026,7 +2071,9 @@ static bool maybe_destroy_workers(struct
worker_pool *pool)
  struct worker *worker;
  unsigned long expires;

+ rt_lock_idle_list(pool);
  worker = list_entry(pool->idle_list.prev, struct worker, entry);
+ rt_unlock_idle_list(pool);
  expires = worker->last_active + IDLE_WORKER_TIMEOUT;

  if (time_before(jiffies, expires)) {
@@ -2299,7 +2346,9 @@ woke_up:
  /* am I supposed to die? */
  if (unlikely(worker->flags & WORKER_DIE)) {
  spin_unlock_irq(&pool->lock);
+ rt_lock_idle_list(pool);
  WARN_ON_ONCE(!list_empty(&worker->entry));
+ rt_unlock_idle_list(pool);
  worker->task->flags &= ~PF_WQ_WORKER;
  return 0;
  }
@@ -3584,8 +3633,17 @@ static void put_unbound_pool(struct worker_pool *pool)
  mutex_lock(&pool->manager_mutex);
  spin_lock_irq(&pool->lock);

- while ((worker = first_worker(pool)))
- destroy_worker(worker);
+ while (true) {
+ rt_lock_idle_list(pool);
+ if ((worker = first_worker(pool))) {
+ destroy_worker(worker);
+ } else {
+ break;
+ }
+ rt_unlock_idle_list(pool);
+ }
+ rt_unlock_idle_list(pool);
+
  WARN_ON(pool->nr_workers || pool->nr_idle);

  spin_unlock_irq(&pool->lock);

So far, my test machines are staying up, which is progress.  I have a
couple hours of runtime on the unmodified patch, and 1/2 hour ish on
my modifications.

Thanks!
  Austin
