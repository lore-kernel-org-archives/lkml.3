Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbbAFPut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:50:49 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36073 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbAFPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <20150105184811.GQ2915@two.firstfloor.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
	<20150105184811.GQ2915@two.firstfloor.org>
Date: Tue, 6 Jan 2015 10:50:44 -0500
Message-ID: <CABPqkBQ_mcMr=mfaFoECm6YFWvgz3JWudQ4wdT2Q61yJZOok1w@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:48 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>
> Thanks for working on this. Haven't read any code, just
> some high level comments on the design.
> >
> > So my approach is like this:
> >
> > Partially do stage 1 first - but only for meta events that changes
> > machine state.  To do this I add a dummy tracking event to perf record
> > and make it collect such meta events only.  They are saved in a
> > separate file (perf.header) and processed before sample events at perf
> > report time.
>
> Can't you just use seek to put the offset into the perf.data header
> like it's already done for other sections? Managing another file would be
> a big change for users and especially is a problem if the data
> is moved between different systems.
>
> Also I thought Adrian's meta data index already addressed this
> at least partially.
>
> >
> > This also requires to handle multiple files and to find a
> > corresponding machine state when processing samples.  On a large
> > profiling session, many tasks were created and exited so pid might be
> > recycled (even more than once!).  To deal with it, I managed to have
> > thread, map_groups and comm in time sorted.  The only remaining thing
> > is symbol loading as it's done lazily when sample requires it.
>
> FWIW there's often a lot of unnecessary information in this
> (e.g. mmaps that are not used). The Quipper page
> claims large saving in data files by avoided redundancies.
>
> It would be probably better if perf record avoided writing redundant
> information better (I realize that's not easy)
> >
> > With that being done, the stage 2 can be done by multiple threads.  I
> > also save each sample data (per-cpu or per-thread) in separate files
> > during record.  On perf report time, each file will be processed by
> > each thread.  And symbol loading is protected by a mutex lock.
>
> I really don't like the multiple files. See above. Also it could easily
> cause additional seeking on spinning disks.
>
having to manage two separate files is a major change which I don't
particularly like. It will cause problems. I don't see why this cannot
be appended to the perf.data file with a index at the beginning. There
is already an index for sections in file mode.

We use the pipe mode a lot and this would not work there. So no,
I don't like the 2 files solution. But I like the idea of using multiple
threads to speed up processing.

>
> Isn't it fast enough to have a single thread that pre scans
> the events (perhaps with some single-thread optimizations
> like vectorization), and then load balances the work to
> a thread pool?
>
> BTW I suspect if you used cilk plus or a similar library that
> would make the code much simpler.
>
> > Here is the result:
> >
> > This is just elapsed (real) time measured by shell 'time' function.
> >
> > The data file was recorded during kernel build with fp callchain and
> > size is 2.1GB.  The machine has 6 core with hyper-threading enabled
> > and I got a similar result on my laptop too.
> >
> >  time perf report  --children  --no-children  + --call-graph none
> >                  ----------  -------------  -------------------
> >  current            4m43.260s      1m32.779s            0m35.866s
> >  patched            4m43.710s      1m29.695s            0m33.995s
> >  --multi-thread     2m46.265s      0m45.486s             0m7.570s
> >
> >
> > This result is with 7.7GB data file using libunwind for callchain.
>
> Nice results!
>
> -Andi
