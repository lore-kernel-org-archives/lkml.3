Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3HTP3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:29:17 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43198 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3HTP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:29:15 -0400
Date: Tue, 20 Aug 2013 17:29:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820152910.GB17441@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130820084405.GC3258@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:44:05AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 20, 2013 at 03:59:36PM +0900, Fernando Luis Vázquez Cao wrote:
> > That said, if deemed acceptable, option A is the one I would
> > choose.
> 
> Right, so I think we can do A without much extra cost mostly because we
> already have 2 atomics in the io_schedule() path. If we replace those
> two atomic operations with locks and modify nr_iowait and the other
> stats under the same lock, and ensure all those variables (including the
> lock) live in the same cacheline we should have the same cost we have
> now.

I can try that :-)

> 
> Of course, if we can get away with completely removing all of that
> (which I think Arjan suggested was a real possibility) then that would
> be ever so much better still :-)

Would be lovely. But I don't know much about cpufreq, I hope somebody who's
familiar with that code can handle this. Then once there are no more users
of get_cpu_iowait_sleep_time() I can simply zap and clean the tick/time related
code.

Surely the overhead that this mess brings to io_schedule() (and it's going
to be worth with a seqlock, whether in the same cacheline than nr_iowait or
not) may be a good motivation to poke at that cpufreq code part.

Thanks.
