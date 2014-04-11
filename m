Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaDKJyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:54:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64533 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaDKJyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:54:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140410145621.GC27654@localhost.localdomain>
References: <CAKohpon3vJzL51V9aOBcXKJC4nr3K-0q77HsxFi+=ACUqNqhcA@mail.gmail.com>
	<20140410145621.GC27654@localhost.localdomain>
Date: Fri, 11 Apr 2014 15:24:11 +0530
Message-ID: <CAKohpo=auNFsivuM21pDxJ0e4sP-ScWc9EPvzhT6qud_UBSJqw@mail.gmail.com>
Subject: Re: [Query]: tick-sched: can idle_active be false in tick_nohz_idle_exit()?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2014 20:26, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> When a dynticks idle CPU is woken up (typically with an IPI), tick_nohz_stop_idle()
> is called on interrupt entry but, because this is a waking up IPI, tick_nohz_start_idle()
> won't be called. The reason is that need_resched() prevents tick_nohz_irq_exit() to be
> called in irq_exit().
>
> After all if we know that the CPU is going to exit the idle task, we don't need to account
> any more idle time. We also don't need to retry to enter in dynticks idle mode since we
> are going to restart the tick with tick_nohz_idle_exit().
>
> So in case of wake up IPIs, we may end up with !ts->idle_active in tick_nohz_idle_exit() :)
>
> I must confess this is not obvious.

I agree.. I didn't had a clue that this can happen. Good that I asked
this question :)

> It confused me as well when I met that part. A small
> comment in tick_nohz_idle_exit() would be welcome ;)

Looks hard. I tried for a small comment and this is the smallest I could get:

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c2d868d..26cf5bb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -925,6 +925,22 @@ void tick_nohz_idle_exit(void)

        ts->inidle = 0;

+       /*
+        * Can idle_active be false here?
+        * Ideally this would be the sequence of calls:
+        * - tick_nohz_idle_enter(), i.e. idle_active = true;
+        * - local_irq_disable()
+        * - IDLE
+        * - wake up due to IPI or other interrupt
+        * - local_irq_enable()
+        * - tick_nohz_irq_enter(), i.e. idle_active = false;
+        * - tick_nohz_irq_exit(), i.e. idle_active = true; This is not called
+        *   in case of IPI's as need_resched() will prevent that in
+        *   tick_irq_exit(), as we don't need to account any more for idle time
+        *   or try to enter dyntics mode (We are going to exit idle state).
+        *
+        * - tick_nohz_idle_exit()
+        */
        if (ts->idle_active || ts->tick_stopped)
                now = ktime_get();


I am preparing a cleanup patchset (separate from the timer/hrtimers 36 patch
set) for kernel/time/ and will add this change to that.. I am waiting
for the merge
window to close and Thomas to comment on my timers/hrtimers patches first.
Only then will I send another 40 :)

--
viresh
