Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3IMGch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:32:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49138 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3IMGcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:32:35 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-6c-5232b182c20e
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
Date: Fri, 13 Sep 2013 15:32:34 +0900
In-Reply-To: <1379017783-27032-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Thu, 12 Sep 2013 22:29:39 +0200")
Message-ID: <87y571qlj1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Thu, 12 Sep 2013 22:29:39 +0200, Frederic Weisbecker wrote:
> The way we handle hists sorted by comm is to first gather them by tid then
> in the end merge/collapse hists that end up with the same comm.
>
> But merging hists has shown some performances issues, especially with callchain
> where the operation can be very heavy.
>
> So this new comm infrastructure aims at removing comm collapses. It brings
> two features:
>
> 1) Keep track of comms lifecycle by storing timestamps when the comms
> are set. This way we can map the precise comm to any thread:time couple.
> This only works if the PERF_SAMPLE_ID comes along comm and fork events,
> otherwise we only track the latest comm set for a thread.
>
> This can provide us more precise comm sorted hists by distinguishing pre and
> post exec timeframes into seperate hists for a single thread.
>
> Note that although the comm infrastructure is ready to do this, I haven't
> yet made the perf tools support that. It's a TODO entry.
>
>
> 2) Allocate comms only once instead of duplicating them for all threads sharing
> a same one. Two threads having the same comm should now point to the same string.
> As a result we can compare hists thread comm by address.
>
> The big upside is that we can now live sort comm hists instead of collapsing
> them in the end of the processing.
>
> I've seen very nice performance results on perf report. Roughly a 1.5x to 2x
> on perf report default stdio output with callchains.
>
> You can try this branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	perf/comm
>
> May be merging that with Namhyung callchains patches could provide some
> cumulative nice results.

I got this:

ui/browsers/hists.c: In function ‘hists__browser_title’:
ui/browsers/hists.c:1258:10: error: passing argument 1 of ‘thread__comm_curr’ discards ‘const’ qualifier from pointer target type [-Werror]
In file included from ui/browsers/../../util/sort.h:24:0,
                 from ui/browsers/hists.c:11:
ui/browsers/../../util/thread.h:39:13: note: expected ‘struct thread *’ but argument is of type ‘const struct thread *’
ui/browsers/hists.c: In function ‘perf_evsel__hists_browse’:
ui/browsers/hists.c:1581:9: error: passing argument 1 of ‘thread__comm_curr’ discards ‘const’ qualifier from pointer target type [-Werror]
In file included from ui/browsers/../../util/sort.h:24:0,
                 from ui/browsers/hists.c:11:
ui/browsers/../../util/thread.h:39:13: note: expected ‘struct thread *’ but argument is of type ‘const struct thread *’
ui/browsers/hists.c:1704:10: error: passing argument 1 of ‘thread__comm_curr’ discards ‘const’ qualifier from pointer target type [-Werror]
In file included from ui/browsers/../../util/sort.h:24:0,
                 from ui/browsers/hists.c:11:
ui/browsers/../../util/thread.h:39:13: note: expected ‘struct thread *’ but argument is of type ‘const struct thread *’
cc1: all warnings being treated as errors
make: *** [ui/browsers/hists.o] Error 1
make: *** Waiting for unfinished jobs....

Thanks,
Namhyung
