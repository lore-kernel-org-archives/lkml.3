Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaHOBWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 21:22:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:56664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaHOBWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 21:22:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,867,1400050800"; 
   d="scan'208";a="585124116"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Topic: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Index: AQHPuASJ65e6VW0Rf061Gyhx+xeL1ZvQFAEAgAABoICAAMcnoA==
Date: Fri, 15 Aug 2014 01:21:52 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5BA34@SHSMSX101.ccr.corp.intel.com>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net>
 <53EC9A29.8090408@linaro.org> <53ED263B.7030703@mit.edu>
 <20140814211656.GV19379@twins.programming.kicks-ass.net>
 <CALCETrUEWAbzk3S=T93qh-j4xhwoVrUCqhybr_rr1n-uynQTvw@mail.gmail.com>
In-Reply-To: <CALCETrUEWAbzk3S=T93qh-j4xhwoVrUCqhybr_rr1n-uynQTvw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7F1MUYl031028



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Friday, August 15, 2014 5:23 AM
> To: Peter Zijlstra
> Cc: Daniel Lezcano; Liu, Chuansheng; Rafael J. Wysocki;
> linux-pm@vger.kernel.org; LKML; Liu, Changcheng; Wang, Xiaoming;
> Chakravarty, Souvik K
> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
> back to DEFAULT
> 
> On Thu, Aug 14, 2014 at 2:16 PM, Peter Zijlstra <peterz@infradead.org>
> wrote:
> > On Thu, Aug 14, 2014 at 02:12:27PM -0700, Andy Lutomirski wrote:
> >> On 08/14/2014 04:14 AM, Daniel Lezcano wrote:
> >> > On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
> >> >>
> >> >> So seeing how you're from @intel.com I'm assuming you're using x86
> here.
> >> >>
> >> >> I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
> >> >> just fine, which means we'll fall out of the cpuidle_enter(), which
> >> >> means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
> >> >>
> >> >> It will indeed not leave the cpu_idle_loop() function and go right back
> >> >> into cpuidle_idle_call(), but that will then call cpuidle_select() which
> >> >> should pick a new C state.
> >> >>
> >> >> So the interrupt _should_ work. If it doesn't you need to explain why.
> >> >
> >> > I think the issue is related to the poll_idle state, in
> >> > drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
> >> > cpuidle table as the state 0 (POLL). There is no mwait for this state.
> >> > It is a bit confusing because this state is not listed in the acpi /
> >> > intel idle driver but inserted implicitly at the beginning of the idle
> >> > table by the cpuidle framework when the driver is registered.
> >> >
> >> > static int poll_idle(struct cpuidle_device *dev,
> >> >                 struct cpuidle_driver *drv, int index)
> >> > {
> >> >         local_irq_enable();
> >> >         if (!current_set_polling_and_test()) {
> >> >                 while (!need_resched())
> >> >                         cpu_relax();
> >> >         }
> >> >         current_clr_polling();
> >> >
> >> >         return index;
> >> > }
> >>
> >> As the most recent person to have modified this function, and as an
> >> avowed hater of pointless IPIs, let me ask a rather different question:
> >> why are you sending IPIs at all?  As of Linux 3.16, poll_idle actually
> >> supports the polling idle interface :)
> >>
> >> Can't you just do:
> >>
> >> if (set_nr_if_polling(rq->idle)) {
> >>       trace_sched_wake_idle_without_ipi(cpu);
> >> } else {
> >>       spin_lock_irqsave(&rq->lock, flags);
> >>       if (rq->curr == rq->idle)
> >>               smp_send_reschedule(cpu);
> >>       // else the CPU wasn't idle; nothing to do
> >>       raw_spin_unlock_irqrestore(&rq->lock, flags);
> >> }
> >>
> >> In the common case (wake from C0, i.e. polling idle), this will skip the
> >> IPI entirely unless you race with idle entry/exit, saving a few more
> >> precious electrons and all of the latency involved in poking the APIC
> >> registers.
> >
> > They could and they probably should, but that logic should _not_ live in
> > the cpuidle driver.
> 
> Sure.  My point is that fixing the IPI handler is, I think, totally
> bogus, because the IPI API isn't the right way to do this at all.
> 
> It would be straightforward to add a new function wake_if_idle(int
> cpu) to sched/core.c.
> 
Thanks Andy and Peter's suggestion, it will save some IPI things in case the cores are not
in idle.

There is one similar API in sched/core.c wake_up_idle_cpu(),
then just need add one new common smp API:

smp_wake_up_cpus() {
for_each_online_cpu()
  wake_up_idle_cpu();
}

Will try one patch for it.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
