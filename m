Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaEGQuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbaEGQub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:50:31 -0400
Message-ID: <536A642B.7080309@redhat.com>
Date: Wed, 07 May 2014 18:49:47 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4 v2] nohz: Fix idle/iowait counts going backwards
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com> <1399470094-8070-3-git-send-email-dvlasenk@redhat.com> <20140507142321.GA2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140507142321.GA2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 04:23 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 03:41:33PM +0200, Denys Vlasenko wrote:
>> With this change, "iowait-ness" of every idle period is decided
>> at the moment it starts:
>> if this CPU's run-queue had tasks waiting on I/O, then this idle
>> period's duration will be added to iowait_sleeptime.
>>
>> This fixes the bug where iowait and/or idle counts could go backwards,
>> but iowait accounting is not precise (it can show more iowait
>> that there really is).
>>
> 
> NAK on this, the thing going backwards is a symptom of the bug, not an
> actual bug itself.

This patch does fix that bug.

The bug is that in nohz_stop_idle(),
we base the decision to add accumulated time to
ts->iowait_sleeptime or to ts->idle_sleeptime
on nr_iowait_cpu(cpu):

        if (nr_iowait_cpu(smp_processor_id()) > 0)
                ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
        else
                ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);

and we use the same nr_iowait_cpu(cpu)
to calculate result of get_cpu_iowait_time_us():

               if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
                       delta = ktime_sub(now, ts->idle_entrytime);
                       iowait = ktime_add(ts->iowait_sleeptime, delta);
               }

This is wrong because nr_iowait_cpu(cpu) is not stable.
It could be != 0 in get_cpu_iowait_time_us() but later
become 0 when we are in nohz_stop_idle().

We must use consistent logic in these two functions.
If nr_iowait_cpu() added something to iowait counter,
the same should be done in nohz_stop_idle().
