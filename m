Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaKENWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:22:11 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62963 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKENWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141105124926.GS3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
	<1415156173-10035-14-git-send-email-kan.liang@intel.com>
	<20141105092145.GP10501@worktop.programming.kicks-ass.net>
	<CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
	<20141105104359.GP3337@twins.programming.kicks-ass.net>
	<CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
	<20141105124926.GS3337@twins.programming.kicks-ass.net>
Date: Wed, 5 Nov 2014 14:22:07 +0100
Message-ID: <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
Subject: Re: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording callchain
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kan Liang <kan.liang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 1:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Nov 05, 2014 at 11:57:10AM +0100, Stephane Eranian wrote:
>> Yes, but I wonder how would the tool sort this out if you have FP and LBR
>> for each sample.
>
> That's the tools 'problem'. It currently can already have FP and Dwarf
> bits. And it does not need to request all of them.
>
I was thinking about the case where the tool would request both FP and
LBR at the same to try and construct a complete callstack. Not sure how
the tool could do that.

>> My understanding of the patch is that it does not change the user interface,
>> it changes the way callchains are gathered by the kernel on HSW.
>
> I was under the impression it did change, but that shows how well the
> Changelog explained things I suppose :/
>
With the current patches (or the latest version I looked at), there was no
way to request explicitly LBR mode. It was automatic if CALLCHAIN +
user mode only sampling.

>> Is there explicit mention in the API that CALLCHAIN is relying on FP?
>
> Don't think so. Although I would much prefer if it uses a single method
> per arch across both kernel and user space. For x86 that is FP (since
> that's the only method available to the kernel).
>
I tend to agree here. The problem with FP is that it is not easy to figure
out how a binary has been compiled. Getting valid FP callchains for
large binaries using lots of shared libraries is very challenging. All
libraries must be compiled with FP. It is not easy to test if FP was
compiled in. There is no ELF header flag for this. Need to inspect
the x86 asm and look at function prologues.

This is where LBR has an advantage, it works regardless of how
a binaries and shared libs have been compiled. That is why this is
a good (or some would say better) approach which is using hardware
assist.

>> I think in general it would be better for tools to know which
>> low-level mechanism is used to better interpret the results and
>> especially be aware of the limitations of each mechanism.
>
> Agreed.
>
>> I think the patch is trying some auto-promotion of CALLCHAIN to FP
>> based on the belief it is better in most cases.
>
> We're all more familiar with FP, and it doesn't have the obvious problem
> if only 16 entries. I've worked on quite a bit of software that had much
> deeper callchains -- yay for recursive algorithms and/or C++.
>
Yes, this is true too. But it is not so clear to me if people really care about
top of callchains that much. I think usually 2-6 would probably yield enough
useful info.

LBR callstack fails for leaf function optimization. Where the callee does
not return to its caller but instead to the caller's caller. That is the one
case I know about. There are others I believe.

> With a bit of care FP can be 'perfect', although Andi likes to point out
> that glibc isn't and often wrecks FP :-(
>
Especially any hand-crafted assembly...

>> It reminds me of the discussion about precise mode. Why not default to
>> precise for all events that support it?
>
> I've no idea where that discussion stranded.
>
>> I would be okay if the patch was introducing the 3rd mode for callchains.
>
> Right, I would prefer that (as should be clear by now), this would allow
> running with two (or even all three) and compare results.

I don't think it would be very hard to modify the patch set to make that 3rd
mode visible. Just need to make that new PERF_RECORD_* type visible
to user and modify the compatibility checks.
