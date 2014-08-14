Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHNLYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:24:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:7465 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaHNLYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,862,1400050800"; 
   d="scan'208";a="584793671"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Topic: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Index: AQHPt6qldFEsaO1R4EusKJDsS2TARpvPZo0AgACNnJA=
Date: Thu, 14 Aug 2014 11:24:06 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5B61C@SHSMSX101.ccr.corp.intel.com>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814105336.GH16043@twins.programming.kicks-ass.net>
In-Reply-To: <20140814105336.GH16043@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Thursday, August 14, 2014 6:54 PM
> To: Daniel Lezcano
> Cc: Liu, Chuansheng; Rafael J. Wysocki; linux-pm@vger.kernel.org; LKML; Liu,
> Changcheng; Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
> back to DEFAULT
> 
> On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
> > Hi Chuansheng,
> >
> > On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com>
> wrote:
> >
> > > We found sometimes even after we let PM_QOS back to DEFAULT,
> > > the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
> > > selection immediately after received the IPI interrupt.
> > >
> > > The code model is simply like below:
> > > {
> > >         pm_qos_update_request(&pm_qos, C1 - 1);
> > >                 < == Here keep all cores at C0
> > >         ...;
> > >         pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
> > >                 < == Here some cores still stuck at C0 for 2-3s
> > > }
> > >
> > > The reason is when pm_qos come back to DEFAULT, there is IPI interrupt to
> > > wake up the core, but when core is in poll idle state, the IPI interrupt
> > > can not break the polling loop.
> > >
> > > So here in the IPI callback interrupt, when currently the idle task is
> > > running, we need to forcedly set reschedule bit to break the polling loop,
> > > as for other non-polling idle state, IPI interrupt can break them directly,
> > > and setting reschedule bit has no harm for them too.
> > >
> > > With this fix, we saved about 30mV power in our android platform.
> > >
> > > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > > ---
> > >  drivers/cpuidle/cpuidle.c |    8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > > index ee9df5e..9e28a13 100644
> > > --- a/drivers/cpuidle/cpuidle.c
> > > +++ b/drivers/cpuidle/cpuidle.c
> > > @@ -532,7 +532,13 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
> > >
> > >  static void smp_callback(void *v)
> > >  {
> > > -       /* we already woke the CPU up, nothing more to do */
> > > +       /* we already woke the CPU up, and when the corresponding
> > > +        * CPU is at polling idle state, we need to set the sched
> > > +        * bit to trigger reselect the new suitable C-state, it
> > > +        * will be helpful for power.
> > > +       */
> > > +       if (is_idle_task(current))
> > > +               set_tsk_need_resched(current);
> > >
> >
> > Mmh, shouldn't we inspect the polling flag instead ? Peter (Cc'ed) did some
> > changes around this and I think we should ask its opinion. I am not sure
> > this code won't make all cpu to return to the scheduler and go back to the
> > idle task.
> 
> Yes, this is wrong.. Also cpuidle should not know about this, so this is
> very much the wrong place to go fix this. Lemme have a look.

If inspecting the polling flag, we can not fix the race between poll_idle and smp_callback,
since in poll_idle(), before set polling flag, if the smp_callback come in, then no resched bit set,
after that, poll_idle() will do the polling action, without reselection immediately, it will bring power
regression here.




