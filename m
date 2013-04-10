Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649Ab3DJLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:35:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52568 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3DJLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:35:23 -0400
Message-ID: <1365593710.30071.52.camel@laptop>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 13:35:10 +0200
In-Reply-To: <1365184746.874.103.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 13:59 -0400, Olivier Langlois wrote:
> Process timers are moving fasters than their corresponding
>  cpu clock for various reasons:
> 
> 1. There is a race condition when getting a timer sample that makes the sample
>    be smaller than it should leading to setting the timer expiration to soon.
> 2. When initializing the cputimer, by including tasks deltas in the initial
>    timer value, it makes them be counted twice.
> 3. When a thread autoreap itself when exiting, the last context switch update
>    will update the cputimer and not the overall process values stored in
>    signal.

Please explain these races. Things like task_sched_runtime() on which
most of this stuff is build read both sum_exec_runtime and compute the
delta while holding the rq->lock; this should avoid any and all races
against update_curr() and the sort.

All this fiddling with conditional deltas seems very ugly, esp. since
no attempt is made to explain why it would be impossible to tighten the
synchronization to avoid the races.

> I have also removed to erractic cputimer start/stop. I am guessing that it
> was done to 'resync' once in a while the cputimer with the clock but
> you could start the cputimer by calling timer_settimer that finally
> do not end up by arming a new posix timer so you could have the cputimer
> running with 0 armed timers or have 1 periodic process timer.

No keeping a process wide (over all threads) cputime aggregate running
is _expensive_, so its important to stop doing this once there's nobody
who cares about it anymore.


