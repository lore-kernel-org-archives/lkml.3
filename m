Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3JWUsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:48:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55201 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JWUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:48:50 -0400
Date: Wed, 23 Oct 2013 22:48:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        dave.hansen@linux.intel.com, Stephane Eranian <eranian@google.com>,
        jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131023204838.GB19466@laptop.lan>
References: <20131016230712.GC26785@twins.programming.kicks-ass.net>
 <20131017094145.GE3364@laptop.programming.kicks-ass.net>
 <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
 <20131022211237.GH2490@laptop.programming.kicks-ass.net>
 <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 08:09:53AM +0100, Linus Torvalds wrote:
> On Tue, Oct 22, 2013 at 10:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> Careful! There is one magic piece of state that you need to
> >> save-and-restore if you do this, namely %cr2. Taking a page fault
> >> always writes to %cr2, and we must *not* corrupt it in the NMI
> >> handler.
> >
> > It looks like this is already dealt with (a similar thing is done for
> > i386).
> 
> Oh, ok then, we should be good to go. I wonder why we needed that
> special "_nmi()" version, then..

Ah, the whole fault from nmi trickery from Steve is from after we did
the copy_from_user_nmi() thing. We're only just catching up :-)

> Please do check that NMI increment the irq-counts etc.. Otherwise
> you'll need to add the explicit "pagefault_disable/enable()" pair
> around the __copy_from_user_inatomic()..

Yeah, we add NMI_OFFSET to preempt_count on nmi_enter.

I'll also make sure to test we actually hit the fault path
by concurrently running something like:

 while :; echo 1 > /proc/sys/vm/drop_caches ; done

while doing perf top or so.. 
