Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaLMXf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:35:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58214 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLMXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:35:25 -0500
Date: Sat, 13 Dec 2014 23:35:09 +0000
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
Message-ID: <20141213233508.GN22149@ZenIV.linux.org.uk>
References: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
 <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 03:09:59PM -0800, Linus Torvalds wrote:
> On Sat, Dec 13, 2014 at 2:59 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > The generic code does that mnt_want_write/mnt_drop_write
> > dance adound the call to setxattr, and that in turn does
> >
> >         while (ACCESS_ONCE(mnt->mnt.mnt_flags) & MNT_WRITE_HOLD)
> >                 cpu_relax();
> >
> > with preemption explicitly disabled.
> 
> Btw, I see no reason why mnt_want_write/mnt_drop_write disables
> preemption. They don't care, they just care about the ordering of the
> write counts and the MNT_WRITE_HOLD bit. It's the code that sets the
> bit that should care, afaik. But maybe I'm missing something.

Er...  There's much more direct reason - suppose we get a timer interrupt
right in the middle of mnt_drop_write().  And lost the timeslice.
On UP we have mnt->mnt_writers--, with no locks held.  On SMP we have
this_cpu_dec() instead, also without any locks.  You really don't want to
lose the timeslice in the middle of either...
