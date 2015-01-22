Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbbAVKpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:45:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:59043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAVKph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:45:37 -0500
Date: Thu, 22 Jan 2015 11:45:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: vigneshr@codeaurora.org
cc: stfomichev@yandex-team.ru, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, viresh.kumar@linaro.org, fweisbec@gmail.com,
        mingo@kernel.org, cl@linux.com, psodagud@codeaurora.org,
        sboyd@codeaurora.org
Subject: RE: [PATCH v3] hrtimers: calculate expires_next after all timers
 are executed
In-Reply-To: <5575911c82b96b23fdcaeb71bde87e9e.squirrel@www.codeaurora.org>
Message-ID: <alpine.DEB.2.11.1501221144210.5526@nanos>
References: <5575911c82b96b23fdcaeb71bde87e9e.squirrel@www.codeaurora.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, vigneshr@codeaurora.org wrote:

> Hi Thomas,
> 
> In this patch, we are only setting the flag
> cpu_base->in_hrtirq = 1; in hrtimer_interrupt() and not resetting it.
> 
> 
> > @@ -1251,9 +1251,9 @@ void hrtimer_interrupt(struct clock_even
> > dev->next_event.tv64 = KTIME_MAX;
> >
> > raw_spin_lock(&cpu_base->lock);
> > + cpu_base->in_hrtirq = 1;
> 
> Since this is the case, after the hrtimer_interrupt routine completes and
> new timer is started and say it happens to be leftmost,
> we don't allow hrtimer_reprogram() since we bail out given that
> cpu_base->in_hrtirq=1 :
> 
> timer irq comes
> --->hrtimer_interrupt()
> ---->cpu_base->in_hrtirq flag is set
> ------>Interrupt is serviced
> 
> After sometime
> 
> -->__hrtimer_start_range_ns()
> --->happens to be leftmost hence call hrtimer_enqueue_reprogram()
> ----->hrtimer_reprogram()
> ------->bail out since cpu_base->in_hrtirq flag is stil set
> 
> At the end of hrtimer interrupt routine, i think we should also clear this
> flag.

Bah, yes. I moved it around several times and then dropped it.
 
Thanks for spotting it!

       tglx
