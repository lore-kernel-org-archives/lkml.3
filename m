Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaFOR7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaFOR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:59:04 -0400
Date: Sun, 15 Jun 2014 19:58:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 15/17] perf tools: Add debug prints for ordered events
 queue
Message-ID: <20140615175849.GF1159@krava.brq.redhat.com>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
 <1402610913-19059-16-git-send-email-jolsa@kernel.org>
 <1402661543.2178.25.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402661543.2178.25.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:12:23PM +0900, Namhyung Kim wrote:
> 2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> > Adding some prints for ordered events queue, to help
> > debug issues.
> > 
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Jean Pihet <jean.pihet@linaro.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/perf/builtin-report.c      |  4 +++
> >  tools/perf/util/ordered-events.c | 54 ++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/ordered-events.h |  2 ++
> >  3 files changed, 60 insertions(+)
> > 
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 09b9d0c..130ab5c 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -82,6 +82,10 @@ static int report__config(const char *var, const char *value, void *cb)
> >  		rep->queue_size = perf_config_u64(var, value);
> >  		return 0;
> >  	}
> > +	if (!strcmp(var, "report.queue-debug")) {
> > +		debug_sample_queue = perf_config_int(var, value);
> > +		return 0;
> > +	}
> 
> Again, config option only?

same reason as for the previous one

> > +
> > +#define pr_N(n, fmt, ...) \
> > +	pr_level(n, fmt, ##__VA_ARGS__)
> > +#define pr(fmt, ...)  pr_N(1, pr_fmt(fmt), ##__VA_ARGS__)
> > +
> > +static int pr_time(const char *str, u64 time)
> > +{
> > +	u64 secs, usecs, nsecs = time;
> > +
> > +	secs = nsecs / NSECS_PER_SEC;
> > +	nsecs -= secs * NSECS_PER_SEC;
> > +	usecs = nsecs / NSECS_PER_USEC;
> > +	return fprintf(stderr, "\t[%13lu.%06lu] %s\n", secs, usecs, str);
> > +}
> 
> It'd be better if these functions somehow reuse existing pr_* functions
> or at least honor the use_browser value IMHO.

I wanted to separate this output so I could have it not
mixed with standard debug messages.. it could get messy

I was thinking maybe we want some smart debug/verbose system
that would allow this.. separate debug messages based on the
config/subsystem/option/objects/whatever implemented via
generic code

thanks,
jirka
