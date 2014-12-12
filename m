Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbaLLUIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:08:30 -0500
Received: from mail.lang.hm ([64.81.33.126]:52491 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbaLLUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:08:29 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 15:08:29 EST
Date: Fri, 12 Dec 2014 11:58:50 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz>
References: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com> <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com> <1417806247.4845.1@mail.thefacebook.com> <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com> <20141211145408.GB16800@redhat.com> <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com> <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014, Linus Torvalds wrote:

> I'm also not sure if the bug ever happens with preemption disabled.
> Sasha, was that you who reported that you cannot reproduce it without
> preemption? It strikes me that there's a race condition in
> __cond_resched() wrt preemption, for example: we do
>
>        __preempt_count_add(PREEMPT_ACTIVE);
>        __schedule();
>        __preempt_count_sub(PREEMPT_ACTIVE);
>
> and in between the __schedule() and __preempt_count_sub(), if an
> interrupt comes in and wakes up some important process, it won't
> reschedule (because preemption is active), but then we enable
> preemption again and don't check whether we should reschedule (again),
> and we just go on our merry ways.
>
> Now, I don't see how that could really matter for a long time -
> returning to user space will check need_resched, and sleeping will
> obviously force a reschedule anyway, so these kinds of races should at
> most delay things by just a tiny amount,

If the machine has NOHZ and has a cpu bound userspace task, it could take quite 
a while before userspace would trigger a reschedule (at least if I've understood 
the comments on this thread properly)

David Lang
