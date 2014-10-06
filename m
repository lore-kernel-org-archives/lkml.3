Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJFVWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:22:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:57587 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaJFVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:22:49 -0400
Date: Mon, 6 Oct 2014 18:22:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006212243.GE14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006195349.GE20739@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 06, 2014 at 09:53:49PM +0200, Borislav Petkov escreveu:
> On Mon, Oct 06, 2014 at 04:12:27PM -0300, Arnaldo Carvalho de Melo wrote:
> > Right, and it is being a great exercise, thanks for the patience so far
> > ;-)
> 
> I know, this is your secret agenda to keep me at bay working on this! :-P
> 
> > Looking at those ifdefs we see things that are specific to tools/perf/,
> > like perf_evsel having a struct hists embedded... I.e. that is of no
> > interest whatsoever (so far) to rasd, and in turn pulls other object
> > files.
> > 
> > So I think that right now we need to look at those ifdefs and go on
> > making what is in tools/perf/util/ stop using it somehow, so that what
> > then gets moved to tools/lib/api/perf/ (I guess this is where it should
> > be, opinions?) have that sorted out.

> > I.e. what goes to tools/lib/api/perf/ is what is common to the needs of
> > tools/perf/ and rasd (wherever it may roam).

> > Perhaps something like I did for sock/inet_sock/inet_connection_sock
> > ages ago... I.e. the tools that want a hists will have a 

> > struct hists_evsel {
> > 	struct perf_evsel evsel;
> > 	struct hists	  hists;
> > };

> > etc.

> > Experimenting with that, as it is the only thing ifdefed out in rasd's
> > copy of evsel.h...
 
> Right, this all reads like it is going in the right direction but the
> more important question IMO is are we doing a libperf or are we still
> doing tools/lib/api/perf/ of single object files to which people can
> link?

My preference would be for single object files, but the pressure to have
a written in stone library seems to just build up...
 
> Because if it is the second - and it sounds to me like it is - how do
> you propose we link with external projects? IOW, if I want to have rasd
> build *without* the kernel tree, is a simple
 
> cp -r tools/lib/api/ <my_project>/path/to/perf/lib/
 
> work?

It should, no matter if we end up with a library.

What I'm doing these days to test if perf builds on multiple distros is:

#!/bin/sh
remotebuild() {
	target=$1
	perfpkg=$2
  	cmd="rm -rf ${perfpkg} ; tar xf ${perfpkg}.tar.gz && cd ${perfpkg} && rm -rf /tmp/build/perf ; mkdir -p /tmp/build/perf && make -C tools/perf O=/tmp/build/perf install && make -C tools/perf build-test"
	scp ${perfpkg}.tar.gz gita@${target}:. && \
  	ssh gita@${target} "${cmd}"
}

targets="fedora14 opensuse12.3 fedora19 ubuntu13.10"
perfpkg=perf-3.17.0-rc4

for target in ${targets} ; do
	remotebuild ${target} ${perfpkg}
done

After doing a 'make perf-targz-src-pkg'

I.e. no kernel sources involved on the machines where I build test.

IOW, it is untangled from the kernel sources. As tools/lib/api/ should
as well.

> I mean, I don't know and I'm just asking. Is that the proposed way? Are
> we fine with that? Do we want something different, maybe even a lib? Is
> it time for a lib even?

Well, the rasd experience is serving to show areas where there is
unnecessary entanglement (hists inside perf_event, etc, the ifdefs you
put in place).

I'm working to remove the ones that are in rasd.c, aiming to have a
tools/lib/api/ tree that can be used to build rasd and tools/perf/.

What I don't want to do is to simply straight more
tools/perf/util/evlist.c to tools/lib/api/perf/, some untanglement work
is needed.
 
> Because the whole perf functionality is being cravingly ogled by other
> users - I know Matt wants it for cache QoS or whatever it is called and
> there are probably a whole lot of projects which would like to process
> events programatically in userspace.
> 
> So what I'm saying is, we probably should have a nice clean way
> to be able to share that code with external projects instead of
> external projects duplicating and building a whole library around
> perf_event_open() and the likes...

Agreed, hopefully we'll get that, finally.
 
> Just a couple of thoughts...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
