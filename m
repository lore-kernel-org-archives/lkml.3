Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3EVIeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:34:22 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43861 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3EVIeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305131223470.2863@ionos>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org>
	<1354024039.6276.72.camel@gandalf.local.home>
	<CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
	<CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com>
	<CAKohpo=0r=HY5w-XqnXv42eSJcH08C47J+TqWn7vY1aNBhGT_A@mail.gmail.com>
	<CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
	<alpine.LFD.2.02.1305131223470.2863@ionos>
Date: Wed, 22 May 2013 14:04:16 +0530
Message-ID: <CAKohpokfKPQ3EhMf3WB8koXuH2rF6QoejwNOTw08X+XfnVhpEg@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, pjt@google.com,
        paul.mckenney@linaro.org, tj@kernel.org, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being late in replying to your queries.

On 13 May 2013 16:05, Thomas Gleixner <tglx@linutronix.de> wrote:
> Which mechanism is migrating the timer away?

It will be the same: get_nohz_timer_target() which will decide target
cpu for migration.

> I have no objections to the functionality per se, but the proposed
> solution is not going to fly.
>
> Aside of bloating the data structure you're changing the semantics of
> __mod_timer(). No __mod_timer() caller can deal with -EBUSY. So you'd
> break the world and some more.

Ahh.. That idea was dropped already.

> Here is a list of questions:
>
>       - Which mechanism migrates timers?
>
>       - How is that mechanism triggered?

The mechanism remains the same as is for non-rearmed timers.
i.e. get_nohz_timer_target()..

We are just trying to give a approach with which we can migrate
running timers. i.e. those which re-arm themselves from their
handlers.

>       - How does that deal with CPU bound timers?

We will still check 'Pinned' for this timer as is done for any other
normal timer. So, we don't migrate them.

So, this is the clean draft for the idea I had.. (Naming is poor for
now):

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..ad00ebe 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -20,6 +20,7 @@ struct timer_list {

        void (*function)(unsigned long);
        unsigned long data;
+       int wait_for_migration_to_complete;

        int slack;

diff --git a/kernel/timer.c b/kernel/timer.c
index a860bba..7791f28 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -746,21 +746,15 @@ __mod_timer(struct timer_list *timer, unsigned
long expires,
        new_base = per_cpu(tvec_bases, cpu);

        if (base != new_base) {
-               /*
-                * We are trying to schedule the timer on the local CPU.
-                * However we can't change timer's base while it is running,
-                * otherwise del_timer_sync() can't detect that the timer's
-                * handler yet has not finished. This also guarantees that
-                * the timer is serialized wrt itself.
-                */
-               if (likely(base->running_timer != timer)) {
-                       /* See the comment in lock_timer_base() */
-                       timer_set_base(timer, NULL);
-                       spin_unlock(&base->lock);
-                       base = new_base;
-                       spin_lock(&base->lock);
-                       timer_set_base(timer, base);
-               }
+               if (base->running_timer == timer)
+                       timer->wait_for_migration_to_complete = 1;
+
+               /* See the comment in lock_timer_base() */
+               timer_set_base(timer, NULL);
+               spin_unlock(&base->lock);
+               base = new_base;
+               spin_lock(&base->lock);
+               timer_set_base(timer, base);
        }

        timer->expires = expires;
@@ -990,7 +984,8 @@ int try_to_del_timer_sync(struct timer_list *timer)

        base = lock_timer_base(timer, &flags);

-       if (base->running_timer != timer) {
+       if ((base->running_timer != timer) &&
+                       !timer->wait_for_migration_to_complete) {
                timer_stats_timer_clear_start_info(timer);
                ret = detach_if_pending(timer, base, true);
        }
@@ -1183,6 +1178,8 @@ static inline void __run_timers(struct tvec_base *base)
                                call_timer_fn(timer, fn, data);
                                spin_lock_irq(&base->lock);
                        }
+                       if (timer->wait_for_migration_to_complete)
+                               timer->wait_for_migration_to_complete = 0;
                }
        }
        base->running_timer = NULL;


Please see if it a junk idea or has some light of hope :)
