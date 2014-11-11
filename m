Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaKKNCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:02:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:57999 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaKKNCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:02:36 -0500
Date: Tue, 11 Nov 2014 10:02:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141111130229.GS18464@kernel.org>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard>
 <20141107173718.GD29390@twins.programming.kicks-ass.net>
 <87mw7zva3c.fsf@sejong.aot.lge.com>
 <20141110121105.GL3337@twins.programming.kicks-ass.net>
 <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 11, 2014 at 01:24:38PM +0900, Namhyung Kim escreveu:
> Hi Peter,
> 
> On Mon, Nov 10, 2014 at 9:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Nov 10, 2014 at 03:33:11PM +0900, Namhyung Kim wrote:
> >> Hmm.. I don't think it's specific to the minimal elf parser.  The return
> >> value of dso__load_sym() is a number of symbols found so when it sees a
> >> dso with 0 symbols it'll fall back to the next option IMHO (not
> >> tested).  Did you see a problem with the current code?
> >
> > So your patch:
> >
> > +++ b/tools/perf/util/symbol-minimal.c
> > @@ -335,6 +335,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
> >         unsigned char *build_id[BUILD_ID_SIZE];
> >         int ret;
> >
> > +       if (dso->kernel)
> > +               return 0;  /* always use kallsyms */
> > +
> >
> > changes the symbol-minimal.c file to add this exception. That is very
> > much specific to the minimal elf parser, or am I just seeing things?
> 
> What minimal parser does here is just skip kernel dsos (vmlinux) since
> it didn't deal with all the details of parsing vmlinux currently.
> 
> 
> >
> > What I was saying, why not have a util/symbol.c change that disregards
> > all DSOs with 0 symbols in.
> 
> The util/symbol.c doesn't need this because it can handle vmlinux
> reliably.  So after reading symbol table, it'll use the dso if it

symbol.c should not be able to handle anything, since the actual ELF
loader is in symbol-elf.c or simbol-minimal.c, no?

I.e.:

	symbol.c::dso__load()
		symbol.c::dso__load_kernel_sym()
			symbol.c::dso__load_vmlinux()

And then it heads into one of the ELF loaders, right now, without your
patch, I see, when the minimal loader is used:

		symbol-minimal.c::dso__load_sym()

reads the build-id and if it works, returns 1, which is a bug, it should
return 0 in this case, possibly -1 if it doesn't read the build-id :-\

I.e. it should return 0, because that way it signals: "I can't read it,
thus no symbols were loaded, symbol.c: please go on looking for them
somewhere else, kallsyms perhaps?".

And this is the bug, probably. Now to look at your patches to see if
this is touched somehow...

> actually contains symbols or fallback to next dso if it has 0 symbols.
> IOW it already disregards all dsos with 0 symbols in.

See above.
 
> -- 
> Thanks,
> Namhyung
