Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaEOOKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:10:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63694 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaEOOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:10:00 -0400
Message-ID: <5374CAB0.2070305@windriver.com>
Date: Thu, 15 May 2014 10:09:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>	 <20140514154459.GE4570@linux.vnet.ibm.com>	 <20140514191100.GA24155@windriver.com> <1400122194.5175.18.camel@marge.simpson.net>
In-Reply-To: <1400122194.5175.18.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-14 10:49 PM, Mike Galbraith wrote:
> On Wed, 2014-05-14 at 15:11 -0400, Paul Gortmaker wrote:
> 
>> Given that, perhaps a separate change to sched_rt_runtime_exceeded()
>> that works out the CPU from the rt_rq, and returns zero if it is a
>> nohz_full cpu?  Does that make sense?  Then the nohz_full people won't
>> get the throttling message even if they go 100%.
> 
> I don't get it.  What reason would there be to run a hog on a dedicated
> core as realtime policy/priority?  Given no competition, there's nothing
> to prioritize, you could just as well run a critical task as SCHED_IDLE.

Well, as per the original commit log, we acknowledge that people will do
stupid things that don't make 100% sense, and when they do, we should
ideally behave in a sane fashion in response to that.  And I don't think
that "no competition" is a given for most folks.  They see all these
internal threads running and just figure they can chrt their way to a
solution, vs. taking the time to clean up, enable RCU_NOCB etc etc.
Don't get me wrong; I'm not defending such behaviour...

> 
> I would also expect that anyone wanting bare metal will have all of
> their critical cores isolated from the scheduler, watchdogs turned off
> as well as that noisy throttle, the whole point being to make as much
> silent as possible.  Seems to me tick_nohz_full_cpu(cpu) should be
> predicated by that cpu being isolated from the #1 noise source, the
> scheduler and its load balancing.  There's just no point to nohz_full
> without that, or if there is, I sure don't see it.

An interesting point.  One could argue that the default for the nohz_full
cores should be to be isolated from the scheduler, vs needing to be
manually excluded.

P.
--

> 
> When I see people trying to run a hog as a realtime task, it's because
> they are trying in vain to keep competition away from precious cores..
> and one mlockall with a realtime hog blocking flush_work() gives them a
> wakeup call.
> 
> -Mike
> 
