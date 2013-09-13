Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3IMMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:44:00 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51332 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3IMMn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:43:59 -0400
Date: Fri, 13 Sep 2013 14:43:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
Message-ID: <20130913124354.GB4844@somewhere>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
 <20130912203658.GA3216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912203658.GA3216@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:36:58PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > The way we handle hists sorted by comm is to first gather them by tid 
> > then in the end merge/collapse hists that end up with the same comm.
> > 
> > But merging hists has shown some performances issues, especially with 
> > callchain where the operation can be very heavy.
> > 
> > So this new comm infrastructure aims at removing comm collapses. It 
> > brings two features:
> > 
> > 1) Keep track of comms lifecycle by storing timestamps when the comms 
> > are set. This way we can map the precise comm to any thread:time couple. 
> > This only works if the PERF_SAMPLE_ID comes along comm and fork events, 
> > otherwise we only track the latest comm set for a thread.
> > 
> > This can provide us more precise comm sorted hists by distinguishing pre 
> > and post exec timeframes into seperate hists for a single thread.
> > 
> > Note that although the comm infrastructure is ready to do this, I 
> > haven't yet made the perf tools support that. It's a TODO entry.
> > 
> > 2) Allocate comms only once instead of duplicating them for all threads 
> > sharing a same one. Two threads having the same comm should now point to 
> > the same string. As a result we can compare hists thread comm by 
> > address.
> > 
> > The big upside is that we can now live sort comm hists instead of 
> > collapsing them in the end of the processing.
> > 
> > I've seen very nice performance results on perf report. Roughly a 1.5x 
> > to 2x on perf report default stdio output with callchains.
> > 
> > You can try this branch:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> > 	perf/comm
> > 
> > May be merging that with Namhyung callchains patches could provide some
> > cumulative nice results.
> 
> It would be nice to try Linus's testcase, which is, in essence a kernel 
> build profile:
> 
>     make defconfig
>     perf record -g make -j64 bzImage
> 
> and to make sure that it can analyze the data in same, non-annoying 
> runtimes. What I saw was 30 minutes of runtime - a 2x improvement is not 
> nearly enough, 15 minutes is still an eternity.

I doubt we can reach anything near non-annonying runtimes after recording all the callchains
of a whole kernel build perf record.

My patches and Namhyung's should improve the comm situation a lot but we can't
do much miracle. The only way would be perhaps to be able to limit the deepness
of the callchain branches.

Now may be we can find other big contention point in perf. It's possible we also have
some endless loop somewhere.
