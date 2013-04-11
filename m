Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3DKS0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:26:13 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55516 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3DKS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:26:11 -0400
Date: Thu, 11 Apr 2013 20:26:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130411182603.GG17129@somewhere.redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <1365687946.8824.3.camel@laptop>
 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
 <1365703670.10217.10.camel@laptop>
 <20130411182201.GE17129@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411182201.GE17129@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:22:03PM +0200, Frederic Weisbecker wrote:
> On Thu, Apr 11, 2013 at 08:07:50PM +0200, Peter Zijlstra wrote:
> > On Thu, 2013-04-11 at 08:38 -0700, Linus Torvalds wrote:
> > > On Thu, Apr 11, 2013 at 6:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Tue, 2013-03-26 at 15:01 +0100, Stanislaw Gruszka wrote:
> > > >> Thoughts?
> > > >
> > > > Would something like the below work?
> > > 
> > > Ugh, this is hard to think about, it's also fairly inefficient.
> > > 
> > > >  static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
> > > >  {
> > > > -       u64 rem, res, scaled;
> > > > +       int stime_fls = fls64(stime);
> > > > +       int total_fls = fls64(total);
> > > > +       int rtime_fls = fls64(rtime);
> > > 
> > > Doing "fls64()" unconditionally is quite expensive on some
> > > architectures, 
> > 
> > Oh, I (wrongly it appears) assumed that fls was something cheap :/
> > 
> > > and if I am not mistaken, the *common* case (by far) is
> > > that all these values fit in 32 bits, no?
> > 
> > It depends on if we use cputime_jiffies.h or cputime_nsec.h and I'm
> > completely lost as to which we default to atm. But we sure can reduce
> > to 32 bits in most cases without too much problems.
> 
> We default to the jiffies. The nsecs case is used only for full dynticks
> accounting and ia64 precise accounting.

Oh and in the latter case there is no scaling.
