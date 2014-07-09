Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaGIVbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:31:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:44737 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaGIVbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:31:01 -0400
Date: Wed, 9 Jul 2014 23:30:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Darren Hart <dvhart@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/7] hrtimer: drop active hrtimer checks after adding it
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.10.1407092321130.4357@nanos>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Viresh Kumar wrote:

So your patch series drops active hrtimer checks after adding it,
according to your subject line.

Quite useeul to drop something after adding it, right?

> hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
> only special case is when the hrtimer was in past. If it is getting enqueued to
> local CPUs's clock-base, we raise a softirq and exit, else we handle that on
> next interrupt on remote CPU.
> 
> At several places in the kernel, we try to make sure if hrtimer was added
> properly or not by calling hrtimer_active(), like:
> 
> 	hrtimer_start(timer, expires, mode);
> 	if (hrtimer_active(timer)) {
> 		/* Added successfully */
> 	} else {
> 		/* Was added in the past */
> 	}
> 
> As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
> So, there is no point calling hrtimer_active().

Wrong as usual.

It's a common pattern that short timeouts are given which lead to
immediate expiry so the extra round through schedule is even more
pointless than the extra check.

Aside of that it's a long discussed issue that we really should tell
the caller right away that the timer was setup in the past and not
enqueued at all.

That requires to fixup a few call sites, but that'd far more valuable
than removing a few assumed to be pointless checks.

Thnaks,

	tglx
