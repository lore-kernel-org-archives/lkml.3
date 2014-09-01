Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaIAQbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:31:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaIAQa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:30:59 -0400
Date: Mon, 1 Sep 2014 18:30:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, Pawel.Moll@arm.com, Michael.Williams@arm.com,
        ralf@linux-mips.org
Subject: Re: [PATCH v4 00/22] perf: Add infrastructure and support for Intel
 PT
Message-ID: <20140901163039.GV27892@worktop.ger.corp.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 03:35:57PM +0300, Alexander Shishkin wrote:
> Hi Peter and all,
> 
> This patchset adds support for Intel Processor Trace (PT) extension [1] of
> Intel Architecture that allows the capture of information about software
> execution flow, to the perf kernel infrastructure.
> 
> The single most notable thing is that while PT outputs trace data in a
> compressed binary format, it will still generate hundreds of megabytes
> of trace data per second per core. Decoding this binary stream takes
> 2-3 orders of magnitude the cpu time that it takes to generate
> it. These considerations make it impossible to carry out decoding in
> kernel space. Therefore, the trace data is exported to userspace as a
> zero-copy mapping that userspace can collect and store for later
> decoding. To address this, this patchset extends perf ring buffer with
> an "AUX space", which is allocated for hardware blocks such as PT to
> export their trace data with minimal overhead. This space can be
> configured via buffer's user page and mmapped from the same file
> descriptor with a given offset. Data can then be collected from it
> by reading the aux_head (write) pointer from the user page and updating
> aux_tail (read) pointer similarly to data_{head,tail} of the
> traditional perf buffer. There is an api between perf core and pmu
> drivers that wish to make use of this AUX space to export their data.
> 
> For tracing blocks that don't support hardware scatter-gather tables,
> we provide high-order physically contiguous allocations to minimize
> the overhead needed for software double buffering and PMI pressure.
> 
> This way we get a normal perf data stream that provides sideband
> information that is required to decode the trace data, such as MMAPs,
> COMMs etc, plus the actual trace in its own logical space.
> 
> If the trace buffer is mapped writable, the driver will stop tracing
> when it fills up (aux_head approaches aux_tail), till data is read,
> aux_tail pointer is moved forward and an ioctl() is issued to
> re-enable tracing. If the trace buffer is mapped read only, the
> tracing will continue, overwriting older data, so that the buffer
> always contains the most recent data. Tracing can be stopped with an
> ioctl() and restarted once the data is collected.
> 
> Another use case is annotating samples of other perf events: setting
> PERF_SAMPLE_AUX requests attr.aux_sample_size bytes of trace to be
> included in each event's sample.
> 
> This patchset consists of necessary changes to the perf kernel
> infrastructure, and PT and BTS pmu drivers. The tooling support is not
> included in this series, however, it can be found in my github tree [2].
> 
> This version changes the way watermarks are handled for AUX area and
> gets rid of the notion of "itrace" both in the core and in the perf
> interface (event attribute), which makes it more logical.
> 
> [1] http://software.intel.com/en-us/intel-isa-extensions
> [2] http://github.com/virtuoso/linux-perf/tree/intel_pt

It would also be good if some other archs can comment on this (the
generic parts obviously). There is the ARM CoreSight stuff and ISTR that
MIPS also has something like this, although I'm not entirely sure who to
poke on that, Ralf?
