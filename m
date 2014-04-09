Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaDICUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:20:06 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:19548 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbaDICUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:20:04 -0400
Message-ID: <1397009999.2432.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Stancek <jstancek@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Apr 2014 19:19:59 -0700
In-Reply-To: <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	 <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	 <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	 <20140408181305.GT10526@twins.programming.kicks-ass.net>
	 <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
	 <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
	 <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Thomas to the thread.

Sorry for the late reply, I was out running errands all day just to get
home to find this futex jewel in my inbox.

On Tue, 2014-04-08 at 15:30 -0700, Linus Torvalds wrote:
> On Tue, Apr 8, 2014 at 2:02 PM, Jan Stancek <jstancek@redhat.com> wrote:
> >
> > I ran reproducer with following change on s390x system, where this
> > can be reproduced usually within seconds:
> >
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 67dacaf..9150ffd 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -1095,6 +1095,7 @@ static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
> >  static inline void
> >  double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
> >  {
> > +       hb_waiters_inc(hb2);
> >         if (hb1 <= hb2) {
> >                 spin_lock(&hb1->lock);
> >                 if (hb1 < hb2)
> > @@ -1111,6 +1112,7 @@ double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
> >         spin_unlock(&hb1->lock);
> >         if (hb1 != hb2)
> >                 spin_unlock(&hb2->lock);
> > +       hb_waiters_dec(hb2);
> >  }
> >
> >  /*
> >
> > Reproducer is running without failures over an hour now and
> > made ~1.4 million iterations.
> 
> Ok, that's encouraging. That is the smallest patch I could come up
> with, but as mentioned, it's not optimal. We only need it for
> futex_requeue(), but if we do it there we'd have to handle all the
> different error cases (there's only one call to double_lock_hb(), but
> due to the error cases there's four calls to double_unlock_hb().

For consistency and mental sanity, I definitely prefer this alternative
to adding back the spin_is_locked check.

Linus, from what I see from your approach in always adding and
decrementing the hb->waiters count in futex_requeue right before the
whole double_[un]lock_hb() calls, we're basically saying "lets not do
this pending waiters optimization" for futex requeuing, right?
Which is fine, requeing isn't really that used or performance critical
in many cases. But I say it since the legitimate accounting for is done
in requeue_futex(), which can obviously be bogus as we increment *after*
taking the hb->lock. Just want to make sure we're on the same page here.

> 
> I'm not sure how much we care. The simple patch basically adds two
> (unnecessary) atomics to the futex_wake_op() path. I don't know how
> critical that path is - not as critical as the regular "futex_wake()",
> I'd expect, but I guess pthread_cond_signal() is the main user.

Agreed, since the issue occurs because we're requeuing *waiters*, lets
keep it inside the requeueing only. In the case of futex_wake_op() it
doesn't matter as we don't need to account for them. It's more code, but
that's it. I'd rather add error house keeping than add more unnecessary
logic to other paths of futexes.

> 
> So I'll have to leave this decision to the futex people. But the
> attached slightly more complex patch *may* be the better one.
> 
> May I bother you to test this one too? I really think that
> futex_requeue() is the only user that should need this, so doing it
> there rather than in double_[un]lock_hb() should be slightly more
> optimal, but who knows what I've missed. We clearly *all* missed this
> race back when the ordering rules were documented..

Yep, it's quite an obvious thing we overlooked here, and not even arch
specific... I'm surprised that the requeueing path isn't stressed more
often, and while the race window is quite small (I'm still running Jan's
program in a loop and cannot trigger it on my x86-64 80 core box), it
should have been seen earlier by some program/benchmark.

Thanks,
Davidlohr


