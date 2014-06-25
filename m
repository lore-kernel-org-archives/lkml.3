Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaFYVSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:18:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:49409 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbaFYVSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:18:03 -0400
Date: Wed, 25 Jun 2014 18:17:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140625211757.GD18773@kernel.org>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140625203836.GD13845@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 25, 2014 at 10:38:36PM +0200, Borislav Petkov escreveu:
> On Wed, Jun 25, 2014 at 09:25:47PM +0200, Jiri Olsa wrote:
> > heya,
> > got following error;
> > 
> > [jolsa@krava perf]$ make
> >   BUILD:   Doing 'make -j4' parallel build
> >   CC       util/pmu.o
> >   CC       util/parse-events-flex.o
> >   SUBDIR   /home/jolsa/kernel.org/linux-perf/tools/lib/traceevent/
> > util/pmu.c: In function ‘wordwrap’:
> > util/pmu.c:788:3: error: implicit declaration of function ‘isspace’ [-Werror=implicit-function-declaration]
> >    while (isspace(*s))
> >    ^
> > cc1: all warnings being treated as errors
> > make[1]: *** [util/pmu.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [all] Error 2
> 
> This is a perfect example why doing this piecewise is the only way to
> go! And even that is not easy:

Yeah, and albeit it can take time, its how it would be done if this was
touching core kernel code, right? So lets try to do it that way ;-)
 
> I don't have this line in util/pmu.c:788 so I can't trigger it:
> 
>    782  bool pmu_have_event(const char *pname, const char *name)
>    783  {
>    784          struct perf_pmu *pmu;
>    785          struct perf_pmu_alias *alias;
>    786  
>    787          pmu = NULL;
>    788          while ((pmu = perf_pmu__scan(pmu)) != NULL) {
>    789                  if (strcmp(pname, pmu->name))
>    790                          continue;
>    791                  list_for_each_entry(alias, &pmu->aliases, list)
>    792                          if (!strcmp(alias->name, name))
>    793                                  return true;
>    794          }
>    795          return false;
>    796  }
> 
> So, I've done the patch ontop of those branches:
> 
> commit 279a8cc64fada4b0e7ebf4e4631d67c8ca715f27
> Merge: 9724066c49ba 1545d8aca9ac
> Author: Borislav Petkov <bp@suse.de>
> Date:   Tue Jun 24 15:45:51 2014 +0200
> 
>     Merge remote-tracking branch 'jolsa/perf/core' into ptool-v0.5
> 
> commit 9724066c49baab314a0c3d3f84ec102cd0f76b86
> Merge: ecdac96899e3 a93f0e551af9
> Author: Borislav Petkov <bp@suse.de>
> Date:   Tue Jun 24 15:45:44 2014 +0200
> 
>     Merge remote-tracking branch 'jolsa/perf/urgent' into ptool-v0.5
> 
> commit a93f0e551af9e194db38bfe16001e17a3a1d189a
> Author: Simon Que <sque@chromium.org>
> Date:   Mon Jun 16 11:32:09 2014 -0700
> 
>     perf symbols: Get kernel start address by symbol name
> 
> by checking out acme/perf/core first.
> 
> So, guys, can we agree on a common branch to apply patches ontop please?

I'd say work on tip/perf/core, if it doesn't apply on mine or jolsa's,
we'll fix it up, right Jiri?

We try not to keep too much stuff queued up, so there should be no
problems 99.9% of the time...

- Arnaldo
