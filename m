Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaJTKvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:51:23 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:58619 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaJTKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:51:20 -0400
Date: Mon, 20 Oct 2014 12:51:10 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        mpe@ellerman.id.au, anton@samba.org, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141020105110.GA5002@linux.vnet.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Erik Bosman <ebn310@few.vu.nl>, mpe@ellerman.id.au, anton@samba.org,
	schwidefsky@de.ibm.com
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <20141019213534.GG23531@worktop.programming.kicks-ass.net>
 <CALCETrX3XYGd+2x_W89wq5tkuMBNF5NxDa02ha=UzQhU2r6Khg@mail.gmail.com>
 <20141020084813.GB3219@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020084813.GB3219@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102010-0041-0000-0000-000001BB4A9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:48:13AM +0200, Peter Zijlstra wrote:
> On Sun, Oct 19, 2014 at 05:08:08PM -0700, Andy Lutomirski wrote:
> > There are a whole bunch of implementations of that
> > callback:
> > 
> >  - perf_event_idx_default seems fishy
> 
> I suppose I did that to encode the rule that 0 := disabled, figuring
> that if there is no actual instruction to access the data, all of this
> would be pointless anyhow.

See comment on "perf_swevent_event_idx returns 0".

> 
> >  - cpumsf_pmu_event_idx is the same as power_pmu_event_idx.
> 
> Oh cute, lets ask the s390 people, do you guys have a userspace
> instruction to read the actual counter value?

For the hardware sampling pmu (cpumsf) there is no instruction to read
sampling data in user space.  Also the event->hw.index is always set
to zero anyway.  I am going to remove this function and let the core
event code handle the proper default.

As Martin Schwidefsky pointed out in his mail, there is an instruction
to read some hardware counter data (different to the sampling data).
User space is prohibited to use this instruction.  Instead, user space
can use another approach which is called runtime instrumentation, for
self-monitoring.

> 
> >  - perf_swevent_event_idx returns 0.
> 
> Right, guaranteed no way to access any of that, maybe we should make
> the default like that too.

I think it would makes sense to return 0 as default in the
perf_event_idx_default() and let each PMU/arch that actually supports
reading PMCs from user space return the proper index.  And according
to tools/perf/design.txt, index must be non-zero to trigger a user space
read.

Thanks and kind regards,
  Hendrik

