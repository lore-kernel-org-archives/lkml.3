Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaKYTim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:38:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaKYTij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:38:39 -0500
Date: Tue, 25 Nov 2014 16:38:21 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/11] perf stat: Use perf_evsel__read_cb in read_counter
Message-ID: <20141125183821.GD2442@redhat.com>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
 <1416562275-12404-5-git-send-email-jolsa@kernel.org>
 <20141124203533.GB12236@redhat.com>
 <20141125093633.GC30861@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125093633.GC30861@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 25, 2014 at 10:36:33AM +0100, Jiri Olsa escreveu:
> On Mon, Nov 24, 2014 at 06:35:33PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Nov 21, 2014 at 10:31:08AM +0100, Jiri Olsa escreveu:
> > > Replacing __perf_evsel__read_on_cpu function with perf_evsel__read_cb
> > > function. The read_cb callback will be used later for global aggregation
> > > counter values as well.
> > 
> > But the changeset makes it look like there are no changes made... Can
> > you elaborate here?
> 
> well the patch change the 'read_counter' function to use the
> perf_evsel__read_cb instead of __perf_evsel__read_on_cpu

That part is ok with me, matches what the subject states it does. The
part I thought was out of place is the SNIP part ;-)
 
> SNIP

This one:


> +static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
> +                struct perf_counts_values *count)
> +{
> +     switch (aggr_mode) {
> +     case AGGR_CORE:
> +     case AGGR_SOCKET:
> +     case AGGR_NONE:
> +             perf_evsel__compute_deltas(evsel, cpu, count);
> +             perf_counts_values__scale(count, scale, NULL);
> +             evsel->counts->cpu[cpu] = *count;
> +             update_shadow_stats(evsel, count->values);
> +             break;
> +     case AGGR_GLOBAL:
> +     default:
> +             break;
> +     }
> +
> +     return 0;

While the original code did a update_shadow_stats(...), the code that replaces
it calls perf_evsel__compute_deltas(), etc in addition to updating the shadow
stats.

Ok, I see, __perf_evsel__read_on_cpu() does that... my bad, will re-read it
with this in mind, but even then, now we have to make sure
perf_evsel__alloc_counts() was called before this, and also the original code
did it for all AGGR_ modes, will check.

- Arnaldo
 
> > > +
> > >  /*
> > >   * Read out the results of a single counter:
> > >   * aggregate counts across CPUs in system-wide mode
> > > @@ -424,16 +444,11 @@ static int read_counter_aggr(struct perf_evsel *counter)
> > >   */
> > >  static int read_counter(struct perf_evsel *counter)
> > >  {
> > > -	u64 *count;
> > >  	int cpu;
> > >  
> > >  	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
> > > -		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
> > > +		if (perf_evsel__read_cb(counter, cpu, 0, read_cb))
> 
> right here ^^^
> 
> > >  			return -1;
> > > -
> > > -		count = counter->counts->cpu[cpu].values;
> > > -
> > > -		update_shadow_stats(counter, count);
> > >  	}
> > >  
> > >  	return 0;
> > > -- 
> > > 1.9.3
