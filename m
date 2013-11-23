Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3KWNEl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 08:04:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57429 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab3KWNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 08:04:39 -0500
Date: Sat, 23 Nov 2013 14:04:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131123130433.GA24148@pd.tnic>
References: <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
 <20131122153910.GA15636@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131122153910.GA15636@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 04:39:11PM +0100, Ingo Molnar wrote:
> I see no problem with that - it's basically like util/*.c is, just
> between tools.

But why? Why it is a good thing to have to pay attention to linking to
10 minilibs when you're using 10 utilities for your tool instead of a
small number of topic libraries, 2-3 tops?

What's wrong with the split:

* generic stuff
* trace events
* perf events

?

With "generic stuff" being something like glibc. There's hardly a tool
that needs/links to *all* of glibs's functionality yet glibs doesn't get
split. Do you see what I mean?

> What dependencies do you mean? The only constraint is to not make
> it circular - but that's easy to do if they are nicely separated
> per concept. I don't think rbtree.h ever wants to include cmdline
> processing or debugfs processing.

But if you have a single .a library, you don't care about which
minilibrary to link to what. You basically do take libkapi.a and you're
good to go - no need to hunt every dependency.

With the split above, for example, libkapi.a links to glibc only.
libtraceevent.a and libperfevent.a both link to libkapi.a and glibc. It
is all nice and clean.

If later we decide to carve out certain generic functionality from
libkapi.a, then we do that then instead of doing the splitting now when
we don't exactly know what's going to grow in which direction in the
future...

> For userspace and for kernel space subsystems a single .h file per
> separate concept works the best. That is why we have a separate
> rbtree.h, list.h, slab.h, etc.

That doesn't change - if you've looked at my split diffstat, the headers
remain:

"This is tools/lib/lk/liblk.a which contains only compilation units which
contain generic code. The idea behind this library is to be used by all
tools in tools/.

 tools/{perf/util => lib/lk}/color.c                |   69 +-
 tools/{perf/util => lib/lk}/color.h                |   34 +-
 tools/{perf/util => lib/lk}/cpumap.c               |    9 +-
 tools/{perf/util => lib/lk}/cpumap.h               |    4 +
 tools/{perf/util => lib/lk}/ctype.c                |    2 +-
 tools/{perf/util => lib/lk}/hweight.c              |    1 +
 tools/{perf/util => lib/lk}/include/linux/magic.h  |    0
 tools/{perf/util => lib/lk}/parse-options.c        |    6 +-
 tools/{perf/util => lib/lk}/parse-options.h        |   13 +-
 tools/{perf/util => lib/lk}/rblist.c               |    0
 tools/{perf/util => lib/lk}/rblist.h               |    6 +-
 tools/{perf/util => lib/lk}/strbuf.c               |    3 +-
 tools/{perf/util => lib/lk}/strbuf.h               |   15 +-
 tools/{perf/util => lib/lk}/string.c               |   42 +-
 tools/{perf/util => lib/lk}/strlist.c              |    0
 tools/{perf/util => lib/lk}/strlist.h              |    6 +-
 tools/{perf/util => lib/lk}/sysfs.c                |    4 +
 tools/{perf/util => lib/lk}/thread_map.c           |    0
 tools/{perf/util => lib/lk}/thread_map.h           |    6 +-
 tools/{perf/util => lib/lk}/types.h                |    6 +-
 tools/{perf/util => lib/lk}/usage.c                |    2 +-
 tools/{perf/util => lib/lk}/wrapper.c              |    3 +-
 tools/{perf/util => lib/lk}/xyarray.c              |    0
 tools/{perf/util => lib/lk}/xyarray.h              |    6 +-
 tools/lib/lk/Makefile                              |   62 +-
 tools/lib/lk/config.c                              |  370 ++++++
 tools/lib/lk/config.h                              |   13 +
 tools/lib/lk/ctype.h                               |   37 +
 tools/lib/lk/hweight.h                             |   13 +
 tools/lib/lk/string.h                              |   21 +
 tools/lib/lk/sysfs.h                               |   12 +
 tools/lib/lk/usage.h                               |   34 +
 tools/lib/lk/util.c                                |   18 +
 tools/lib/lk/util.h                                |   38 +
 tools/lib/lk/wrapper.h                             |   27 +
"

> > And, since we're keeping it internal, we can do the split the other 
> > way around instead - first do the single generic library and then 
> > carve out a certain subset of functionality if/when it makes sense.
> 
> Why?

Because it is the only thing that makes sense to me. What I don't
understand is why we need (actually I will have to do it :-\) to
split the generic util/* parts into so many small .a libs? I fail to
understand the reason.

Why isn't better to have a single libkapi.a containing the files above
than having multiple smaller ones?

> Hey, that's an important point of agreement! :-)

Oh, I don't disagree - I just fail to see why you guys need this too
granulary splitup instead of three topic libraries. It just doesn't make
sense to me at all from where I'm standing...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
