Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3JAAgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 20:36:16 -0400
Received: from ozlabs.org ([203.10.76.45]:51205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab3JAAgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 20:36:14 -0400
From: Michael Neuling <mikey@neuling.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux: transactional memory
In-reply-to: <1380581522.6396.20.camel@pasglop>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com> <1380581522.6396.20.camel@pasglop>
Comments: In-reply-to Benjamin Herrenschmidt <benh@kernel.crashing.org>
   message dated "Tue, 01 Oct 2013 08:52:02 +1000."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 01 Oct 2013 10:36:11 +1000
Message-ID: <23118.1380587771@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

> On Mon, 2013-09-30 at 12:29 -0700, Linus Torvalds wrote:
> > 
> > But I'm cc'ing the POWER people, because I don't know the POWER8
> > interfaces, and I don't want to necessarily call this "xbegin"/"xend"
> > when I actually wrap it in some helper functions.
> 
> The main problem with powerpc TM is that we need to handle interrupts
> happening while in transactional state. We currently only handle that
> for userspace.

Yep.  

> Mikey, how hard would it be to detect the in-kernel TM case and just
> simulate an abort in the exception entry ? (return to tbegin basically)

It's doable.

The scary part is that we to make all register volatile.  You were not
that keen on doing this as there are a lot of places in exception
entry/exit where we only save/restore a subset of the registers.  We'd
need to catch all these.

> Transactions in kernel make me nervous because of the PC jumping
> around on aborts and how easy we can get that stuff wrong :-) 

The same applies for userspace.  We are pretty careful not to screw that
up though.

It's also one of the reason we don't do software rollback of userspace
transactions even in transactional (non-suspended) mode.  We always save
and restore all state and let the HW deal with the PC and state jumping
around.

> They also have interesting ordering semantics vs. locks, we need to be
> a tad careful (as long as we don't access a lock variable
> transactionally we should be ok. If we do, then spin_unlock needs a
> stronger barrier).

Yep.

> The basic semantic for us is tbegin. [...] tend instructions. If the
> transaction fails, control returns to tbegin. (can happen at any
> point) which returns a CC code indicating success or failure.

FWIW eg.

     tbegin
     beq abort /* passes first time through */
     ....
     transactional stuff
     ....
     tend
     b pass
     
abort:

pass:

> Things get really complicated if you take an interrupt however, the
> transaction gets into some special "suspended" state, it doesn't just
> die so we need to handle things in our interrupt entry (even if it's
> just to make the transaction abort cleanly) and right now we don't
> when coming from kernel space.

Yep, but we could check easily enough.

Mikey
