Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161644Ab3DKSIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:08:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161570Ab3DKSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:08:04 -0400
Message-ID: <1365703670.10217.10.camel@laptop>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling
 overflow
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Date: Thu, 11 Apr 2013 20:07:50 +0200
In-Reply-To: <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	 <20130326140147.GB2029@redhat.com> <1365687946.8824.3.camel@laptop>
	 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 08:38 -0700, Linus Torvalds wrote:
> On Thu, Apr 11, 2013 at 6:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2013-03-26 at 15:01 +0100, Stanislaw Gruszka wrote:
> >> Thoughts?
> >
> > Would something like the below work?
> 
> Ugh, this is hard to think about, it's also fairly inefficient.
> 
> >  static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
> >  {
> > -       u64 rem, res, scaled;
> > +       int stime_fls = fls64(stime);
> > +       int total_fls = fls64(total);
> > +       int rtime_fls = fls64(rtime);
> 
> Doing "fls64()" unconditionally is quite expensive on some
> architectures, 

Oh, I (wrongly it appears) assumed that fls was something cheap :/

> and if I am not mistaken, the *common* case (by far) is
> that all these values fit in 32 bits, no?

It depends on if we use cputime_jiffies.h or cputime_nsec.h and I'm
completely lost as to which we default to atm. But we sure can reduce
to 32 bits in most cases without too much problems.

But that would mean fls() and shifting again for nsec based cputime.

I'll have a better read and think about the rest of your email but
that'll have to be tomorrow :/

