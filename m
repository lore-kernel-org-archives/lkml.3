Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab3GVKPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:15:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab3GVKPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:15:34 -0400
Date: Mon, 22 Jul 2013 12:15:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 18/23] perf tools: Move synthetizing into single function
Message-ID: <20130722101512.GD14350@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-19-git-send-email-jolsa@redhat.com>
 <87y592viit.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y592viit.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:30:50PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:58 +0200, Jiri Olsa wrote:
> > Moving synthetizing into single function, so it
> 
> s/synthetizing/synthesizing/
> 
> The same goes to the subject line too.

ok


> 
> 
> > could be reused.
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > ---
> >  tools/perf/builtin-record.c | 155 ++++++++++++++++++++++++++------------------
> >  1 file changed, 91 insertions(+), 64 deletions(-)
> >
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index b67564c..33a5bce 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -317,6 +317,95 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
> >  		       " relocation symbol.\n", machine->pid);
> >  }
> >  
> > +static int synthesize_record_pipe(struct perf_record *rec)
> > +{
> > +	struct perf_session  *session = rec->session;
> > +	struct perf_tool        *tool = &rec->tool;
> > +	struct perf_evlist    *evlist = rec->evlist;
> > +	int err;
> > +
> > +	err = perf_event__synthesize_attrs(tool, session,
> > +					   process_synthesized_event);
> > +	if (err < 0) {
> > +		pr_err("Couldn't synthesize attrs.\n");
> > +		return err;
> > +	}
> > +
> > +	if (have_tracepoints(&evlist->entries)) {
> > +		/*
> > +		 * FIXME err <= 0 here actually means that
> > +		 * there were no tracepoints so its not really
> > +		 * an error, just that we don't need to
> > +		 * synthesize anything.  We really have to
> > +		 * return this more properly and also
> > +		 * propagate errors that now are calling die()
> > +		 */
> 
> I believe that this comment is doubly wrong.  First we already check
> whether evlist has tracepoints before calling the below function.
> Secondly I think I got rid of all of the die() calls from the
> tracing_data_get/put path.
> 
> So I would suggest simply removing this comment block.
ook

thanks,
jirka
