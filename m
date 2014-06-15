Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaFORRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:17:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFORRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:17:44 -0400
Date: Sun, 15 Jun 2014 19:17:30 +0200
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
Subject: Re: [PATCH 01/17] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140615171730.GB1159@krava.brq.redhat.com>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
 <1402610913-19059-2-git-send-email-jolsa@kernel.org>
 <1402660314.2178.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402660314.2178.11.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:51:54PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> > The PERF_RECORD_FINISHED_ROUND governs queue flushing in
> > reporting, so it needs to be stored for any kind of event.
> > 
> > Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
> > time we finish the round and wrote at least one event.
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
> >  tools/perf/builtin-record.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 378b85b..4869050 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
> >  
> >  static int record__mmap_read_all(struct record *rec)
> >  {
> > +	u64 bytes_written = rec->bytes_written;
> >  	int i;
> >  	int rc = 0;
> >  
> > @@ -250,7 +251,11 @@ static int record__mmap_read_all(struct record *rec)
> >  		}
> >  	}
> >  
> > -	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
> > +	/*
> > +	 * Mark the round finished in case we wrote
> > +	 * at least one event.
> > +	 */
> > +	if (bytes_written != rec->bytes_written)
> >  		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
> 
> Hmm.. what was the rational behind the original code?  Why did it flush
> the events only if session has tracepoint events?  Frederic?

looks like the reason was the reordering in report, as described
in commit 984028075794c00cbf4fb1e94bb6233e8be08875

but there's no info why is this only for tracepoints
(or when tracepoints events are included)

> I guess this change alone can impact the performance in your case.
> Jiri, do you have a test result of it?

the impact is an extra 64 bytes (event header size) in perf.data
each time we read data from all cpus

I can see the impact more on the report size, where this events
governs the flushing of the reordering queue. If there's no
'finish_round' event, the queue is flushed at the end of the
processing (which leads to issues I explained in patch 0).

Now this problem is workarounded by this patchset via using the
HALF flush any time we reach the maximum of the reordering queue
size.

Still I think it's better to have 'finish_round' event for
any kind of event workloads, to keep the standard/expected
reordering processing in the report command.

thanks,
jirka
