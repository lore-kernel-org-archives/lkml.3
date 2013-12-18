Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3LROCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:02:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:51269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3LROCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:02:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="446324228"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
In-Reply-To: <20131218133439.GR21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net> <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 18 Dec 2013 16:01:04 +0200
Message-ID: <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Dec 18, 2013 at 03:23:41PM +0200, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Wed, Dec 11, 2013 at 02:36:16PM +0200, Alexander Shishkin wrote:
>> >> Instruction tracing PMUs are capable of recording a log of instruction
>> >> execution flow on a cpu core, which can be useful for profiling and crash
>> >> analysis. This patch adds itrace infrastructure for perf events and the
>> >> rest of the kernel to use.
>> >> 
>> >> Since such PMUs can produce copious amounts of trace data, it may be
>> >> impractical to process it inside the kernel in real time, but instead export
>> >> raw trace streams to userspace for subsequent analysis. Thus, itrace PMUs
>> >> may export their trace buffers, which can be mmap()ed to userspace from a
>> >> perf event fd with a PERF_EVENT_ITRACE_OFFSET offset. To that end, perf
>> >> is extended to work with multiple ring buffers per event, reusing the
>> >> ring_buffer code in an attempt to reduce complexity.
>> >
>> > Please read the thread here: https://lkml.org/lkml/2008/12/4/64
>> >
>> > On my thoughts of this creative mmap() usage.
>> 
>> That's unfortunate, it made sense to me. But let's then have a look at
>> the alternative approaches. Bearing in mind that it is crucial for us to
>> export trace buffers to userspace as opposed to processing the trace
>> data in the kernel, the fact that we still need the normal perf data
>> stream and your dislike for mmap trickery, we need two separate file
>> descriptors: one for the perf data and one for the trace data.
>
> Why don't you start by explaining _why_ you need a second stream to
> begin with?

Oh, I'm sure I've explained it earlier ([1], [2]), but why not. The data
in the second stream is generated at a rate which is hundreds of
megabytes per second per core. Decoding this data is ~1000 times slower
than generating it. Ergo, can't be done in kernel, needs to be exported
as-is to userspace for later retreival and decoding. Doing it via perf
stream means an extra copy, which at these rates is a waste. Ergo, a
second buffer.

[1] https://lkml.org/lkml/2013/12/11/213
[2] https://lkml.org/lkml/2013/12/11/358

Regards,
--
Alex
