Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3JJGjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:39:22 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44425 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3JJGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:39:21 -0400
Date: Thu, 10 Oct 2013 08:39:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 50/52] tools/perf/build: Fix O=/some/dir perf.o type of
 targets
Message-ID: <20131010063917.GB10159@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-51-git-send-email-mingo@kernel.org>
 <87fvs9iqfz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fvs9iqfz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:11:20 +0200, Ingo Molnar wrote:
> > If someone specifies a single target, mixed with O=, the following way:
> >
> >     hubble:~/tip/tools/perf> make O=/tmp/perf util/stat.o
> >     BUILD: Doing 'make -j8' parallel build
> >     gcc  -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k [...]
> >
> > The build might even fail, if a target depends on other targets:
> >
> >     hubble:~/tip/tools/perf> make O=/tmp/perf perf.o
> >     ...
> >     perf.c: In function ‘handle_options’:
> >     perf.c:155:21: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
> >
> > The correct way to invoke such targets is:
> >
> >     hubble:~/tip/tools/perf> make O=/tmp/perf /tmp/perf/perf.o
> >     BUILD: Doing 'make -j8' parallel build
> >     GEN /tmp/perf/common-cmds.h
> >     CC /tmp/perf/perf.o
> >
> > But that's unnecessary typing and it's also easy to mistakenly build into the
> > source directory.
> >
> > To fix this remove the generic suffix rules and add redirection to $(OUTPUT)
> > for the most popular .o targets.
> 
> I got this:
> 
>   $ cd tools/perf
>   $ make
>   ... (succeeded)
> 
>   $ make O=~/build/perf perf.o
>   make: `perf.o' is up to date.
> 
>   $ rm ~/build/perf/perf.o
>   $ make O=~/build/perf/ perf.o
>   make: `perf.o' is up to date.

Yes, this is a limitation: it will only do the redirection if the source 
repository is clean.

I don't see a simple solution for that, do you?

> > +util/%.o: $(OUTPUT)util/%.o
> > +	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
> > +bench/%.o: $(OUTPUT)bench/%.o
> > +	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
> > +tests/%.o: $(OUTPUT)tests/%.o
> > +	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
> > +endif
> 
> It also doesn't care about other directories - arch/, scripts/ and ui/ - 
> and their subdirectories.  So even on clean build it'll failed to build 
> these files with O=dir.

Correct - only tried to cover the most common cases. Could add all the 
other directories if this is something people would like to use on a 
regular basis.

I also attempted to do a generic rule that can see into subdirectories, 
using secondary expansion rules, but my first few attempts failed at 
producing anything usable ;-) My Make fu still needs working on. 
Suggestions welcome!

Thanks,

	Ingo
