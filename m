Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3KCSIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:08:17 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43142 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3KCSIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <20131103151704.GJ19466@laptop.lan>
References: <20131028132634.GO19466@laptop.lan>
	<20131028163418.GD4126@linux.vnet.ibm.com>
	<20131028201735.GA15629@redhat.com>
	<OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
	<20131030092725.GL4126@linux.vnet.ibm.com>
	<20131030112526.GI16117@laptop.programming.kicks-ass.net>
	<20131031064015.GV4126@linux.vnet.ibm.com>
	<20131101145634.GH19466@laptop.lan>
	<20131102173239.GB3947@linux.vnet.ibm.com>
	<20131103144017.GA25118@linux.vnet.ibm.com>
	<20131103151704.GJ19466@laptop.lan>
Date: Sun, 3 Nov 2013 10:08:14 -0800
X-Google-Sender-Auth: J4ZY1A5X6p3sjbTIIaeL2kboN_M
Message-ID: <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 7:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Nov 03, 2013 at 06:40:17AM -0800, Paul E. McKenney wrote:
>> If there was an smp_tmb(), I would likely use it in rcu_assign_pointer().
>
> Well, I'm obviously all for introducing this new barrier, for it will
> reduce a full mfence on x86 to a compiler barrier. And ppc can use
> lwsync as opposed to sync afaict. Not sure ARM can do better.
>
> ---
> Subject: arch: Introduce new TSO memory barrier smp_tmb()

This is specialized enough that I would *really* like the name to be
more descriptive. Compare to the special "smp_read_barrier_depends()"
maco: it's unusual, and it has very specific semantics, so it gets a
long and descriptive name.

Memory ordering is subtle enough without then using names that are
subtle in themselves. mb/rmb/wmb are conceptually pretty simple
operations, and very basic when talking about memory ordering.
"acquire" and "release" are less simple, but have descriptive names
and have very specific uses in locking.

In contrast "smp_tmb()" is a *horrible* name, because TSO is a
description of the memory ordering, not of a particular barrier. It's
also not even clear that you can have a "tso barrier", since the
ordering (like acquire/release) presumably is really about one
particular *store*, not about some kind of barrier between different
operations.

So please describe exactly what the semantics that barrier has, and
then name the barrier that way.

I assume that in this particular case, the semantics RCU wants is
"write barrier, and no preceding reads can move past this point".

Calling that "smp_tmb()" is f*cking insane, imnsho.

              Linus
