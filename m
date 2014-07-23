Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbaGWOZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:25:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaGWOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:25:07 -0400
Date: Wed, 23 Jul 2014 16:24:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723142454.GQ12054@laptop.lan>
References: <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
 <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723113021.GP12054@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:30:21PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 23, 2014 at 01:11:10PM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 23, 2014 at 10:45:46AM +0100, Dietmar Eggemann wrote:
> > > Doesn't the picture showing the captured panic reveal more information.
> > > Haven't seen it myself, I just saw Peter's reply to your email
> > 
> > Its a general protection fault from somewhere in load_balance(), I send
> > you the picture.
> > 
> > It would help to get addr2line of the RIP I suppose.
> > 
> > Michel provided a config, so lemme go try and build that, maybe my gcc
> > will generate similar code to his and the function offset is enough
> > clue.
> 
> So the code section says the faulting instruction is:
> 
>   f3 a5
> 
> followed by:
> 
>   48 89 c7 85 50 ff ff 
> 
> or so.
> 
> My compiled code is 'different', the function is shorter, but there's a
> f3 a5 somewhere not too far short of +d7 at +a8. I have (objdump -SD):
> 
>     35a8:       f3 a5                   rep movsl %ds:(%rsi),%es:(%rdi)
> 
>         for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
>                 unsigned long capacity, capacity_factor, wl;
>                 enum fbq_type rt;
> 
>                 rq = cpu_rq(i);
>     35aa:       48 c7 c1 00 00 00 00    mov    $0x0,%rcx
> 
> And that's the only part that could possibly match.
> 
> That looks like the start of find_busiest_queue(). I'm not entirely sure
> what the rep movsl is operating on, lemme try and figure that out.

Ah, this appears to be load_balance()'s:

	cpumask_copy(cpus, cpu_active_mask);

Which totally doesn't make sense, both src and dst are static storage.
Dst is the most interesting since its per-cpu storage, but still.

No way either of those should generate a #GP. Puzzled.
