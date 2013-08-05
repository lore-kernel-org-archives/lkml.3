Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3HEQLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:11:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36106 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3HEQLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:11:02 -0400
Date: Mon, 5 Aug 2013 13:10:52 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@google.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] tools, perf: Add support to evsel for enabling
 counters
Message-ID: <20130805161052.GB3228@ghostprotocols.net>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
 <1375490473-1503-3-git-send-email-andi@firstfloor.org>
 <87eha81qzl.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eha81qzl.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 05, 2013 at 05:28:14PM +0900, Namhyung Kim escreveu:
> Hi Andi,
> 
> On Fri,  2 Aug 2013 17:41:10 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Add support for enabling already set up counters by using an
> > ioctl. I share some code with the filter setup.
> >
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  tools/perf/util/evsel.c | 21 ++++++++++++++++++---
> >  tools/perf/util/evsel.h |  1 +
> >  2 files changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > index c9c7494..60e0d84 100644
> > --- a/tools/perf/util/evsel.c
> > +++ b/tools/perf/util/evsel.c
> > @@ -605,16 +605,16 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
> >  	return evsel->fd != NULL ? 0 : -ENOMEM;
> >  }
> >  
> > -int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
> > -			   const char *filter)
> > +static int perf_evsel__run_ioctl(struct perf_evsel *evsel, int ncpus, int nthreads,
> > +			  int ioc,  void *arg)
> >  {
> >  	int cpu, thread;
> >  
> >  	for (cpu = 0; cpu < ncpus; cpu++) {
> >  		for (thread = 0; thread < nthreads; thread++) {
> >  			int fd = FD(evsel, cpu, thread),
> > -			    err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
> >  
> > +			err = ioctl(fd, ioc, arg);
> 
> Looks very strange to have a blank line between variable declarations.
> You'd better separating declarations on the other lines like:
> 
> 			int fd, err;
> 
> 			fd = FD(evsel, cpu, thread);
> 			err = ioctl(fd, ioc, arg);

Preferences :-) I think the best way is:

			int fd = FD(evsel, cpu, thread),
			    err = ioctl(fd, ioc, arg);

As its all short and so uses 2 instead of 4 lines. I'll fix up the
alignment.

> 
> Thanks,
> Namhyung
> 
> 
> >  			if (err)
> >  				return err;
> >  		}
