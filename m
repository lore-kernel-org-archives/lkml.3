Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3I0Gpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:45:35 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:46259 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab3I0Gpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:45:33 -0400
In-Reply-To: <1380219317.32071.6.camel@dvhart-mobl4.amr.corp.intel.com>
References: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn> <1380219317.32071.6.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: Re: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
X-KeepSent: FC4F71E6:FCD3279D-48257BF3:000E2A58;
 type=4; name=$KeepSent
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFFC4F71E6.FCD3279D-ON48257BF3.000E2A58-48257BF3.00251AFA@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 27 Sep 2013 14:45:05 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-09-27 14:45:10
MIME-Version: 1.0
Content-type: text/plain; charset=GB2312
X-MAIL: mse01.zte.com.cn r8R6jHPS049311
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8R6ji2J020973



Darren Hart <dvhart@linux.intel.com> wrote on 2013/09/27 02:15:17:


> Re: [PATCH] futex: Remove the owner check when waking task in handle_futex_death
>
> On Thu, 2013-09-26 at 09:09 +0800, zhang.yi20@zte.com.cn wrote:
> > Hi all,
> >
> > Task processes all its owned robust futex when it is exiting,
> > to ensure the futexes can be taken by other tasks.
> >
> > Though this can not work good in sometimes.
> > Think about this scene£º
> > 1. A robust mutex is shared for two processes, each process has
> >    multi threads to lock the mutex.
> > 2. One of the threads locks the mutex, and the others are waiting
> >    and sorted in order of priority.
> > 3. The process to which the mutex owner thread belongs is dying
> >    without unlocking the mutex£¬and handle_futex_death is invoked
> >    to wake the first waiter.
> > 4. If the first waiter belongs to the same process£¬it has no chance
> >    to return to the userspace to lock the mutex, and it won't wake
> >    the next waiter because it is not the owner of the mutex.
> > 5. The rest waiters of the other process may block forever.
> >
> > This patch remove the owner check when waking task in handle_futex_death.
> > If above occured, The dying task can wake the next waiter by processing its list_op_pending.
> > The waked task could return to userspace and try to lock the mutex again.
> >
>
> The problem is if you allow the non-owner to do the wake, you risk
> multiple threads calling futex_wake(). Or is that your intention? Wake
> one waiter for every thread that calls handle_futex_death()?

Yes.

> >
> > Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> > Reviewed-by: Xie Baoyou <xie.baoyou@zte.com.cn>
> > Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> >
> >
> >
> > --- linux/kernel/futex.c   2013-09-25 09:24:34.639634244 +0000
> > +++ linux/kernel/futex.c   2013-09-25 10:12:17.619673546 +0000
> > @@ -2541,14 +2541,15 @@ retry:
> >        }
> >        if (nval != uval)
> >           goto retry;
> > -
> > -      /*
> > -       * Wake robust non-PI futexes here. The wakeup of
> > -       * PI futexes happens in exit_pi_state():
> > -       */
> > -      if (!pi && (uval & FUTEX_WAITERS))
> > -         futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
> >     }
> > +
> > +   /*
> > +    * Wake robust non-PI futexes here. The wakeup of
> > +    * PI futexes happens in exit_pi_state():
> > +    */
> > +   if (!pi)
>
>
> Why did you drop the FUTEX_WAITERS condition?
>
> You sent a different patch earlier this year that didn't appear to get
> any review:
>
> https://lkml.org/lkml/2013/4/8/65
>
> This one woke all the waiters and let them sort it out.
>
> It seems we've hashed through this already, but I'm not finding the
> email logs and I don't recall off the top of my head.
>
> > +      futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
> > +
> >     return 0;
> >  }
>

The earlier patch cannot solve another problem:
The owner wakes the next waiter through normal unlocking which make the
futex value as zero, the waked task exits before actually locking the mutex.
In this case, the owner doesn't call handle_futex_death() and the waked task
doesn't call futex_wake() when they are dying. The rest waiters will still
block as the same.

This is also the reason that I drop the owner and FUTEX_WAITERS check,
because the futex value can be zero at that time.

In normal case, the userspace code ensure that the owner of lock in robust-list
is current task, we may do redundant waking just for the  list_op_pending.
So I think the patch results in little negative effect.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
