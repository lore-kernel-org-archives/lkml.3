Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3KAM6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:58:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3KAM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:58:14 -0400
Date: Fri, 1 Nov 2013 13:57:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 08/14] perf report: Cache cumulative callchains
Message-ID: <20131101125756.GF10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-9-git-send-email-namhyung@kernel.org>
 <20131101122942.GD10041@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101122942.GD10041@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 01:29:42PM +0100, Jiri Olsa wrote:
> On Thu, Oct 31, 2013 at 03:56:10PM +0900, Namhyung Kim wrote:
> 
> SNIP
> 
> >  	 * double accounting.
> > @@ -501,8 +528,29 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
> >  {
> >  	struct perf_evsel *evsel = iter->evsel;
> >  	struct perf_sample *sample = iter->sample;
> > +	struct cumulative_cache *ccache = iter->priv;
> >  	struct hist_entry *he;
> >  	int err = 0;
> > +	int i;
> > +
> > +	/*
> > +	 * Check if there's duplicate entries in the callchain.
> > +	 * It's possible that it has cycles or recursive calls.
> > +	 */
> > +	for (i = 0; i < iter->curr; i++) {
> > +		if (sort__has_sym) {
> > +			if (ccache[i].sym == al->sym)
> > +				return 0;
> > +		} else {
> > +			/* Not much we can do - just compare the dso. */
> > +			if (ccache[i].dso == al->map->dso)
> > +				return 0;
> > +		}
> > +	}
> 
> hum, do we want to prevent recursion totaly?
> how about intended recursion?

ugh... just managed to read the whole patch,
please forget above comment ;-)

> 
> also should the dso be checked together with sym?
> because the symbol is defined like dso::sym
> 
> jirka
