Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaKEK5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:57:12 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57353 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaKEK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:57:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141105104359.GP3337@twins.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
	<1415156173-10035-14-git-send-email-kan.liang@intel.com>
	<20141105092145.GP10501@worktop.programming.kicks-ass.net>
	<CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
	<20141105104359.GP3337@twins.programming.kicks-ass.net>
Date: Wed, 5 Nov 2014 11:57:10 +0100
Message-ID: <CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
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

On Wed, Nov 5, 2014 at 11:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Nov 05, 2014 at 10:58:28AM +0100, Stephane Eranian wrote:
>> On Wed, Nov 5, 2014 at 10:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, Nov 04, 2014 at 09:56:09PM -0500, Kan Liang wrote:
>> >> From: Yan, Zheng <zheng.z.yan@intel.com>
>> >>
>> >> Only enable LBR callstack when user requires fp callgraph. The feature
>> >> is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
>> >> is required.
>> >> Also, this feature only affects how to get user callchain. The kernel
>> >> callchain is always got by frame pointers.
>> >
>> > Since FP callchains should not change, this doesn't appear to make any
>> > sense either.
>>
>> If I recall earlier discussion, the FP callchain are not changed. On
>> HSW, when requesting fp at the user level only, then the kernel
>> automatically tries to use the LBR callstack mode.  Advantage is that
>> the user app does not require frame-pointer or dwarf debug info to get
>> correct callchains with perf record. The downside is that LBR
>> callstack does not work in certain callchain corner cases.
>
> But this patch changes the FP callchain interface. I see no need of
> that. We already have multiple independent callchain options (FP and
> Dwarf) adding a third option should also be independent (LBR).
>
> Allowing all 3 at the same time allows for identifying those corner
> cases.
>
> That is I simply don't see a good reason intertwine these things at the
> interface level. All it does is reduce options. Would it not be 'nice'
> to allow both FP and LBR at the same time?

Yes, but I wonder how would the tool sort this out if you have FP and LBR
for each sample.

My understanding of the patch is that it does not change the user interface,
it changes the way callchains are gathered by the kernel on HSW.

Is there explicit mention in the API that CALLCHAIN is relying on FP?

I think in general it would be better for tools to know which
low-level mechanism
is used to better interpret the results and especially be aware of the
limitations of
each mechanism.

I think the patch is trying some auto-promotion of CALLCHAIN to FP based
on the belief it is better in most cases. It reminds me of the discussion about
precise mode. Why not default to precise for all events that support it?

I would be okay if the patch was introducing the 3rd mode for callchains.
