Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab3KOL5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:57:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50859 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab3KOL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:57:32 -0500
Date: Fri, 15 Nov 2013 11:57:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation
 of TLB entries
Message-ID: <20131115115701.GA1047@darko.cambridge.arm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
 <1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
 <CAHkRjk6LAmQpkioBdFxH5htYHi75bR2xhfXzfvmQL5Br0kMgvg@mail.gmail.com>
 <20131114091007.0b15dde2@mschwide>
 <20131114132223.GG20261@arm.com>
 <20131114173359.2e3cbd60@mschwide>
 <20131115104437.GA573@darko.cambridge.arm.com>
 <20131115121000.69219fa4@mschwide>
 <20131115121736.72170c36@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115121736.72170c36@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:17:36AM +0000, Martin Schwidefsky wrote:
> On Fri, 15 Nov 2013 12:10:00 +0100
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Fri, 15 Nov 2013 10:44:37 +0000
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > 1. thread-A running with mm-A
> > > 2. context_switch() to thread-B1 causing a switch_mm(mm-B)
> > > 3. switch_mm(mm-B) sets thread-B1's TIF_TLB_WAIT but does _not_ call
> > >    update_mm(mm-B). Hardware still using mm-A
> > > 4. scheduler unlocks and is about to call finish_mm_switch(mm-B)
> > > 5. interrupt and preemption before finish_mm_switch(mm-B)
> > > 6. context_switch() to thread-B2 causing a switch_mm(mm-B) (note here
> > >    that thread-B1 and thread-B2 have the same mm-B)
> > > 7. switch_mm() as in this patch exits early because prev == next
> > > 8. finish_mm_switch(mm-B) is indeed called but TIF_TLB_WAIT is not set
> > >    for thread-B2, therefore no call to update_mm(mm-B)
> > > 
> > > So after point 8, you get thread-B2 running (and possibly returning to
> > > user space) with mm-A. Do you see a problem here?
> > 
> > Oh, now I get it. Thanks for the patience, this is indeed a problem.
> > And I concur, a per-mm flag is the 'obvious' solution.
> 
> Having said that and looking at the code I find this to be not as obvious
> any more. If you have multiple cpus using a per-mm flag can get you into
> trouble:
> 
> 1. cpu #1 calls switch_mm and finds that irqs are disabled.
>    mm->context.switch_pending is set
> 2. cpu #2 calls switch_mm for the same mm and finds that irqs are disabled.
>    mm->context.switch_pending is set again
> 3. cpu #1 reaches finish_arch_post_lock_switch and finds switch_pending == 1
> 4. cpu #1 zeroes mm->switch_pending and calls cpu_switch_mm
> 5. cpu #2 reaches finish_arch_post_lock_switch and finds switch_pending == 0
> 6. cpu #2 continues with the old mm
> 
> This is a race, no?

Yes, but we only use this on ARMv5 and earlier and there is no SMP
support.

On arm64 however, I need to fix that and you made a good point. In my
(not yet public) patch, the switch_pending is cleared after all the
IPIs have been acknowledged but it needs some more thinking. A solution
could be to always do the cpu_switch_mm() in finish_mm_switch() without
any checks but this requires that any switch_mm() call from the kernel
needs to be paired with finish_mm_switch(). So your first patch comes in
handy (but I still need to figure out a quick arm64 fix for cc stable).

-- 
Catalin
