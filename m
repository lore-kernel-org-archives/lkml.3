Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaLNAdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 19:33:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58613 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLNAdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 19:33:46 -0500
Date: Sun, 14 Dec 2014 00:33:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141214003332.GQ22149@ZenIV.linux.org.uk>
References: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
 <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
 <20141213233508.GN22149@ZenIV.linux.org.uk>
 <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
 <20141213234730.GP22149@ZenIV.linux.org.uk>
 <CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 04:14:58PM -0800, Linus Torvalds wrote:
> On Sat, Dec 13, 2014 at 3:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > static inline void mnt_dec_writers(struct mount *mnt)
> > {
> > #ifdef CONFIG_SMP
> >         this_cpu_dec(mnt->mnt_pcp->mnt_writers);
> > #else
> >         mnt->mnt_writers--;
> > #endif
> > }
> > It's load/modify/store, without any kind of atomicity; get preempted in the
> > middle of that sequence by another caller of mnt_dec_writers() and obvious bad
> > things will happen...
> 
> Ugh, yes ok, the UP case needs it for the actual counter itself. Ugh.
> What an ugly mess. I'd rather have the preemption disable where it is
> actually *needed*, in that function itself for the UP case (or just
> make it "atomic_t", which would likely be better still.

So does SMP - this_cpu_dec() relies on preemption being disabled.  On x86
we might get away with that, what with having it compiled into decl %gs:const,
but on generic it turns into
	*raw_cpu_ptr(&pcp) -= 1;
and compiler has every right to turn it into
	p = raw_cpu_ptr(&pcp);
	(*p)--;
again, with no locking.  Lose the timeslice in the middle of that and you
are risking to get a different CPU when you are scheduled again, with
another process doing this_cpu_dec() on your old CPU.  Have fun - two
non-atomic decrements of the same variable by different CPUs in parallel...

We really need preemtion disabled there, UP or no UP.
