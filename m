Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaLRSyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:54:52 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:60505 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaLRSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:54:51 -0500
MIME-Version: 1.0
In-Reply-To: <1418918059.17358.6@mail.thefacebook.com>
References: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
Date: Thu, 18 Dec 2014 10:54:50 -0800
X-Google-Sender-Auth: u7hjV9eabpocgYGUT2Kbq5l4yNI
Message-ID: <CA+55aFxe3zSef5WyTVrvCBxM0G_Uetq28b0ERbBmWSWO4aVWxA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: Dave Jones <davej@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 7:54 AM, Chris Mason <clm@fb.com> wrote:
>
> CPU 2 seems to be the one making the least progress.  I think he's calling
> fork and then trying to allocate a debug object for his hrtimer, eventually
> wandering into fill_pool from __debug_object_init():

Good call.

I agree - fill_pool() seems to be just plain nasty.

We've had this bug before, btw - a *loong* time ago in the original
kmalloc stuff. You really should not fill a pool of memory that way.
It's fundamentally wrong to fill a pool and then (later - after having
released and re-aqcuired the lock) allocate from the pool. Somebody
else will steal the allocations you did, and take advantage of your
work.

The high/low watermarks are done completely wrong for that thing too -
if things fall below a minimum level, you want to try to make sure it
grows clearly past the minimum, so that you don't get stuck just
around the minimum. But you need to spread out the pain, rather than
make one unlucky allocator have to do all the work.

> It might be fun to run with CONFIG_DEBUG_OBJECTS off...Linus' patch clearly
> helped, I think we're off in a different bug now.

I'm not sure it was my patch. I'm wondering if it's because Dave still
has preemption off, and the backtraces look different (and better) as
a result.

But yes, trying with DEBUG_OBJECTS off might be a good idea. It's
entirely possible that the debug code is actually triggering bugs of
its own, rather than showing other peoples bugs.

                         Linus
