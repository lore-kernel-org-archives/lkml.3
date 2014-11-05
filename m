Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaKEPpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:45:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:46157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbaKEPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:45:43 -0500
Date: Wed, 5 Nov 2014 16:45:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Kan Liang <kan.liang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Message-ID: <20141105154535.GU3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
 <1415156173-10035-14-git-send-email-kan.liang@intel.com>
 <20141105092145.GP10501@worktop.programming.kicks-ass.net>
 <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
 <20141105104359.GP3337@twins.programming.kicks-ass.net>
 <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
 <20141105124926.GS3337@twins.programming.kicks-ass.net>
 <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 02:22:07PM +0100, Stephane Eranian wrote:
> I tend to agree here. The problem with FP is that it is not easy to figure
> out how a binary has been compiled. Getting valid FP callchains for
> large binaries using lots of shared libraries is very challenging. All
> libraries must be compiled with FP. It is not easy to test if FP was
> compiled in. There is no ELF header flag for this. Need to inspect
> the x86 asm and look at function prologues.

build world ftw :-), I realize that on many distros this is hard, but in
some environments its really rather easy.

But yes, its tedious without the capability to build world.

> This is where LBR has an advantage, it works regardless of how
> a binaries and shared libs have been compiled. That is why this is
> a good (or some would say better) approach which is using hardware
> assist.

Right, but only because we made of mess of the thing in the first place
:-/

> > We're all more familiar with FP, and it doesn't have the obvious problem
> > if only 16 entries. I've worked on quite a bit of software that had much
> > deeper callchains -- yay for recursive algorithms and/or C++.
> >
> Yes, this is true too. But it is not so clear to me if people really care about
> top of callchains that much. I think usually 2-6 would probably yield enough
> useful info.

Right, with C++ if you have a particularly gruesome object hierarchy a
simple constructor can blow your entire 16 calls out the window, so when
you then get around to doing actual work there's nothing left.

But yes, that should not be too common I think.

> LBR callstack fails for leaf function optimization. Where the callee does
> not return to its caller but instead to the caller's caller. That is the one
> case I know about. There are others I believe.

Yeah, tail call and jong jump might also confuse the thing, I can't
remember.

> > With a bit of care FP can be 'perfect', although Andi likes to point out
> > that glibc isn't and often wrecks FP :-(
> >
> Especially any hand-crafted assembly...

Well, it doesn't need to. But yes its easy to do wrong in that case.

> I don't think it would be very hard to modify the patch set to make that 3rd
> mode visible. Just need to make that new PERF_RECORD_* type visible
> to user and modify the compatibility checks.

There's no new RECORD type afaict; would not the relatively simple patch
I proposed be enough? It exposes PERF_SAMPLE_BRANCH_CALL_STACK and you'd
get the data through the normal PERF_SAMPLE_BRANCH_STACK output.
