Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780AbaEFL3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:29:25 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46595 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600AbaEFL3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:29:23 -0400
Date: Tue, 6 May 2014 13:29:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, dave.hansen@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V3 2/2] powerpc/pseries: init fault_around_order for
 pseries
Message-ID: <20140506112917.GA29525@gmail.com>
References: <1398675690-16186-1-git-send-email-maddy@linux.vnet.ibm.com>
 <1398675690-16186-3-git-send-email-maddy@linux.vnet.ibm.com>
 <20140429070632.GB27951@gmail.com>
 <87d2fz47tg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2fz47tg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> > * Madhavan Srinivasan <maddy@linux.vnet.ibm.com> wrote:
> >
> >> Performance data for different FAULT_AROUND_ORDER values from 4 socket
> >> Power7 system (128 Threads and 128GB memory). perf stat with repeat of 5
> >> is used to get the stddev values. Test ran in v3.14 kernel (Baseline) and
> >> v3.15-rc1 for different fault around order values.
> >> 
> >> FAULT_AROUND_ORDER      Baseline        1               3               4               5               8
> >> 
> >> Linux build (make -j64)
> >> minor-faults            47,437,359      35,279,286      25,425,347      23,461,275      22,002,189      21,435,836
> >> times in seconds        347.302528420   344.061588460   340.974022391   348.193508116   348.673900158   350.986543618
> >>  stddev for time        ( +-  1.50% )   ( +-  0.73% )   ( +-  1.13% )   ( +-  1.01% )   ( +-  1.89% )   ( +-  1.55% )
> >>  %chg time to baseline                  -0.9%           -1.8%           0.2%            0.39%           1.06%
> >
> > Probably too noisy.
> 
> A little, but 3 still looks like the winner.
> 
> >> Linux rebuild (make -j64)
> >> minor-faults            941,552         718,319         486,625         440,124         410,510         397,416
> >> times in seconds        30.569834718    31.219637539    31.319370649    31.434285472    31.972367174    31.443043580
> >>  stddev for time        ( +-  1.07% )   ( +-  0.13% )   ( +-  0.43% )   ( +-  0.18% )   ( +-  0.95% )   ( +-  0.58% )
> >>  %chg time to baseline                  2.1%            2.4%            2.8%            4.58%           2.85%
> >
> > Here it looks like a speedup. Optimal value: 5+.
> 
> No, lower time is better.  Baseline (no faultaround) wins.
> 
> 
> etc.

ah, yeah, you are right. Brainfart of the week...

> It's not a huge surprise that a 64k page arch wants a smaller value 
> than a 4k system.  But I agree: I don't see much upside for FAO > 0, 
> but I do see downside.
> 
> Most extreme results:
> Order 1: 2% loss on recompile.  10% win 4% loss on seq.  9% loss random.
> Order 3: 2% loss on recompile.  6% win 5% loss on seq.  14% loss on random.
> Order 4: 2.8% loss on recompile. 10% win 7% loss on seq.  9% loss on random.
> 
> > I'm starting to suspect that maybe workloads ought to be given a 
> > choice in this matter, via madvise() or such.
> 
> I really don't think they'll be able to use it; it'll change far too 
> much with machine and kernel updates. [...]

Do we know that?

> [...] I think we should apply patch
> #1 (with fixes) to make it a variable, then set it to 0 for PPC.

Ok, agreed - at least until contrary data comes around.

Thanks,

	Ingo
