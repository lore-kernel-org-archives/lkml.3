Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3KDQW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:22:59 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32773 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KDQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:22:58 -0500
Date: Mon, 4 Nov 2013 17:22:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/5] timer: Change idle/iowait accounting semantics
Message-ID: <20131104162253.GG9299@localhost.localdomain>
References: <1382195841-6558-4-git-send-email-fweisbec@gmail.com>
 <20131020073456.GA2729@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131020073456.GA2729@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 09:34:56AM +0200, Andreas Mohr wrote:
> Hi,
> 
> just wanted to report that this capricious open-coded (ok, lone-coded :)
> converter:
> 
> +static inline ktime_t us_to_ktime(u64 us)
> +{
> +	static const ktime_t ktime_zero = { .tv64 = 0 };
> +
> +	return ktime_add_us(ktime_zero, us);
> +}
> 
> triggered a virtual red flag in my processing.
> 
> We obviously seem to be compensating for a domain mismatch here:
> 
> +	iowait = get_cpu_iowait_time_us(cpu, NULL);
> +
> +	if (ktime_compare(idle, us_to_ktime(iowait)) > 0)
> +		idle = ktime_sub_us(idle, iowait);
> +
> 
> And sure enough:
> get_cpu_iowait_time_us() does a final to-us conversion
> only right before result is returned,
> and it's located right within the same build unit (tick-sched.c).
> (and then we go ahead and do a from-us round trip :-P)
> 
> So, in case we want to standardize on ktime_t domain
> for these parts of purely *in-kernel* time handling,
> how about adding a _unit-local_ helper for providing a ktime-only result
> and convert get_cpu_iowait_time_us() into a simple to-us *external user code*
> one-line wrapper for it?
> (and include updates to all other places which would benefit from this change)

Agreed. I admit I worked around this little part because that code is actually
not expected to be merged but was rather posted to raise some questions and may be
answer. But what you're suggesting is definetly the right way.


> And preferably launch such patch as a preparatory patch for this
> subsequent 3/5 patch, within the series?

Yep. Well, I hope we can find another way to fix the initial issue. But if that part of the code
is reused, I'll take care of fixing that.

Thanks!

