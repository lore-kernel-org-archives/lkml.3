Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717Ab3GSOTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:19:30 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56065 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab3GSOT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:19:27 -0400
Date: Fri, 19 Jul 2013 16:19:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 07/18] nohz: Selectively enable context tracking on full
 dynticks CPUs
Message-ID: <20130719141920.GA21752@somewhere>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
 <1374079471-3129-8-git-send-email-fweisbec@gmail.com>
 <1374085637.6458.170.camel@gandalf.local.home>
 <20130718221346.GE7398@somewhere>
 <1374187917.3356.6.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374187917.3356.6.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 06:51:57PM -0400, Steven Rostedt wrote:
> On Fri, 2013-07-19 at 00:13 +0200, Frederic Weisbecker wrote:
> > On Wed, Jul 17, 2013 at 02:27:17PM -0400, Steven Rostedt wrote:
> > > On Wed, 2013-07-17 at 18:44 +0200, Frederic Weisbecker wrote:
> > > > The code is ready to do so in the context tracking subsystem, now
> > > 
> > > "do so"? Do what?
> > 
> > It's referring to the patch title. The code is ready to selectively
> > enable context tracking on the CPUs.
> > 
> > I see many changelogs that use that kind of style where the title
> > of the patch is considered as the 1st line of the changelog. That's
> > convenient because it avoids the need to rephrase the title in the
> > changelog.
> > 
> > But may be the reference to the title is not obvious. if you prefer
> > I can expand the "do so" here.
> 
> Yeah, I've seen that too. But this was a bit too subtle to get it. The
> subject is a bit vague as well, which doesn't help the matter. What does
> "selectively enable context tracking" mean? How is it selective?

Yeah selectively means here that it's enabled only on some CPUs, not
all of them.

> 
> > 
> > > 
> > > > we just need to pass our cpu range selection to it from the
> > > 
> > > Pass cpu range selection to what?
> > > 
> > > Pronouns are evil in technical documentation.
> > 
> > How about:
> > 
> > """
> > The code in the context tracking subsystem is ready to selectively
> > enable its tracking on specificied CPU ranges instead of inconditionally
> 
> "specified" "unconditionally"

Oops :)

> 
> > force it on all CPUs.
> > 
> > What we need to do now is to pass the desired CPU ranges to track from
> > the full dynticks subsystem, according to the ranges specified in the
> > "nohz_full=" boot option.
> > """ 
> > 
> > > > diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> > > > index 12045ce..2c2b73aa 100644
> > > > --- a/include/linux/context_tracking.h
> > > > +++ b/include/linux/context_tracking.h
> > > > @@ -34,6 +34,8 @@ static inline bool context_tracking_active(void)
> > > >  	return __this_cpu_read(context_tracking.active);
> > > >  }
> > > >  
> > > > +extern void context_tracking_cpu_set(int cpu);
> > > > +
> > > >  extern void user_enter(void);
> > > >  extern void user_exit(void);
> > > >  
> > > > diff --git a/init/Kconfig b/init/Kconfig
> > > > index 247084b..914da3f 100644
> > > > --- a/init/Kconfig
> > > > +++ b/init/Kconfig
> > > > @@ -527,7 +527,7 @@ config RCU_USER_QS
> > > >  config CONTEXT_TRACKING_FORCE
> > > >  	bool "Force context tracking"
> > > >  	depends on CONTEXT_TRACKING
> > > > -	default CONTEXT_TRACKING
> > > > +	default y if !NO_HZ_FULL
> > > 
> > > Why the if !NO_HZ_FULL?
> > > 
> > > That selects this anyway. Oh wait, you changed this.
> > 
> > Yeah that's probably confusing. Ok lets consider a system with:
> > 
> >      CONTEXT_TRACKING=y
> > 
> > By default it doesn't track any CPU, it's inactive unless you set:
> > 
> >      CONTEXT_TRACKING_FORCE=y
> > 
> > In this case, all CPUs are tracked.
> > 
> > The full dynticks subsystem was supposed to pass its CPU range to context
> > tracking such that it activates the tracking only on the relevant CPUs.
> > 
> > But the context tracking code was merged before full dynticks. So nothing
> > was there to enabled CPUs on context tracking initially. So we needed
> > CONTEXT_TRACKING_FORCE for testing.
> > 
> > Then later we merged full dynticks. But we got lazy and rushed and instead of
> > selecting the CPUs to track on runtime from the full dynticks subsystem to
> > the context tracking subsystem, we forced CONTEXT_TRACKING_FORCE=y when
> > NO_HZ_FULL=y. Then using runtime selection became a TODO.
> > 
> > Now these patches handle that TODO and full dynticks passes its range to
> > contex tracking.
> > 
> > Now one could argue why we keep CONTEXT_TRACKING_FORCE around, since we
> > have full dynticks and NO_HZ_FULL_ALL for wide automated testing.
> > 
> > This is because CONTEXT_TRACKING is not sufficient for NO_HZ_FULL alone.
> > Especially because of the 64bits requirement that I need to drop after
> > careful review of any use of cputime_t. But anyway, CONTEXT_TRACKING_FORCE
> > is still handy to keep around for archs that want support for nohz full
> > but don't yet meet all dependencies.
> 
> OK, that needs a comment in the Kconfig. Perhaps something like:
> 
> "CONTEXT_TRACKING is only needed by NO_HZ_FULL, but the user may want to
> test CONTEXT_TRACKING on systems that do not yet support NO_HZ_FULL, in
> which case we must keep the FORCE to enable it."
> 
> Or something to that nature. That way people have a clue to why that's
> like that.

Ok, I'll add that.

Thanks!

> 
> -- Steve
> 
> 
