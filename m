Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3JRIig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:38:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60823 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3JRIid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:38:33 -0400
Date: Fri, 18 Oct 2013 09:38:39 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
Message-ID: <20131018083839.GW31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
 <20131014133356.GN3081@twins.programming.kicks-ass.net>
 <525C0A51.2080407@linux.intel.com>
 <20131017164038.GV31039@e103034-lin>
 <20131017165416.GW10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20131017165416.GW10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Oct 2013 08:38:29.0746 (UTC) FILETIME=[6BD20520:01CECBDD]
X-MC-Unique: 113101809383006601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 05:54:16PM +0100, Peter Zijlstra wrote:
> On Thu, Oct 17, 2013 at 05:40:38PM +0100, Morten Rasmussen wrote:
> > On Mon, Oct 14, 2013 at 04:14:25PM +0100, Arjan van de Ven wrote:
> > > On 10/14/2013 6:33 AM, Peter Zijlstra wrote:
> > > > On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
> > > >> Removing power hints for kworker threads enables easier use of
> > > >> workqueues in the power driver late callback. That would otherwise
> > > >> lead to an endless loop unless it is prevented in the power driver.
> > > >
> > > > There's many kworker users; some of them actually consume lots of
> > > > cputime. Therefore how did you come to the conclusion that excepting all
> > > > users was the better choice of a little added complexity in the one
> > > > place where it actually matters?
> > > 
> > > .. and likely only for a very few architectures
> > > 
> > > x86, and I suspect modern ARM, can change frequency synchronously.
> > > (using an instruction or maybe two or three for ARM)
> > 
> > It should be possible to implement synchronous frequency changes on most
> > modern ARM platforms. It is a bit more than a few instructions to change
> > frequency though particularly for the current cpufreq drivers.
> > 
> > cpufreq drivers, like the one for ARM TC2, uses the clock framework to
> > manage clocks. clk_set_rate() is allowed to sleep which won't work if we
> > call it from scheduler context. The clock framework will need a look if
> > it doesn't provide a very fast synchronous alternative to clk_set_rate()
> > to change frequency and we want to use it for scheduler driven frequency
> > scaling.
> > 
> > cpufreq has pre- and post-change notifiers so the current TC2 clock driver
> > waits (yields) in its clk_set_rate() implementation until the change has
> > happened to ensure that the post-change notifier happens at the right
> > time. Since clk_set_rate() is allowed to sleep other tasks may be
> > running while waiting for the change to complete. This may be true for
> > other clock drivers as well.
> > 
> > AFAICT, there is no way to reuse the existing cpufreq drivers in a
> > sensible way for scheduler driven frequency scaling. It should be
> > possible to have very fast frequency changes on ARM but it is not the
> > way it is currently done.
> 
> 
> Note that you still have preemption disabled in your late callback from
> finish_task_switch(). There's no way you can wait/yield/whatever from
> there. Nor is that really sane.

No, that is what I have realized after messing around trying to call
into cpufreq. It just won't work. A non-waiting/yielding/whatever driver
is needed. There is no point in having the late callback it won't solve
anything. 

> 
> Just say no to the existing cruft ?

That is the only way ahead I think. intel_pstate.c does it. I will into
what it takes to do something similar on ARM TC2.

