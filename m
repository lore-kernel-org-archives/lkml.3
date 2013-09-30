Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3I3SDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:03:05 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45109 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3I3SDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:03:02 -0400
Date: Mon, 30 Sep 2013 15:02:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20130930180247.GJ10293@ghostprotocols.net>
References: <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <20130930172741.GD10293@ghostprotocols.net>
 <20130930173052.GE10293@ghostprotocols.net>
 <20130930173627.GF10293@ghostprotocols.net>
 <20130930173914.GG10293@ghostprotocols.net>
 <20130930174639.GH10293@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930174639.GH10293@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 30, 2013 at 02:46:39PM -0300, Arnaldo Carvalho de Melo escreveu:
> I'm testing removing devel packages, one by one, removing gtk2-devel provides
> the biggest reduction in build time, no surprises :)

And this exercise spotted a but:

make[1]: Leaving directory `/home/git/linux/tools/lib/lk'
    GEN /tmp/build/perf/python/perf.so
Context.xs:22:20: fatal error: EXTERN.h: No such file or directory
compilation terminated.
make: *** [/tmp/build/perf/scripts/perl/Perf-Trace-Util/Context.o] Error 1
make: *** Waiting for unfinished jobs....
util/scripting-engines/trace-event-perl.c:29:20: fatal error: EXTERN.h: No such file or directory
compilation terminated.
make: *** [/tmp/build/perf/util/scripting-engines/trace-event-perl.o] Error 1
make: Leaving directory `/home/git/linux/tools/perf'

 Performance counter stats for 'make -j4 -C tools/perf O=/tmp/build/perf' (3 runs):

       6.453914638 seconds time elapsed                                          ( +- 80.66% )

[acme@zoo linux]$ 
[acme@zoo linux]$

I.e. I did a 'yum remove python-devel', that removed some more packages that
require this package, one of them is needed for perf to build, and this is
not stated on those:

config/Makefile:444: No numa.h found, disables 'perf bench numa mem' benchmark,
please install numa-libs-devel or libnuma-dev


In fact this is why I thought those messages had been missing in your
patchset, they don't appear when I remove perl-devel, i.e. 'perl' supporty
is correctly detected as not possible to build due to missing deps, but
no message is emitted for this case.

And the bug is that the feature test for perl support passes, but since it
doesn't try to use EXTERN.h, like something that is enabled when the feature
test passes (util/scripting-engines/trace-event-perl.c), the build fails.

Notebook battery dying, will continue later...

- Arnaldo
