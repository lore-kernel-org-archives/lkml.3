Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaGIX60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:58:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:45193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaGIX6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:58:25 -0400
Date: Thu, 10 Jul 2014 01:58:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        preeti@linux.vnet.ibm.com, khilman@linaro.org
Subject: Re: [RFC 1/7] hrtimer: Warn if hrtimer_start*() failed to enqueue
 hrtimer
In-Reply-To: <20140709222131.GD23881@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1407100141090.4357@nanos>
References: <cover.1404888801.git.viresh.kumar@linaro.org> <bc8cabd00810c2f91cb45a64514f5c4ca12d584c.1404888801.git.viresh.kumar@linaro.org> <20140709222131.GD23881@localhost.localdomain>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Frederic Weisbecker wrote:

> On Wed, Jul 09, 2014 at 12:25:33PM +0530, Viresh Kumar wrote:
> > hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
> > only special case is when the hrtimer was in past. If it is getting enqueued to
> > local CPUs's clock-base, we raise a softirq and exit, else we handle that on
> > next interrupt on remote CPU.
> > 
> > At several places in kernel we check if hrtimer is enqueued properly with
> > hrtimer_active(). This isn't required and can be dropped.
> > 
> > Before fixing that, lets make sure hrtimer is always enqueued properly by adding
> > 
> > 	WARN_ON_ONCE(!hrtimer_active(timer));
> > 
> > towards the end of __hrtimer_start_range_ns().
> > 
> > Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  kernel/hrtimer.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 3ab2899..cf40209 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1037,6 +1037,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
> >  
> >  	unlock_hrtimer_base(timer, &flags);
> >  
> > +	/* Make sure timer is enqueued */
> > +	WARN_ON_ONCE(!hrtimer_active(timer));
> 
> Hmm, after reading Thomas reply, I think it's possible that the hrtimer expires
> right after we unlock it and, if we are unlucky enough, before the hrtimer_active()
> check.
> 
> In this case we might hit a false positive.

Haha, I didn't even go down to this patch after reading 0/N. I knew
right there that it's going to be pointless shite.

But now that you point me to it, it's even worse. It's not only
pointless shite it's actively wrong and outright stupid for someone
who tries to "work" on this code for a couple of month now.

Viresh, I'm really tired of this. Stop touching code you do not
understand. I warned you more than once and now you really reached the
level of complete incompetence. Welcome to my killfile.

Thanks,

	tglx
