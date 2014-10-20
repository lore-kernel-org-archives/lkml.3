Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaJTIsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:48:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaJTIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:48:33 -0400
Date: Mon, 20 Oct 2014 10:48:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        mpe@ellerman.id.au, anton@samba.org, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141020084813.GB3219@twins.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <20141019213534.GG23531@worktop.programming.kicks-ass.net>
 <CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 05:08:08PM -0700, Andy Lutomirski wrote:
> Before I totally screw this up: is .event_idx used for anything except
> userspace rdpmc? 

It should only be used for that.

> There are a whole bunch of implementations of that
> callback:
> 
>  - perf_event_idx_default seems fishy

I suppose I did that to encode the rule that 0 := disabled, figuring
that if there is no actual instruction to access the data, all of this
would be pointless anyhow.

>  - power_pmu_event_idx seems even fishier

Agreed, I preserved behaviour in 35edc2a5095e ("perf, arch: Rework
perf_event_index()") and at that time asked about why this is. Nobody
replied, lets try again.

Michael, Anton?

>  - cpumsf_pmu_event_idx is the same as power_pmu_event_idx.

Oh cute, lets ask the s390 people, do you guys have a userspace
instruction to read the actual counter value?

>  - perf_swevent_event_idx returns 0.

Right, guaranteed no way to access any of that, maybe we should make
the default like that too.

> etc.
> 
> x86 is the only implementation of arch_perf_update_userpage, which
> makes me think that the .event_idx callback should just be removed and
> that arch_perf_update_userpage should be responsible for filling it in
> if needed.

Its a per pmu thing, with the x86 hardware pmu being the only one that's
actually 'known' working to me.

All the other x86 pmus like the software, uncore, etc. don't support
this.

That said, there's definitely room for improvement here.
