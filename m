Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaC2JnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:43:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaC2JnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:43:05 -0400
Date: Sat, 29 Mar 2014 10:42:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v3 00/12] perf, persistent: Add persistent events
Message-ID: <20140329094250.GA11987@nazgul.tnic>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <20130824093826.GB28383@pd.tnic>
 <20130827122721.GF15884@rric.localhost>
 <20130827123827.GB5855@x1.alien8.de>
 <CAFrcx1kdVQmNETtUoLJNdtMbzZ4bPSxHq8R-PwOdd=vEu6L9Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFrcx1kdVQmNETtUoLJNdtMbzZ4bPSxHq8R-PwOdd=vEu6L9Zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 03:54:11PM +0100, Jean Pihet wrote:
> Hi,
> 
> Now that the feature is resurfacing, I would like to take over the
> task for persistent events.
> What is the status of the series, is it close to acceptance?
> 
> AFAICS the patch RFC 12/12 was under discussion, mainly about the
> naming of the ioctls (latest e-mail is in favor of CLAIM/UNCLAIM).
> 
> Any thoughts?
> 
> Let me rebase the code against the latest mainline and re-start the discussion.

That's nice, cool. However, before this thing goes upstream, Ingo wanted
to have also a user for the events, i.e. persistent events integrated
in perf tool. For that, perf tool functionality has to be made generic
enough and thus usable for other tools.

I have started doing that but other stuff preempted me, as it happens :(.
Here's how a splitup would look like, from an older email from Ingo. In
any case, this would need further discussion but I think it is a good
start.

I'm willing to help out as time permits and I'd venture a guess that
Robert would do that too, so please CC us your submissions.

Thanks!

--
>From mingo.kernel.org@gmail.com Tue Nov 26 19:17:58 2013
Date: Tue, 26 Nov 2013 19:17:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, LKML
 <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Jiri Olsa
 <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Robert Richter
 <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131126181745.GD9958@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO
X-Status: A


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Nov 22, 2013 at 04:39:11PM +0100, Ingo Molnar wrote:
>
> > I see no problem with that - it's basically like util/*.c is, just 
> > between tools.
> 
> But why? Why it is a good thing to have to pay attention to linking 
> to 10 minilibs when you're using 10 utilities for your tool instead 
> of a small number of topic libraries, 2-3 tops?

It's a single line added to the Makefile, the moment a .h is used for 
the first time. That's not any appreciable overhead.

This would also allow us to farm out most of tools/perf/util/ into 
tools/lib/, without any noticeable changes in build performance or 
build dependencies. Down the line it would (hopefully) result in code 
improvements to these infrastructure bits, sourced from different 
tools.

> What's wrong with the split:
> 
> * generic stuff
> * trace events
> * perf events
> 
> ?

Well, the natural evolution of interfaces ended up with such a split 
up:

comet:~/tip/tools/perf> ls util/*.h
util/annotate.h   util/hist.h           util/strbuf.h
util/build-id.h   util/intlist.h        util/strfilter.h
util/cache.h      util/levenshtein.h    util/strlist.h
util/callchain.h  util/machine.h        util/svghelper.h
util/cgroup.h     util/map.h            util/symbol.h
util/color.h      util/parse-events.h   util/target.h
util/comm.h       util/parse-options.h  util/thread.h
util/cpumap.h     util/perf_regs.h      util/thread_map.h
util/data.h       util/pmu.h            util/tool.h
util/debug.h      util/probe-event.h    util/top.h
util/dso.h        util/probe-finder.h   util/trace-event.h
util/dwarf-aux.h  util/pstack.h         util/types.h
util/event.h      util/quote.h          util/unwind.h
util/evlist.h     util/rblist.h         util/util.h
util/evsel.h      util/run-command.h    util/values.h
util/exec_cmd.h   util/session.h        util/vdso.h
util/fs.h         util/sigchain.h       util/xyarray.h
util/header.h     util/sort.h
util/help.h       util/stat.h

If we want additional structure to it then it should be done via the 
namespace, not by forcing them into bigger .a's. So this kind of extra 
structure makes sense:

  api/types/rbtree.h
  api/types/strbuf.h
  api/formats/dwarf/unwind.h
  api/kernel/pmu.h
  api/kernel/cgroup.h
  api/kernel/debugfs.h

But stuffing them into types.a, formats.a, kernel.a, not so much.

> With "generic stuff" being something like glibc. There's hardly a 
> tool that needs/links to *all* of glibs's functionality yet glibs 
> doesn't get split. Do you see what I mean?

glibc being such a catch-all library is:

 - partly a historic artifact caused by other constraints that don't 
   affect our tooling landscape here

 - partly a political artifact caused by thinking that does not affect 
   our tooling landscape

 - partly a technological mistake.

There's no need for us to repeat that, at least at this stage.

> > What dependencies do you mean? The only constraint is to not make 
> > it circular - but that's easy to do if they are nicely separated 
> > per concept. I don't think rbtree.h ever wants to include cmdline 
> > processing or debugfs processing.
> 
> But if you have a single .a library, you don't care about which 
> minilibrary to link to what. You basically do take libkapi.a and 
> you're good to go - no need to hunt every dependency.

You still need to figure out the .h file - at that point, when you are 
using it for the first time in your tool project, you add the .c file 
to the Makefile - it's not hard and there are real advantages.

> With the split above, for example, libkapi.a links to glibc only. 
> libtraceevent.a and libperfevent.a both link to libkapi.a and glibc. 
> It is all nice and clean.

It does not look that nice and clean once I consider all the nice 
helpers that exist in util/*.[ch] - and which we'd like to share as 
well.

Thanks,

	Ingo
