Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaFXPHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:07:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:13359 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaFXPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:07:07 -0400
Message-ID: <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 08:06:55 -0700
In-Reply-To: <20140623065835.GF19860@laptop.programming.kicks-ass.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
	 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 08:58 +0200, Peter Zijlstra wrote:
> On Fri, Jun 20, 2014 at 11:21:13AM -0700, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > The arch_mutex_cpu_relax() function, introduced by 34b133f, is
> > hacky and ugly. It was added a few years ago to address the fact
> > that common cpu_relax() calls include yielding on s390, and thus
> > impact the optimistic spinning functionality of mutexes. Nowadays
> > we use this function well beyond mutexes: rwsem, qrwlock, mcs and
> > lockref. Since the macro that defines the call is in the mutex header,
> > any users must include mutex.h and the naming is misleading as well.
> > 
> > This patch (i) renames the call to arch_cpu_relax (for lack of a better
> > name), and (ii) defines it in each arch's asm/processor.h local header,
> > just like for regular cpu_relax() functions. On all archs, except s390,
> > arch_cpu_relax is simply cpu_relax, and thus we can take it out of
> > mutex.h. While this can seem redundant or weird, I believe it is a
> > good choice as it allows us to move out arch specific logic from generic
> > locking primitives and enables future(?) archs to transparently define
> > it, similarly to System Z.
> > 
> > Please note that these changes are only tested on x86-64.
> 
> While I like the general idea; does anyone have a better name for this?
> So in particular, the difference is that on s390:
> 
>  cpu_relax()                - yields the vcpu
>  arch_{,mutex_}cpu_relax()  - will actually spin-wait

iirc Heiko had suggested cpu_relax_simple() in the past. I don't think
it's any better or worse than arch_cpu_relax(). For s390
cpu_relax_noyield() would perhaps be suitable, but not very descriptive
for the rest of the archs. I'm really lacking creativity for this name.

Thanks,
Davidlohr


