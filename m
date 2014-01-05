Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaAERPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:15:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaAERPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:15:52 -0500
Date: Sun, 5 Jan 2014 18:15:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 05/21] perf hists: Accumulate hist entry stat based on
 the callchain
Message-ID: <20140105171528.GA12744@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-6-git-send-email-namhyung@kernel.org>
 <20140105165831.GE10018@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105165831.GE10018@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 05:58:31PM +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:11PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Call __hists__add_entry() for each callchain node to get an
> > accumulated stat for an entry.  Introduce new cumulative_iter ops to
> > process them properly.
> > 
> > Cc: Arun Sharma <asharma@fb.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/builtin-report.c | 103 +++++++++++++++++++++++++++++++++++++++++++-
> >  tools/perf/ui/stdio/hist.c  |   2 +-
> >  2 files changed, 103 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 29fe19071d24..4fde0ab82498 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -360,6 +360,97 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
> >  	return hist_entry__append_callchain(he, sample);
> >  }
> >  
> > +static int
> > +iter_prepare_cumulative_entry(struct add_entry_iter *iter,
> > +			      struct machine *machine __maybe_unused,
> > +			      struct perf_evsel *evsel,
> > +			      struct addr_location *al __maybe_unused,
> > +			      struct perf_sample *sample)
> > +{
> > +	callchain_cursor_commit(&callchain_cursor);
> > +
> > +	iter->evsel = evsel;
> > +	iter->sample = sample;
> > +	return 0;
> > +}
> > +
> > +static int
> > +iter_add_single_cumulative_entry(struct add_entry_iter *iter,
> > +				 struct addr_location *al)
> > +{
> > +	struct perf_evsel *evsel = iter->evsel;
> > +	struct perf_sample *sample = iter->sample;
> > +	struct hist_entry *he;
> > +
> > +	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
> > +				sample->period, sample->weight,
> > +				sample->transaction, true);
> > +	if (he == NULL)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * This is for putting parents upward during output resort iff
> > +	 * only a child gets sampled.  See hist_entry__sort_on_period().
> > +	 */
> > +	he->callchain->max_depth = PERF_MAX_STACK_DEPTH + 1;
> 
> so you're using callchain struct to hold the entry's stack
> position for sorting.. I think we could store this info
> inside hist_entry itself, and omit 'struct callchain_root'
> size being allocated for hist_entry
> 
> I checked 'struct hist_entry' and the 'position' entry seems to
> be abandonned ;-)) or we could use some unused entry (mem_info?)
> and create some union.

also perhaps above 5 lines should be part of the later commit:
  perf hists: Sort hist entries by accumulated period

jirka
