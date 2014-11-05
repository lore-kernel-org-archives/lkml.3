Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaKEJ6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:58:45 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33918 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141105092145.GP10501@worktop.programming.kicks-ass.net>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
	<1415156173-10035-14-git-send-email-kan.liang@intel.com>
	<20141105092145.GP10501@worktop.programming.kicks-ass.net>
Date: Wed, 5 Nov 2014 10:58:28 +0100
Message-ID: <CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
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

On Wed, Nov 5, 2014 at 10:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Nov 04, 2014 at 09:56:09PM -0500, Kan Liang wrote:
>> From: Yan, Zheng <zheng.z.yan@intel.com>
>>
>> Only enable LBR callstack when user requires fp callgraph. The feature
>> is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
>> is required.
>> Also, this feature only affects how to get user callchain. The kernel
>> callchain is always got by frame pointers.
>
> Since FP callchains should not change, this doesn't appear to make any
> sense either.

If I recall earlier discussion, the FP callchain are not changed. On
HSW, when requesting
fp at the user level only, then the kernel automatically tries to use
the LBR callstack mode.
Advantage is that the user app does not require frame-pointer or dwarf
debug info to get
correct callchains with perf record. The downside is that LBR
callstack does not work in
certain callchain corner cases.

The reason why using LBR call stack mode is restricted to user level
only is because of
a bug in the LBR call stack hardware which forces the kernel to drop
LBR_FREEZE_PMI.
In other words ,the LBR does not stop on counter overflow, thus it
will be wiped out by
execution of kernel code leading to the PMU interrupt handler.
