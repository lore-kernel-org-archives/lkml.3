Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaFWLfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:35:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaFWLe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:34:59 -0400
Date: Mon, 23 Jun 2014 13:34:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
Message-ID: <20140623113448.GC13930@laptop.programming.kicks-ass.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
 <20140623065423.GE19860@laptop.programming.kicks-ass.net>
 <53A7D3AA.9020100@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A7D3AA.9020100@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 12:43:46PM +0530, Vineet Gupta wrote:
> Hi Peter,
> 
> On Monday 23 June 2014 12:24 PM, Peter Zijlstra wrote:
> > On Fri, Jun 20, 2014 at 11:21:13AM -0700, Davidlohr Bueso wrote:
> >> diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
> >> index d99f9b3..8e1bf6b 100644
> >> --- a/arch/arc/include/asm/processor.h
> >> +++ b/arch/arc/include/asm/processor.h
> >> @@ -62,6 +62,8 @@ unsigned long thread_saved_pc(struct task_struct *t);
> >>  #define cpu_relax()	do { } while (0)
> >>  #endif
> >>  
> >> +#define arch_cpu_relax() cpu_relax()
> >> +
> >>  #define copy_segments(tsk, mm)      do { } while (0)
> >>  #define release_segments(mm)        do { } while (0)
> > 
> > I'm not at all sure that cpu_relax() definition ARC has is valid. We
> > rely on cpu_relax() being at least a barrier() all over the place, and
> > it doesn't need to be SMP only. You can have a UP wait loop waiting for
> > an interrupt for example.
> > 
> > Vineet?
> 
> Over the years we've not had any trouble with !SMP cpu_relax() being a no-op (and
> barrier version was only required when we hit a hard hang in our our initial SMP
> code). UP busy wait looping would be frowned upon in general.
> 
> However what we have now is just a code optimization quirk for !SMP since a
> compiler barrier will cause gcc to dump out and reload scratch regs - specially
> for our deep reg file.
> 
> Here's what I get with current UP kernel switching to compiler barrier
> 
> ./scripts/bloat-o-meter vmlinux-pre-cpu-relax  vmlinux | head
> add/remove: 1/0 grow/shrink: 75/5 up/down: 1218/-32 (1186)
> function                                     old     new   delta
> path_init                                    708     826    +118
> sys_semtimedop                              2540    2640    +100
> ...
> __slab_alloc.isra.constprop                  564     560      -4
> deactivate_slab                              886     878      -8
> 
> So it doesn't look too bad, although I've not run any performance tests. We can
> switch UP to barrier if you feel it is needed semantically.

Hard call, semantically it makes more sense to have it barrier, its also
certainly safer. Then again, you say you've been running like this for
years etc.. and I agree that UP spin-loops _should_ be rare.
