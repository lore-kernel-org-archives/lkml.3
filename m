Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaDVEFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:05:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37451 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaDVEFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:05:48 -0400
Message-ID: <5355EA95.1060603@linaro.org>
Date: Tue, 22 Apr 2014 09:35:41 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linaro-networking@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 14/19] tick-sched: add comment about 'idle_active'
 in tick_nohz_idle_exit()
References: <cover.1398072824.git.viresh.kumar@linaro.org> <387f4713d52595f055620f39dc7a0edad7d4d8bf.1398072824.git.viresh.kumar@linaro.org> <20140421232047.GA5579@localhost.localdomain>
In-Reply-To: <20140421232047.GA5579@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014 04:50 AM, Frederic Weisbecker wrote:
> It's still over-detailed. Much of the above is easily deduced after common review. OTOH
> I proposed to summarize there: https://lkml.org/lkml/2014/4/11/334
> The below disambiguates it a bit further.

Hmm.. Something broke for sure in my repo. I do remember updating this patch with your
comments and something went wrong while playing with patches.

Sorry for that. Fixed my repo now.

> Now it's eventually getting as big as your comment ;-)
> 
> 
>           /*
>            * ts->idle_active drives the idle time which typically elapses in the idle loop
>            * but breaks on IRQs interrupting idle loop.
>            *
>            * Hence ts->idle_active can be 1 here if we exit the idle loop without the help of
>            * an IRQ. OTOH it can be 0 on idle exit if a wake up IPI pulled the CPU out of
>            * the idle loop. Since we know that we'll be exiting the idle task after the wake
>            * up IPI, all the pending idle sleep time is flushed on irq entry and no more is
>            * accounted further thanks to the need_resched() check on irq_exit().
>            */

@Thomas: Please consider this patch instead:

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Mon Apr 21 15:25:10 2014 +0530

    tick-sched: add comment about 'idle_active' in tick_nohz_idle_exit()

    The sequence of calls for dynticks CPUs is a bit confusing. Add a comment in
    tick_nohz_idle_exit() to mention it clearly. All information required is in
    commit and this conversation with Frederic.

    https://lkml.org/lkml/2014/4/10/355

    Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 71f64ee..b2f024f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -922,6 +922,17 @@ void tick_nohz_idle_exit(void)

        ts->inidle = 0;

+       /*
+        * ts->idle_active drives the idle time which typically elapses in the
+        * idle loop but breaks on IRQs interrupting idle loop.
+        *
+        * Hence ts->idle_active can be 1 here if we exit the idle loop without
+        * the help of an IRQ. OTOH it can be 0 on idle exit if a wake up IPI
+        * pulled the CPU out of the idle loop. Since we know that we'll be
+        * exiting the idle task after the wake up IPI, all the pending idle
+        * sleep time is flushed on irq entry and no more is accounted further
+        * thanks to the need_resched() check on irq_exit().
+        */
        if (ts->idle_active || ts->tick_stopped)
                now = ktime_get();


