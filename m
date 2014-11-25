Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaKYJg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:36:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKYJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:36:53 -0500
Date: Tue, 25 Nov 2014 10:36:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/11] perf stat: Use perf_evsel__read_cb in read_counter
Message-ID: <20141125093633.GC30861@krava.brq.redhat.com>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
 <1416562275-12404-5-git-send-email-jolsa@kernel.org>
 <20141124203533.GB12236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124203533.GB12236@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 06:35:33PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 21, 2014 at 10:31:08AM +0100, Jiri Olsa escreveu:
> > Replacing __perf_evsel__read_on_cpu function with perf_evsel__read_cb
> > function. The read_cb callback will be used later for global aggregation
> > counter values as well.
> 
> But the changeset makes it look like there are no changes made... Can
> you elaborate here?

well the patch change the 'read_counter' function to use the
perf_evsel__read_cb instead of __perf_evsel__read_on_cpu

SNIP

> > +
> >  /*
> >   * Read out the results of a single counter:
> >   * aggregate counts across CPUs in system-wide mode
> > @@ -424,16 +444,11 @@ static int read_counter_aggr(struct perf_evsel *counter)
> >   */
> >  static int read_counter(struct perf_evsel *counter)
> >  {
> > -	u64 *count;
> >  	int cpu;
> >  
> >  	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
> > -		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
> > +		if (perf_evsel__read_cb(counter, cpu, 0, read_cb))

right here ^^^

> >  			return -1;
> > -
> > -		count = counter->counts->cpu[cpu].values;
> > -
> > -		update_shadow_stats(counter, count);
> >  	}
> >  
> >  	return 0;
> > -- 
> > 1.9.3
