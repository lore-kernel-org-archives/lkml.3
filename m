Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaDPFnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:43:14 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39974 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaDPFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140415124438.GB2438@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
	<20140414232218.GE1877@localhost.localdomain>
	<CAKohpomKrQydz12mXQnQe8sw3X-OotRqLDCxQFi5goyk6D9-=w@mail.gmail.com>
	<20140415091323.GK1877@localhost.localdomain>
	<CAKohpokVAbD=ym9c6UpRjbWnmzMbTwukgMo1_h+VOeRyPXxZKQ@mail.gmail.com>
	<20140415124438.GB2438@localhost.localdomain>
Date: Wed, 16 Apr 2014 11:13:10 +0530
Message-ID: <CAKohponji62SKmbfnELX0pwk3Yy14gDat2sJ-OJctmybqQSCGA@mail.gmail.com>
Subject: Re: [PATCH 29/38] tick-sched: remove wrapper around __tick_nohz_task_switch()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 18:14, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Sure but check out the static_key_false() in the implementation of tick_nohz_full_enabled().
> That's where the magic hides.

> No problem, the jump label/static key code is quite tricky. And its use
> can be easily missed, as in here.
>
> Also its unfamous API naming (static_key_true/static_key_true) that is
> anything but intuitive.

That was tricky enough to be missed on first look :)

Okay here is the answer to what you asked earlier:

>> In this case probably we can move !can_stop_full_tick() as well to the wrapper ?
>
> Do you mean moving all the code of __tick_nohz_task_switch() to tick_nohz_task_switch()?
> I much prefer we don't do that. This is going to make can_stop_full_tick() a publicly
> visible nohz internal. And it may uglify tick.h as well.

I probably asked the wrong question, I meant tick_nohz_tick_stopped()
instead of !can_stop_full_tick().

Or, can we make the code more efficient by avoiding a branch by doing this:

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 1065a51..12632cc 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -220,7 +220,7 @@ static inline void tick_nohz_full_check(void)

 static inline void tick_nohz_task_switch(void)
 {
-       if (tick_nohz_full_enabled())
+       if (tick_nohz_full_enabled() && tick_nohz_tick_stopped())
                __tick_nohz_task_switch();
 }

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 45037c4..904e09b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -273,7 +273,7 @@ void __tick_nohz_task_switch(void)

        local_irq_save(flags);

-       if (tick_nohz_tick_stopped() && !can_stop_full_tick())
+       if (!can_stop_full_tick())
                tick_nohz_full_kick();

        local_irq_restore(flags);
