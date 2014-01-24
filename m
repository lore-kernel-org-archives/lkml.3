Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaAXPPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:15:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaAXPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:15:05 -0500
Date: Fri, 24 Jan 2014 16:14:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140124151437.GZ13532@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
 <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
 <20140123191229.GW11314@laptop.programming.kicks-ass.net>
 <1390505486.5567.1014.camel@haakon3.risingtidesystems.com>
 <1390505904.5567.1019.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390505904.5567.1019.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:38:24AM -0800, Nicholas A. Bellinger wrote:
> > AFAICT, those changes don't address the original bug that the series was
> > trying to address, allowing the percpu_ida_alloc() tag stealing slow
> > path to be interrupted by a signal..
> > 
> > Also, keep in mind this change needs to be backported to >= v3.12, which
> > is why the percpu_ida changes have been kept to a minimum.

Well, the other option is to revert whatever caused the issue in the
first place :-)

I'm not much for making ugly fixes just because its easier to backport.

> <A little too eager to SEND>
> 
> So would you prefer the following addition to the original bugfix
> instead..?

I'll make a right old mess out of percpu_ida.c, but yeah.

> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index a48ce2e..58b6714 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -174,7 +174,8 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
>                  *
>                  * global lock held and irqs disabled, don't need percpu lock
>                  */
> -               prepare_to_wait(&pool->wait, &wait, state);
> +               if (state != TASK_RUNNING)
> +                       prepare_to_wait(&pool->wait, &wait, state);
>  
>                 if (!tags->nr_free)
>                         alloc_global_tags(pool, tags);
> @@ -199,8 +200,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
>                 local_irq_save(flags);
>                 tags = this_cpu_ptr(pool->tag_cpu);
>         }
> +       if (state != TASK_RUNNING)
> +               finish_wait(&pool->wait, &wait);
>  
> -       finish_wait(&pool->wait, &wait);
>         return tag;
>  }
>  EXPORT_SYMBOL_GPL(percpu_ida_alloc);
> 
> 
