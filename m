Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3K0Pj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:39:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58561 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252Ab3K0Pjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:39:52 -0500
Date: Wed, 27 Nov 2013 16:39:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131127153944.GI32267@pd.tnic>
References: <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
 <20131122153910.GA15636@gmail.com>
 <20131123130433.GA24148@pd.tnic>
 <20131126181745.GD9958@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131126181745.GD9958@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 07:17:45PM +0100, Ingo Molnar wrote:
> It's a single line added to the Makefile, the moment a .h is used for
> the first time. That's not any appreciable overhead.

Hmm, not quite. It is a bit more jumping through hoops - look at the
variables LK_DIR, LK_PATH and LIBLK for what we're doing right now to
include the library and to enable all the different ways of building
perf.

And we're doing the same for libtraceevent.a too so it has its own set
of variables.

> This would also allow us to farm out most of tools/perf/util/ into
> tools/lib/...

That's the idea. :)

> Well, the natural evolution of interfaces ended up with such a split 
> up:
> 
> comet:~/tip/tools/perf> ls util/*.h
> util/annotate.h   util/hist.h           util/strbuf.h
> util/build-id.h   util/intlist.h        util/strfilter.h
> util/cache.h      util/levenshtein.h    util/strlist.h
> util/callchain.h  util/machine.h        util/svghelper.h
> util/cgroup.h     util/map.h            util/symbol.h
> util/color.h      util/parse-events.h   util/target.h
> util/comm.h       util/parse-options.h  util/thread.h
> util/cpumap.h     util/perf_regs.h      util/thread_map.h
> util/data.h       util/pmu.h            util/tool.h
> util/debug.h      util/probe-event.h    util/top.h
> util/dso.h        util/probe-finder.h   util/trace-event.h
> util/dwarf-aux.h  util/pstack.h         util/types.h
> util/event.h      util/quote.h          util/unwind.h
> util/evlist.h     util/rblist.h         util/util.h
> util/evsel.h      util/run-command.h    util/values.h
> util/exec_cmd.h   util/session.h        util/vdso.h
> util/fs.h         util/sigchain.h       util/xyarray.h
> util/header.h     util/sort.h
> util/help.h       util/stat.h
> 
> If we want additional structure to it then it should be done via the 
> namespace, not by forcing them into bigger .a's. So this kind of extra 
> structure makes sense:
> 
>   api/types/rbtree.h
>   api/types/strbuf.h
>   api/formats/dwarf/unwind.h
>   api/kernel/pmu.h
>   api/kernel/cgroup.h
>   api/kernel/debugfs.h

Ok, splitting them into topics actually makes sense.

> But stuffing them into types.a, formats.a, kernel.a, not so much.

Huh, why not? We take the corresponding .c files and create a single .a
archive per topic from them. This makes a whole lot of sense to me as a
compromise between having a single .a and one .a per compilation unit.

Remember, we still need to do the game with the *LK* variables above
with each new lib and path.

> You still need to figure out the .h file - at that point, when you are
> using it for the first time in your tool project, you add the .c file
> to the Makefile - it's not hard and there are real advantages.

See above.

> It does not look that nice and clean once I consider all the nice
> helpers that exist in util/*.[ch] - and which we'd like to share as
> well.

We will - if not in a single .a at least in a couple of .a's as topic
libraries but please no one .a per a single .c.

For example, it makes a lot of sense to put evsel.* and evlist.* into
one libperfevent.a library which deals solely with handling perf events.

Having libevsel.a and libevlist.a OTOH not so much.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
