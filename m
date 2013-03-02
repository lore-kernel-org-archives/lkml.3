Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3CBVXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:23:17 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28669 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3CBVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:23:16 -0500
Message-ID: <1362259393.3602.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 0/2] ipc: do not hold ipc lock more than necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 02 Mar 2013 13:23:13 -0800
In-Reply-To: <CA+55aFwNoK+Bt07s-fnxRSPHy3Cqq6yZtGP+B2ingxEnkArhVQ@mail.gmail.com>
References: <1362183392.3420.23.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwNoK+Bt07s-fnxRSPHy3Cqq6yZtGP+B2ingxEnkArhVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 17:32 -0800, Linus Torvalds wrote:
> On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> >
> > With Rik's semop-multi.c microbenchmark we can see the following
> > results:
> 
> Ok, that certainly looks very good.
> 
> > +  59.40%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
> > +  17.47%            a.out  [kernel.kallsyms]  [k] _raw_spin_lock
> 
> I had somewhat high expectations, but that's just better than I really
> hoped for. Not only is the percentage down, it's down for the case of
> a much smaller number of overall cycle cost, so it's a really big
> reduction in contention spinning.
> 
> Of course, contention will come back and overwhelm you at *some*
> point, but it seems the patches certainly moved the really bad
> contention point out some way..
> 
> > +   6.14%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
> > +  11.08%            a.out  [kernel.kallsyms]  [k] sys_semtimedop
> > While the _raw_spin_lock time is drastically reduced, others do increase.
> > This results in an overall speedup of ~1.7x regarding ops/sec.
> 
> Actually, the others don't really increase. Sure, the *percentages* go
> up, but that's just because it has to add up to 100% in the end. So
> it's not that you're moving costs from one place to another - the 1.7x
> speedup is the real reduction in costs, and then that 6.14% -> 11.08%
> "growth" is really nothing but that (and yes, 1.7 x 6.14 really does
> get pretty close).
> 
> So nothing really got slower, despite the percentages going up.
> 
> Looks good to me. Of course, the *real* issue is if this is a win on
> real code too. And I bet it is, it just won't be quite as noticeable.
> But if anything, real code is likely to have less contention to begin
> with, because it has more things going on outside of the spinlocks. So
> it should see an improvement, but not nearly the kind of improvement
> you quote here.
> 
> Although your 800-user swingbench numbers were pretty horrible, so
> maybe that case can improve by comparable amounts in the bad cases.
> 

Absolutely, I'll be sure to try these changes with my Oracle workloads
and report with some numbers. This obviously still needs a lot of
testing.

Thanks,
Davidlohr

