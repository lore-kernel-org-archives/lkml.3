Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaLMXrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:47:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58307 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaLMXrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:47:42 -0500
Date: Sat, 13 Dec 2014 23:47:30 +0000
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
Message-ID: <20141213234730.GP22149@ZenIV.linux.org.uk>
References: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
 <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
 <20141213233508.GN22149@ZenIV.linux.org.uk>
 <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 03:38:57PM -0800, Linus Torvalds wrote:
> On Sat, Dec 13, 2014 at 3:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Er...  There's much more direct reason - suppose we get a timer interrupt
> > right in the middle of mnt_drop_write().  And lost the timeslice.
> 
> So?
> 
> You didn't have preemption disabled in *between* the mnt_want_write()
> and mnt_drop_write(), there's absolutely no reason to have it inside
> of them.
> 
> Nobody cares if you get preempted and go away for a while. It's
> exactly equivalent to sleeping while doing the write that the pair was
> protecting.
> 
> Seriously, the preemption disable looks like just voodoo code. It
> doesn't protect anything, it doesn't fix anything, it doesn't change
> anything. All it does is disable preemption over a random sequence of
> code.

Huh?  Sure, we can enable it after mnt_inc_writers() and disable just prior to
mnt_dec_writers(), but we absolutely *do* need it disabled during either.
Is that what you are talking about?  If so, yes, we can do that.

But that applies only to __mnt_want_write() - __mnt_drop_write() is pure
mnt_dec_writers() and we can't call that one with preemption enabled.
Seriously, look at the mnt_dec_writers():
static inline void mnt_dec_writers(struct mount *mnt)
{
#ifdef CONFIG_SMP
        this_cpu_dec(mnt->mnt_pcp->mnt_writers);  
#else
        mnt->mnt_writers--;
#endif
}
It's load/modify/store, without any kind of atomicity; get preempted in the
middle of that sequence by another caller of mnt_dec_writers() and obvious bad
things will happen...

Al, really confused by now...
