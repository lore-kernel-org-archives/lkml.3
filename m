Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3LFPZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:25:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752675Ab3LFPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:25:38 -0500
Date: Fri, 6 Dec 2013 10:25:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] read_lock migrate_disable pushdown to rt_read_lock
Message-ID: <20131206102532.712d4ae4@gandalf.local.home>
In-Reply-To: <20131206023334.GA26623@opentech.at>
References: <20131205234449.GF15603@opentech.at>
	<20131205211951.5c2eaa0f@gandalf.local.home>
	<20131206023334.GA26623@opentech.at>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013 03:33:34 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:

> > > -	migrate_disable();
> > >  	if (rt_mutex_owner(lock) != current) {
> > >  		ret = rt_mutex_trylock(lock);
> > > -		if (ret)
> > > +		if (ret) {
> > > +			migrate_disable();
> > >  			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
> > > +		}
> > 
> > I like this patch in general, but I'm nervous about this part.
> > 
> > What was the original reason to disable migration before checking the
> > mutex owner? Seems like we should have only disabled it on success. I'm
> > assuming there was some subtle reason not to.
> >
> 
> I think that it was simply being treated semantically as a lock - but it
> is actually not.
>                        hold a
>  migrate_disable/lock  per_cpu  unlock/migrate_enable
>  lock/migrate_disable  per_cpu  migrate_enable/unlcok
>  lock/migrate_disable  per_cpu  unlock/migrate_enable
>  migrate_disable/lock  per_cpu  migrate_enable/unlcok
>                        reference
> 
> are all equivalent - the only thing you need to ensure that the per cpu 
> object will not be accessed before both lock and migration_disable have
> been sucessful. So from my understanding this is safe.

I think you may be right, but I'm still a little nervous about this
code. But that's good. We all should be nervous about any locking
code ;-)

> 
> if we get migrated after a succesful trylock what would go wrong ?
> the protected object will not be accessed until after the spin_trylock
> returned so migration is disabled

I agree.

> 
> > If there was some strange reason, I'm not convinced that your change
> > makes that reason go away.
> >
> IF there is a reason then this patch is broken - my conclusion up to now
> is that there is no such reason.
> 

Let me analyze the original code first. I'll poke peterz and tglx too
to make sure this modification is OK.

Thanks,

-- Steve
