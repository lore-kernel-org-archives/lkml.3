Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3CZQyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:54:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab3CZQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:53:59 -0400
Date: Tue, 26 Mar 2013 17:54:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130326165433.GC2029@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <CAFTL4hyJxwh056=bTsSFcpZ7QLRsvsGbni=ueUHE6c1n8dmQ7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyJxwh056=bTsSFcpZ7QLRsvsGbni=ueUHE6c1n8dmQ7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:19:25PM +0100, Frederic Weisbecker wrote:
> I starred at that code for quite some time already and I can't come up
> with a better solution.
> 
> Of course 128 bits ops are very expensive, so to help you evaluating
> the situation, this is going to happen on every call to
> task_cputime_adjusted() and thread_group_adjusted(), namely:
> 
> * Some proc files read
> * sys_times()
> * thread group exit

I need to think if we can get rid of thread_group_cputime_adjusted()
at exit(), perhaps this is possible without causing problems.

Div128 is optimized if higher 64-bits are zeros. 128 bit multiplication
can be avoided if we are sure that 64bit mul will not overflow, for
example:

if (ffs(stime) + ffs(rtime) < 64)
	scale_64()
else
	scale_128()

Basically 99.9% of processes will go scale_64() path. Fix is only
needed for processes that utilize lot of CPU time for long period,
hence have big stime and rtime values, what is not common.

I'm thinking also about remove cputime scaling. Obviously this would
be the best regarding performance. I think we could avoid multiplication
in kernel, this can be done in user-space if we export rtime to it.
So top could be modified to do cputime scaling by itself. In that way
we will avoid this top hiding "exploit", but also precision of times(2)
syscall values will get worse (I think there are lot of programs that
use this call and they might expect stime/utime are precise).

Stanislaw

