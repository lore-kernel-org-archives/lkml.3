Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3KGWyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:54:20 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53070 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3KGWyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:54:12 -0500
Date: Thu, 7 Nov 2013 23:54:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed
 on any cpu
Message-ID: <20131107225408.GD28130@localhost.localdomain>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-3-git-send-email-jack@suse.cz>
 <CAFTL4hxLXb3hZacx_EdHeKZVfrpuyGoNqpGbX997XJx0UJSwyg@mail.gmail.com>
 <20131107221904.GB2054@quack.suse.cz>
 <20131107222311.GA28130@localhost.localdomain>
 <20131107225034.GD2054@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107225034.GD2054@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:50:34PM +0100, Jan Kara wrote:
> On Thu 07-11-13 23:23:14, Frederic Weisbecker wrote:
> > On Thu, Nov 07, 2013 at 11:19:04PM +0100, Jan Kara wrote:
> > > On Thu 07-11-13 23:13:39, Frederic Weisbecker wrote:
> > > > But then, who's going to process that work if every CPUs is idle?
> > >   Have a look into irq_work_queue(). There is:
> > >         /*
> > >          * If the work is not "lazy" or the tick is stopped, raise the irq
> > >          * work interrupt (if supported by the arch), otherwise, just wait
> > >          * for the next tick. We do this even for unbound work to make sure
> > >          * *some* CPU will be doing the work.
> > >          */
> > >         if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
> > >                 if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
> > >                         arch_irq_work_raise();
> > >         }
> > > 
> > >   So we raise an interrupt if there would be no timer ticking (which is
> > > what I suppose you mean by "CPU is idle"). That is nothing changed by my
> > > patches...
> > 
> > Ok but we raise that interrupt locally, not to the other CPUs.
>   True, but that doesn't really matter in this case. Any CPU (including the
> local one) can handle the unbound work. So from the definition of the
> unbound work things are OK.

I don't see how that can be ok. You want to offline a work because the local CPU
can't handle it, right? If the local CPU can handle it you can just use local
irq works.

> 
> Regarding my use for printk - if all (other) CPUs are idle then we can
> easily afford making the current cpu busy printing, that's not a problem.
> There's nothing else to do than to print what's remaining in the printk
> buffer...

So if the current CPU can handle it, what is the problem?
