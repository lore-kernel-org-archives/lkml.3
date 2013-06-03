Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FCTHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:07:39 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41211 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3FCTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:07:36 -0400
Date: Mon, 3 Jun 2013 21:07:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/8] posix-cpu-timers: fix acounting delta_exec twice
Message-ID: <20130603190730.GA31107@somewhere>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
 <1369604149-13016-4-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369604149-13016-4-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 05:35:42PM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently glibc rt/tst-cpuclock2 test(*) sporadically fails because
> scheduler delta can be accounted twice from thread_group_cputimer()
> and account_group_exec_runtime().
> 
> Finally, clock_nanosleep() wakes up earlier than an argument. This is posix
> violation. This issue was introduced by commit d670ec1317 (posix-cpu-timers:
> Cure SMP wobbles).
> 
> (*) http://sourceware.org/git/?p=glibc.git;a=blob;f=rt/tst-cpuclock2.c;h=6752721717f959e89c0d692b3f1ee082d507eec2;hb=HEAD
> 
> Cc: Olivier Langlois <olivier@trillion01.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>

So with this patch the timer sample can be (nr_threads * TICK_NSEC) nsecs behind the
clock in the worst case.

This is still better than possibly (nr_threads * TICK_NSEC) nsecs ahead of the clock in
the worst case like we have before the patch :)

But the worst case can be unbounded with full dynticks tasks. May be the ideal thing
would be to perform an update_curr() on the threads before we read their sum_exec_runtime,
This way we make sure we are never far away behind.

This needs to be done on top of your change anyway because we still want to avoid
the double count, so: Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.
