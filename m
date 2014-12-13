Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965832AbaLMHnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 02:43:39 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62448 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbaLMHni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 02:43:38 -0500
Date: Sat, 13 Dec 2014 08:43:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213074332.GE32572@gmail.com>
References: <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <CA+55aFwLZi-JXAx9U-6rPPqoD1rmFjbzhv4acA9NKWEKo-UPRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwLZi-JXAx9U-6rPPqoD1rmFjbzhv4acA9NKWEKo-UPRg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Dec 12, 2014 at 11:58 AM, David Lang <david@lang.hm> wrote:
> >
> > If the machine has NOHZ and has a cpu bound userspace task, 
> > it could take quite a while before userspace would trigger a 
> > reschedule (at least if I've understood the comments on this 
> > thread properly)
> 
> The thing is, we'd have to return to user space for that to 
> happen. And when we do that, we check the "should we schedule" 
> flag again. So races like this really shouldn't matter, but 
> there could be something kind-of-similar that just ends up 
> causing a wakeup to be delayed.

Furthermore there ought to be a scheduler tick active in that 
case - which won't be as fast as an immediate reschedule, but 
fast enough to beat the softlockup watchdog's threshold of 20 
seconds or so.

That is why I think it would be interesting to examine how the 
locked up state looks like: is the system truly locked up, 
impossible to log in to, locks held but not released, etc., or is 
the lockup transient?

> But it would need to be delayed for seconds (for the RCU 
> threads) or for tens of seconds (for the watchdog) to matter.
> 
> Which just seems unlikely. Even the "very high load" thing 
> shouldn't really matter, since while that could delay one 
> particular thread being scheduled, it shouldn't delay the next 
> "should we schedule" test. In fact, high load would normally be 
> extected to make the next "should we schedule" come faster.
> 
> But this is where some load calculation overflow might screw 
> things up, of course.

Also, the percpu watchdog threads are SCHED_FIFO:99, woken up 
through percpu hrtimers, which are not easy to delay through high 
SCHED_OTHER load.

Thanks,

	Ingo
