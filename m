Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3LRNYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:24:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:64418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3LRNYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:24:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="454222468"
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
In-Reply-To: <20131217161126.GL13532@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 18 Dec 2013 15:23:41 +0200
Message-ID: <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Dec 11, 2013 at 02:36:16PM +0200, Alexander Shishkin wrote:
>> Instruction tracing PMUs are capable of recording a log of instruction
>> execution flow on a cpu core, which can be useful for profiling and crash
>> analysis. This patch adds itrace infrastructure for perf events and the
>> rest of the kernel to use.
>> 
>> Since such PMUs can produce copious amounts of trace data, it may be
>> impractical to process it inside the kernel in real time, but instead export
>> raw trace streams to userspace for subsequent analysis. Thus, itrace PMUs
>> may export their trace buffers, which can be mmap()ed to userspace from a
>> perf event fd with a PERF_EVENT_ITRACE_OFFSET offset. To that end, perf
>> is extended to work with multiple ring buffers per event, reusing the
>> ring_buffer code in an attempt to reduce complexity.
>
> Please read the thread here: https://lkml.org/lkml/2008/12/4/64
>
> On my thoughts of this creative mmap() usage.

That's unfortunate, it made sense to me. But let's then have a look at
the alternative approaches. Bearing in mind that it is crucial for us to
export trace buffers to userspace as opposed to processing the trace
data in the kernel, the fact that we still need the normal perf data
stream and your dislike for mmap trickery, we need two separate file
descriptors: one for the perf data and one for the trace data.

One way of doing this would be to call sys_perf_event_open() once for
each. The first call would return a file descriptor, which provides good
old perf data buffer; the second call would use this file descriptor for
a group leader and will return another descriptor (thus creating another
perf_event), which, when mmap()ed, will provide a trace buffer.

Or, we could introduce a new PERF_FLAG_XXX to mean that we want a
descriptor with a trace buffer. And then, of course, one could always
add an ioctl(), but that'd probably be a bit over the top.

Do any of these sound reasonable? Any other possibilities that I'm
missing here?

Thanks,
--
Alex
