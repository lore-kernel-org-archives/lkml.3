Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3ILUhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:37:05 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42801 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab3ILUhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:37:02 -0400
Date: Thu, 12 Sep 2013 22:36:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
Message-ID: <20130912203658.GA3216@gmail.com>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The way we handle hists sorted by comm is to first gather them by tid 
> then in the end merge/collapse hists that end up with the same comm.
> 
> But merging hists has shown some performances issues, especially with 
> callchain where the operation can be very heavy.
> 
> So this new comm infrastructure aims at removing comm collapses. It 
> brings two features:
> 
> 1) Keep track of comms lifecycle by storing timestamps when the comms 
> are set. This way we can map the precise comm to any thread:time couple. 
> This only works if the PERF_SAMPLE_ID comes along comm and fork events, 
> otherwise we only track the latest comm set for a thread.
> 
> This can provide us more precise comm sorted hists by distinguishing pre 
> and post exec timeframes into seperate hists for a single thread.
> 
> Note that although the comm infrastructure is ready to do this, I 
> haven't yet made the perf tools support that. It's a TODO entry.
> 
> 2) Allocate comms only once instead of duplicating them for all threads 
> sharing a same one. Two threads having the same comm should now point to 
> the same string. As a result we can compare hists thread comm by 
> address.
> 
> The big upside is that we can now live sort comm hists instead of 
> collapsing them in the end of the processing.
> 
> I've seen very nice performance results on perf report. Roughly a 1.5x 
> to 2x on perf report default stdio output with callchains.
> 
> You can try this branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	perf/comm
> 
> May be merging that with Namhyung callchains patches could provide some
> cumulative nice results.

It would be nice to try Linus's testcase, which is, in essence a kernel 
build profile:

    make defconfig
    perf record -g make -j64 bzImage

and to make sure that it can analyze the data in same, non-annoying 
runtimes. What I saw was 30 minutes of runtime - a 2x improvement is not 
nearly enough, 15 minutes is still an eternity.

Thanks,

	Ingo
