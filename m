Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbbAGHA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:00:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36386 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbAGHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:00:57 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 15:58:49 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
Message-ID: <20150107065849.GB849@sejong>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <20150105184811.GQ2915@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150105184811.GQ2915@two.firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, Jan 05, 2015 at 07:48:11PM +0100, Andi Kleen wrote:
> 
> Thanks for working on this. Haven't read any code, just
> some high level comments on the design.

Really appreciate it!


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

The files are located in a directory and users only deal with the
directory so I don't think it's a big problem.  In addition, moving
data between different systems requires archiving related debuginfos
and I think we can extend perf-archive to put those debuginfo in the
data directory so that it can find the symbols more easily.


> 
> Also I thought Adrian's meta data index already addressed this
> at least partially.

I know Adrian's work might have some common parts but I haven't looked
at it deeply, sorry!  It'd be great if we can discuss how to
coordinate the future direction or something..


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

Right, many mmap events won't be used but we cannot predict which one
is used or not.


> > 
> > With that being done, the stage 2 can be done by multiple threads.  I
> > also save each sample data (per-cpu or per-thread) in separate files
> > during record.  On perf report time, each file will be processed by
> > each thread.  And symbol loading is protected by a mutex lock.
> 
> I really don't like the multiple files. See above. Also it could easily
> cause additional seeking on spinning disks.

Right, I admit that my result ran on a SSD disk.


> 
> Isn't it fast enough to have a single thread that pre scans
> the events (perhaps with some single-thread optimizations
> like vectorization), and then load balances the work to
> a thread pool?

I don't understand it.  Could you please elaborate it?


> 
> BTW I suspect if you used cilk plus or a similar library that
> would make the code much simpler.

I'm not sure how much code I can make simpler with the help of such
library.  I think most changes in this patchset is preparations to
concurrent access in libperf and it's still needed even if the library
is used anyway.

Thanks,
Namhyung


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
> >  		   ----------  -------------  -------------------
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
