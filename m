Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3LBOin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:43 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43193 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3LBOi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:29 -0500
Subject: Re: [PATCH 3/3] perf report: Add --show-time-info option
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20131202123347.GD2371@ghostprotocols.net>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	 <1385967199-3759-4-git-send-email-namhyung@kernel.org>
	 <20131202123347.GD2371@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Dec 2013 23:38:20 +0900
Message-ID: <1385995100.1710.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

2013-12-02 (월), 09:33 -0300, Arnaldo Carvalho de Melo:
> Em Mon, Dec 02, 2013 at 03:53:19PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The --show-time-info option is for displaying elapsed sampling time
> 
> Isn't that too long? Can't we use just --time/-t?

Hmm.. interesting.  Your previous feedback was to use longer and clearer
option name. :)

https://lkml.org/lkml/2013/11/18/198

> 
> > information for each entry.
> > 
> >   $ perf record -- perf bench sched messaging
> >   $ perf report --stdio --show-time-info
> >   ...
> >   # Samples: 10K of event 'cycles'
> >   # Event count (approx.): 5118793536
> >   # Total sampling time  : 0.184277 (sec)
> >   #
> >   # Overhead        Time          Command      Shared Object                       Symbol
> >   # ........  ..........  ...............  .................  ...........................
> >   #
> >        7.26%    0.007413  sched-messaging  [unknown]          [.] 0x0000003153e7a6e7
> >        4.79%    0.006088  sched-messaging  [kernel.kallsyms]  [k] avc_has_perm_flags
> >        4.38%    0.004809  sched-messaging  [kernel.kallsyms]  [k] copy_user_generic_string
> >        3.81%    0.005457  sched-messaging  [kernel.kallsyms]  [k] _raw_spin_lock
> >        2.92%    0.002745  sched-messaging  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
> >        2.72%    0.002896  sched-messaging  [kernel.kallsyms]  [k] unix_stream_recvmsg
> >        2.55%    0.003745  sched-messaging  [kernel.kallsyms]  [k] __slab_free
> >        2.45%    0.002807  sched-messaging  [kernel.kallsyms]  [k] page_fault
> >        2.08%    0.002258  sched-messaging  [kernel.kallsyms]  [k] sock_has_perm
> > 
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/builtin-report.c |  2 ++
> >  tools/perf/ui/hist.c        | 68 +++++++++++++++++++++++++++++++++++++--------
> >  tools/perf/util/hist.h      |  1 +
> >  tools/perf/util/symbol.h    |  3 +-
> >  4 files changed, 62 insertions(+), 12 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index eb849e9f7093..345cce6f5fa2 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -898,6 +898,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
> >  	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
> >  	OPT_CALLBACK(0, "percent-limit", &report, "percent",
> >  		     "Don't show entries under that percent", parse_percent_limit),
> > +	OPT_BOOLEAN(0, "show-time-info", &symbol_conf.show_time_info,
> > +		    "Show a column with the elapsed time"),
> >  	OPT_END()
> >  	};
> >  	struct perf_data_file file = {
> > diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> > index 78f4c92e9b73..7cf584a0bb61 100644
> > --- a/tools/perf/ui/hist.c
> > +++ b/tools/perf/ui/hist.c
> > @@ -7,19 +7,24 @@
> >  #include "../util/evsel.h"
> >  
> >  /* hist period print (hpp) functions */
> > +enum hpp_fmt_type {
> > +	HPP_FMT__PERCENT,
> > +	HPP_FMT__RAW,
> > +	HPP_FMT__TIME,
> > +};
> 
> I wonder if we can't make this a bitmask... Does it make sense to print
> both percent and time, for instance?

I'm not sure I understood you correctly, but did you mean printing both
percent and time in a single column?  This enum and the __hpp_fmt()
function is for a single column.  I can add a new column for time
percent if you want.

Thanks,
Namhyung


