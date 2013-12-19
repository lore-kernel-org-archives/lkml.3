Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3LSVz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:55:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38030 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3LSVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:55:55 -0500
Date: Thu, 19 Dec 2013 22:55:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
Message-ID: <20131219215541.GS16438@laptop.programming.kicks-ass.net>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
 <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
 <20131219204051.GA2253@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219204051.GA2253@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:40:51PM +0100, Ingo Molnar wrote:
> > +		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> > +			mb();
> >  			clflush((void *)&current_thread_info()->flags);
> > +			mb();
> > +		}

>  	if (!current_set_polling_and_test()) {
>  		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> -			mb();
> +			/*
> +			 * There's no need for an extra barrier here: current_set_polling_and_test()
> +			 * already has an smp_mb() after ->flags gets modified, see sched.h.
> +			 */
>  			clflush((void *)&current_thread_info()->flags);
>  			mb();
>  		}

So almost, except that smp_mb() will disappear on an UP kernel whereas
this errata might just always need the MFENCE.

Then again, you'd be a pretty big nutter to run an UP kernel on an EX
part.
