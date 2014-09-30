Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaI3Nh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:37:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaI3Nh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:37:57 -0400
Date: Tue, 30 Sep 2014 15:37:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com, oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched, time: cmpxchg does not work on 64-bit variable
Message-ID: <20140930133749.GD4241@worktop.programming.kicks-ass.net>
References: <2547036.UshV4pXvhf@wuerfel>
 <542AA33E.2050008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542AA33E.2050008@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 08:34:06AM -0400, Rik van Riel wrote:
> On 09/30/2014 07:56 AM, Arnd Bergmann wrote:
> > A recent change to update the stime/utime members of task_struct 
> > using atomic cmpxchg broke configurations on 32-bit machines with 
> > CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that uses 64-bit 
> > nanoseconds, leading to a link-time error:
> > 
> > kernel/built-in.o: In function `cputime_adjust': :(.text+0x25234):
> > undefined reference to `__bad_cmpxchg'
> > 
> > This reverts the change that caused the problem, I suspect the real
> > fix is to conditionally use cmpxchg64 instead, but I have not
> > checked if that will work on all architectures.
> 
> I see that kernel/sched/clock.c uses cmpxchg64 in a non
> architecture, non 64 bit specific piece of code, and
> nobody complained about that file not building, so I have
> to assume cmpxchg64 works :)

That code is only ever used on x86 and ia64, most other archs have
managed to not mess up their clocks quite as bad.
