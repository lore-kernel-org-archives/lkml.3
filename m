Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaAYGbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 01:31:46 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53644 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaAYGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 01:31:42 -0500
Message-ID: <1390631635.9258.56.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 24 Jan 2014 22:33:55 -0800
In-Reply-To: <20140124151437.GZ13532@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
	 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
	 <20140120113415.GE30183@twins.programming.kicks-ass.net>
	 <20140121221852.GT9037@kmo>
	 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
	 <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
	 <20140123191229.GW11314@laptop.programming.kicks-ass.net>
	 <1390505486.5567.1014.camel@haakon3.risingtidesystems.com>
	 <1390505904.5567.1019.camel@haakon3.risingtidesystems.com>
	 <20140124151437.GZ13532@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 16:14 +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 11:38:24AM -0800, Nicholas A. Bellinger wrote:
> > > AFAICT, those changes don't address the original bug that the series was
> > > trying to address, allowing the percpu_ida_alloc() tag stealing slow
> > > path to be interrupted by a signal..
> > > 
> > > Also, keep in mind this change needs to be backported to >= v3.12, which
> > > is why the percpu_ida changes have been kept to a minimum.
> 
> Well, the other option is to revert whatever caused the issue in the
> first place :-)
> 
> I'm not much for making ugly fixes just because its easier to backport.
> 

Me either, but given Kent's comment on subtle issues for larger
improvements in the tag stealing slow path, it's the right approach for
addressing a bug in stable code.

Also, I'd also prefer to avoid introducing new issues for blk-mq in the
first round of stable code, give the amount of testing it's already
undergone with percpu_ida for v3.13.

> > <A little too eager to SEND>
> > 
> > So would you prefer the following addition to the original bugfix
> > instead..?
> 
> I'll make a right old mess out of percpu_ida.c, but yeah.
> 

Kent and I would both like to see your improvements merged in upstream,
just not in a manner that would cause Greg-KH to start cursing loudly
for a stable backport.

That said, unless Jens throws a last minute NACK, I'll be queuing patch
#1 + #3 into target-pending/for-next for sunday night's build.

Jens, please feel free to pickup Patch #2 for a post v3.15 merge at your
earliest convenience.

Thanks,

--nab

> > diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> > index a48ce2e..58b6714 100644
> > --- a/lib/percpu_ida.c
> > +++ b/lib/percpu_ida.c
> > @@ -174,7 +174,8 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
> >                  *
> >                  * global lock held and irqs disabled, don't need percpu lock
> >                  */
> > -               prepare_to_wait(&pool->wait, &wait, state);
> > +               if (state != TASK_RUNNING)
> > +                       prepare_to_wait(&pool->wait, &wait, state);
> >  
> >                 if (!tags->nr_free)
> >                         alloc_global_tags(pool, tags);
> > @@ -199,8 +200,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
> >                 local_irq_save(flags);
> >                 tags = this_cpu_ptr(pool->tag_cpu);
> >         }
> > +       if (state != TASK_RUNNING)
> > +               finish_wait(&pool->wait, &wait);
> >  
> > -       finish_wait(&pool->wait, &wait);
> >         return tag;
> >  }
> >  EXPORT_SYMBOL_GPL(percpu_ida_alloc);
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


