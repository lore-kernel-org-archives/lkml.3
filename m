Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FXIn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:43:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3FXIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:43:56 -0400
Date: Mon, 24 Jun 2013 10:43:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130624084338.GI28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:20:40PM +0200, Stephane Eranian wrote:
> This patch series extends perf_events with the ability to sample
> physical data addresses. This is useful with the memory access
> sampling mode added just recently. In particular, it helps
> disambiguate data addresses between two processes, such as
> in the case of a shared memory segment mapped at different
> addresses in different processes.
> 
> The patch adds the PERF_SAMPLE_PHYS_ADDR sample_type.
> A 64-bit address is added to the sample record for
> the corresponding event.
> 
> On Intel X86, it is used with the PEBS Load Latency
> support. On other architectures, zero is returned.
> 
> The patch series also demonstrates the use of this
> new feature by extending perf report, mem, record
> with a --phys-addr option. When enable, it will 
> capture physical data address and display it.
> This is implemented as a new sort_order (symbol_paddr).
> 

So I'm a bit puzzled by this thing...

What exact problem are we trying to solve here? Only the shared memory
mapped at different addresses between processes thing mentioned earlier?

The big problem I see with all this is that typically memory is subject
to being moved about at random; be it either from paging, compaction,
NUMA policies or explicit page migration.

Such would completely shatter physical page relations.

If the shared memory thing is really the issue, doesn't perf already
have the process memory layout (/proc/$PID/maps and aux stream mmap
updates) with which it can compute map relative offsets and compare
thusly?
