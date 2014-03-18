Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaCROHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:07:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:26830 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbaCROHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,678,1389772800"; 
   d="scan'208";a="474899119"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <20140314141043.GF3793@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140217143340.GR27965@twins.programming.kicks-ass.net> <20140218023659.GV12219@tassilo.jf.intel.com> <20140314103832.GQ27965@twins.programming.kicks-ass.net> <20140314141043.GF3793@tassilo.jf.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 18 Mar 2014 16:06:53 +0200
Message-ID: <87ppljsirm.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>> I really don't want the multi-buffer nonsense proposed. 
>
>> An event gets
>> _1_ buffer, that's it.
>
> But we already have multi buffer. Just profile multiple CPUs
> Then you have one buffer per CPU that need to be combined.
>
> This just has two buffers per CPU.

Well, an event still gets *one* *perf* buffer in our implementation,
which is consistent with how things are done now, plus one trace
buffer. We could also export the trace buffer as a device node or
something, so that no software would expect to see perf headers in that
buffer.

>> That also means that if someone redirect another event into this buffer,
>> it needs to just work.
>
> All the tools already handle multiple buffers (for multi CPUs).
> So they don't need it.
>
>> And because its a perf buffer, people expect it to look like one. So
>> we've got 'wrap' it.
>
> Flushing TLBs from NMIs or irq work or any interrupt context is just
> a non starter.
>
> The start/stop hardware and create gigantic gaps was also pretty bad
> and would completely change the perf format too
>
> It seem to me you're trying to solve a non-problem.

Look at it this way: if the only way for it to be part of perf is by
wrapping trace data in perf headers, perf framework is simply not
suitable for instruction tracing. Therefore, it seems logical to have a
standalone driver or, considering ETM/PTM and others, a standalone
framework for exporting instruction trace data to userspace as plain
mmap interface with out the overhead of overwriting userspace ptes,
flushing tlbs, having inconsistent mappings in threads and that would
still work for hardware that doesn't support sg lists.

What do you think?

Regards,
--
Alex
