Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3J1RrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab3J1RrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:47:00 -0400
Date: Mon, 28 Oct 2013 15:46:13 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record
 command
Message-ID: <20131028174613.GA3811@infradead.org>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
 <1382797536-32303-2-git-send-email-jolsa@redhat.com>
 <526D317E.80408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526D317E.80408@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 27, 2013 at 09:30:06AM -0600, David Ahern escreveu:
> On 10/26/13 8:25 AM, Jiri Olsa wrote:
> >diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> >index f10ab63..7be62770 100644
> >--- a/tools/perf/Documentation/perf-record.txt
> >+++ b/tools/perf/Documentation/perf-record.txt
> >@@ -92,8 +92,12 @@ OPTIONS
> >  	size is rounded up to have nearest pages power of two value.
> >
> >  -g::
> >+	Enables call-graph (stack chain/backtrace) recording.
> >+
> >  --call-graph::
> >-	Do call-graph (stack chain/backtrace) recording.
> >+	Setup and enable call-graph (stack chain/backtrace) recording,
> >+	implies -g.
> >+
> 
> This needs some more words as to why it is used over -g. It is also
> missing the options that can be given (fp or dwarf).

Added this:

--call-graph::
        Setup and enable call-graph (stack chain/backtrace) recording,
        implies -g.

        Allows specifying "fp" (frame pointer) or "dwarf"
        (DWARF's CFI - Call Frame Information) as the method to collect
        the information used to show the call graphs.

        In some systems, where binaries are build wit gcc
        --fomit-frame-pointer, using the "fp" method will produce bogus
        call graphs, using "dwarf", if available (perf tools linked to
        the libunwind library) should be used instead.

 
> ---8<---
> 
> >@@ -825,9 +851,12 @@ const struct option record_options[] = {
> >  		     perf_evlist__parse_mmap_pages),
> >  	OPT_BOOLEAN(0, "group", &record.opts.group,
> >  		    "put the counters into a counter group"),
> >-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
> >-			     "mode[,dump_size]", record_callchain_help,
> >-			     &record_parse_callchain_opt, "fp"),
> >+	OPT_CALLBACK(0, "call-graph", &record.opts,
> >+		     "mode[,dump_size]", record_callchain_help,
> >+		     &record_parse_callchain_opt),
> >+	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
> >+			   NULL, "enables call-graph recording" ,
> >+			   &record_callchain_opt),
> 
> From a user/readability perspective I would prefer the order to be
> -g then --call-graph especially since --call-graph is like an
> advanced -g where you get more control over the method used.

Reordered as suggested.
 
> Other than that:
> 
> Tested-Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks, adding those two.

And reworking it to make it apply against my perf/urgent branch, trying to fix
this annoyance on this merge window, as suggested by Ingo.

- Arnaldo
