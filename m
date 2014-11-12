Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaKLGLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:11:11 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:51730 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKLGLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:11:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141111171526.GC3216@lerouge>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
	<alpine.DEB.2.11.1411012003390.5308@nanos>
	<alpine.DEB.2.11.1411011646280.7732@gentwo.org>
	<alpine.DEB.2.11.1411012313320.5308@nanos>
	<alpine.DEB.2.11.1411061057470.5591@gentwo.org>
	<CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
	<20141110153147.GK4901@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1411101226310.12918@gentwo.org>
	<20141111171526.GC3216@lerouge>
Date: Wed, 12 Nov 2014 11:41:09 +0530
Message-ID: <CAKohpok3U_8zQurs219fOmwERFrnZ0sOE-YUc7B+fKYfFLmEpg@mail.gmail.com>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove scheduler_tick_max_deferment)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 22:45, Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Here is a summarized list:
>
> * Unbound workqueues affinity (to housekeeper)
> * Unbound timers affinity (to housekeeper)
> * 1 Hz residual scheduler tick offlining to housekeeper
> * Fix some scheduler accounting that don't even work with 1 Hz: cpu load
>   accounting, rt_scale, load balancing, etc...
> * Lighten the syscall path and get rid of cputime accounting + RCU hooks
>   for people who want isolation + fast syscalls and faults.
> * Work on non-affinable workqueues
> * Work on non-affinable timers
> * ...

+ spurious interrupts with NOHZ_FULL on all architectures which break isolation
but doesn't get caught with traces. Can be observed with this:

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 481fa54..91d490d 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1244,7 +1244,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 {
        struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
        ktime_t expires_next, now, entry_time, delta;
-       int i, retries = 0;
+       int i, retries = 0, count = 0;
+       static int total_spurious;

        BUG_ON(!cpu_base->hres_active);
        cpu_base->nr_events++;
@@ -1304,10 +1305,14 @@ void hrtimer_interrupt(struct clock_event_device *dev)
                                break;
                        }

+                       count++;
                        __run_hrtimer(timer, &basenow);
                }
        }

+       if (!count)
+               pr_err("____%s: Totalspurious: %d\n", __func__,
++total_spurious);
+
        /*
         * Store the new expiry value so the migration code can verify
         * against it.
