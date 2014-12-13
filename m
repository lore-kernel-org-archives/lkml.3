Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966148AbaLMIbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:31:01 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46133 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbaLMIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:31:00 -0500
Date: Sat, 13 Dec 2014 09:30:55 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213083055.GI32572@gmail.com>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
 <20141212203417.GE25340@linux.vnet.ibm.com>
 <548B5CEC.1040607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548B5CEC.1040607@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> On 12/12/2014 03:34 PM, Paul E. McKenney wrote:
> > On Fri, Dec 12, 2014 at 11:58:50AM -0800, David Lang wrote:
> >> > On Fri, 12 Dec 2014, Linus Torvalds wrote:
> >> > 
> >>> > >I'm also not sure if the bug ever happens with preemption disabled.
> >>> > >Sasha, was that you who reported that you cannot reproduce it without
> >>> > >preemption? It strikes me that there's a race condition in
> >>> > >__cond_resched() wrt preemption, for example: we do
> >>> > >
> >>> > >       __preempt_count_add(PREEMPT_ACTIVE);
> >>> > >       __schedule();
> >>> > >       __preempt_count_sub(PREEMPT_ACTIVE);
> >>> > >
> >>> > >and in between the __schedule() and __preempt_count_sub(), if an
> >>> > >interrupt comes in and wakes up some important process, it won't
> >>> > >reschedule (because preemption is active), but then we enable
> >>> > >preemption again and don't check whether we should reschedule (again),
> >>> > >and we just go on our merry ways.
> >>> > >
> >>> > >Now, I don't see how that could really matter for a long time -
> >>> > >returning to user space will check need_resched, and sleeping will
> >>> > >obviously force a reschedule anyway, so these kinds of races should at
> >>> > >most delay things by just a tiny amount,
> >> > 
> >> > If the machine has NOHZ and has a cpu bound userspace task, it could
> >> > take quite a while before userspace would trigger a reschedule (at
> >> > least if I've understood the comments on this thread properly)
> > Dave, Sasha, if you guys are running CONFIG_NO_HZ_FULL=y and
> > CONFIG_NO_HZ_FULL_ALL=y, please let me know.  I am currently assuming
> > that none of your CPUs are in NO_HZ_FULL mode.  If this assumption is
> > incorrect, there are some other pieces of RCU that I should be taking
> > a hard look at.
> 
> This is my no_hz related config:
> 
> $ grep NO_HZ .config
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ_FULL=y
> CONFIG_NO_HZ_FULL_ALL=y

Just curious, if you disable NO_HZ_FULL_ALL, does the bug change?

Thanks,

	Ingo
