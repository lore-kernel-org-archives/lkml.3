Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3FMRQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:16:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3FMRQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:16:22 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tkaDFPjYVEIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=apdwqXrHFoAA:10 a=Z_JpT1VHS3fw3eSVRGEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371143779.9844.297.camel@gandalf.local.home>
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
From: Steven Rostedt <rostedt@goodmis.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 13 Jun 2013 13:16:19 -0400
In-Reply-To: <CAK7N6vqtnoNzRNodN6T0wysMYgPD+-SgPZLXAvRu3px7TUUvHQ@mail.gmail.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
	 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
	 <20130612170316.GO133453@redhat.com> <20130613131057.GA15997@somewhere>
	 <20130613140207.GW133453@redhat.com> <20130613142210.GD16339@somewhere>
	 <20130613144515.GX133453@redhat.com> <20130613145601.GE16339@somewhere>
	 <20130613152059.GA133453@redhat.com>
	 <1371138491.9844.288.camel@gandalf.local.home>
	 <CAK7N6vqtnoNzRNodN6T0wysMYgPD+-SgPZLXAvRu3px7TUUvHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 21:51 +0530, anish singh wrote:

> > The concept behind full dynamic ticks is very easy. When you set a given
> > CPU(s) to dynamic tick, when it only has a single task scheduled on that
> > CPU, it disables the periodic tick. This removes essentially *all*
> 
> Documentation/timers/highres.txt states that
> hrtimer_stop_sched_tick() is called when a CPU goes into idle state.Would
> you mind elaborating "single task scheduled on that CPU"?
> I am bit new to this so please excuse me if the question is too basic.

That's the old CONFIG_NO_HZ, which only disables the tick on idle. What
we are working on is to also disable the tick when there's only one task
running on a given CPU. Why have as schedule tick when there's nothing
to schedule?

3.10 now has new config options:

CONFIG_NO_HZ_PERIODIC - which is NO_HZ disabled
   (the old # CONFIG_NO_HZ not set)

CONFIG_NO_HZ_IDLE - which is what CONFIG_NO_HZ use to be.

Note, CONFIG_NO_HZ still exists and if set, will make CONFIG_NO_HZ_IDLE
the default. This was to keep the same configuration for people who
update their kernel and run make oldconfig.

Then there's the new:

CONFIG_NO_HZ_FULL - this enables CONFIG_NO_HZ_IDLE plus adds the new
feature with disabling the tick when only one task is running on a given
CPU.


> > latency from the kernel! That is, if the task is doing some complex
> > calculations, it wont be interrupted for kernel maintenance. A lot of
> > Red Hat customers would love to have this feature. It allows for
> > extremely low latency actions even without a real-time kernel. Heck, it
> > works without even kernel preemption.
> >
> > Now removing the periodic tick is not a trivial task, and this is where
> 
> You mean getting rid of period ticks in the kernel code is not easy as there
> are many features such as perf is dependent on it right and that is why
> instead of completely removing periodic ticks we just set the periodic tick
> to happen at 1HZ instead of CONFIG_HZ value?

IIRC, the reason for moving to 1 HZ is so that the scheduler doesn't get
confused with overflows. It still needs to handle time keeping for
managing how to schedule tasks according to CFS.

Everything else shouldn't depend on the tick... period.

-- Steve

> > all our issues come from. In fact, we can not even completely remove the
> > tick yet, we just move it to 1 HZ instead of whatever the CONFIG_HZ is
> > set to. We have to handle everything that depends on that tick, which
> > includes perf, among other things.
> >


