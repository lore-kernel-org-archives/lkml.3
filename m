Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbaDILrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:47:09 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:48815 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:47:07 -0400
Date: Wed, 9 Apr 2014 07:46:30 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>, tglx@linutronix.de,
        umgwanakikbuti@gmail.com, dvhart@linux.intel.com
Message-ID: <1096300004.2306764.1397043990013.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com> <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com> <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com> <20140408181305.GT10526@twins.programming.kicks-ass.net> <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com> <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com> <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF17 (Linux)/8.0.6_GA_5922)
Thread-Topic: futex: avoid race between requeue and wake
Thread-Index: eEnC8v6YzThmfHsqgP3LkZOpkXRf1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Linus Torvalds" <torvalds@linux-foundation.org>
> To: "Jan Stancek" <jstancek@redhat.com>
> Cc: "Peter Zijlstra" <peterz@infradead.org>, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "Srikar
> Dronamraju" <srikar@linux.vnet.ibm.com>, "Davidlohr Bueso" <davidlohr@hp.com>, "Ingo Molnar" <mingo@kernel.org>,
> "Larry Woodman" <lwoodman@redhat.com>
> Sent: Wednesday, 9 April, 2014 12:30:07 AM
> Subject: Re: [PATCH] futex: avoid race between requeue and wake
> 
> On Tue, Apr 8, 2014 at 2:02 PM, Jan Stancek <jstancek@redhat.com> wrote:
> >
> > I ran reproducer with following change on s390x system, where this
> > can be reproduced usually within seconds:
> >
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 67dacaf..9150ffd 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -1095,6 +1095,7 @@ static int unlock_futex_pi(u32 __user *uaddr, u32
> > uval)
> >  static inline void
> >  double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket
> >  *hb2)
> >  {
> > +       hb_waiters_inc(hb2);
> >         if (hb1 <= hb2) {
> >                 spin_lock(&hb1->lock);
> >                 if (hb1 < hb2)
> > @@ -1111,6 +1112,7 @@ double_unlock_hb(struct futex_hash_bucket *hb1,
> > struct futex_hash_bucket *hb2)
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

I let this version run over night on single s390x system,
there were no failures.

> 
> Ok, that's encouraging. That is the smallest patch I could come up
> with, but as mentioned, it's not optimal. We only need it for
> futex_requeue(), but if we do it there we'd have to handle all the
> different error cases (there's only one call to double_lock_hb(), but
> due to the error cases there's four calls to double_unlock_hb().
> 
> I'm not sure how much we care. The simple patch basically adds two
> (unnecessary) atomics to the futex_wake_op() path. I don't know how
> critical that path is - not as critical as the regular "futex_wake()",
> I'd expect, but I guess pthread_cond_signal() is the main user.
> 
> So I'll have to leave this decision to the futex people. But the
> attached slightly more complex patch *may* be the better one.
> 
> May I bother you to test this one too? I really think that
> futex_requeue() is the only user that should need this, so doing it
> there rather than in double_[un]lock_hb() should be slightly more
> optimal, but who knows what I've missed. We clearly *all* missed this
> race back when the ordering rules were documented..

I'm running reproducer with this patch applied on 3 systems:
- two s390x systems where this can be reproduced within seconds
- x86_64 Intel(R) Xeon(R) CPU E5240 @ 3.00GHz, where I could
  reproduce it on average in ~3 minutes.

It's running without failure over 4 hours now.

Regards,
Jan

> 
> Still hoping for comments from PeterZ and Davidlohr.
> 
>                   Linus
> 
