Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3HTHA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:00:27 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:44119 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HTHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:00:25 -0400
X-Greylist: delayed 1727 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 03:00:25 EDT
Message-ID: <521313D8.9080500@lab.ntt.co.jp>
Date: Tue, 20 Aug 2013 15:59:36 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net>
In-Reply-To: <20130819111026.GE24092@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013年08月19日 20:10), Peter Zijlstra wrote:
> On Fri, Aug 16, 2013 at 06:46:28PM +0200, Frederic Weisbecker wrote:
>
> Option A:
>
>> Should we flush that iowait to the src CPU? But then it means we must handle
>> concurrent updates to iowait_sleeptime, idle_sleeptime from the migration
>> code and from idle enter / exit.
>>
>> So I fear we need a seqlock.
> Option B:
>
>> Or we can live with that and still account the whole idle time slept until
>> tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
>> All we need is just a new field in ts-> that records on which state we entered
>> idle.
>>
>> What do you think?
> I think option B is unworkable. Afaict it could basically caused
> unlimited iowait time. Suppose we have a load-balancer that tries it
> bestestest to sort-left (ie. run a task on the lowest 'free' cpu
> possible) -- the power aware folks are pondering such schemes.
>
> Now suppose we have a small burst of activity and the rightmost cpu gets
> to run something that goes to sleep on iowait.
>
> We'd accrue iowait on that cpu until it wakes up, which could be days
> from now if the load stays low enough, even though the task got to run
> almost instantly on another cpu.
>
> So no, if we need per-cpu iowait time we have to do A.
>
> Since we already have atomics in the io_schedule*() paths, please
> replace those with (seq)locks. Also see if you can place the entire
> iowait accounting thing in a separate cacheline.

I considered option A for a while but, fearing it would be
considered overkill, took a different approach: create a
shadow copy of ->iowait_sleeptime that is always kept
monotonic (artificially in some cases) and use that to
compute the values exported through /proc.

That said, if deemed acceptable, option A is the one I would
choose.
