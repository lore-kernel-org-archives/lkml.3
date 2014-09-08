Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaIHPKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:10:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:48571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaIHPKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="570017826"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH v4 3/3] perf tools: Add support to new style format of
 kernel PMU event
Thread-Topic: [PATCH v4 3/3] perf tools: Add support to new style format of
 kernel PMU event
Thread-Index: AQHPxsQCjueenvIII06f2A4h+b3p0pv0ANmAgANMVqA=
Date: Mon, 8 Sep 2014 15:09:41 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077015ADE71@SHSMSX103.ccr.corp.intel.com>
References: <1409671770-17260-1-git-send-email-kan.liang@intel.com>
 <1409671770-17260-3-git-send-email-kan.liang@intel.com>
 <20140906193917.GF6059@krava.brq.redhat.com>
In-Reply-To: <20140906193917.GF6059@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, Sep 02, 2014 at 11:29:30AM -0400, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> 
> SNIP
> 
> >  }
> > +|
> > +PE_KERNEL_PMU_EVENT
> > +{
> > +	struct parse_events_evlist *data = _data;
> > +	struct list_head *head = malloc(sizeof(*head));
> > +	struct parse_events_term *term;
> > +	struct list_head *list;
> > +
> > +	ABORT_ON(parse_events_term__num(&term,
> PARSE_EVENTS__TERM_TYPE_USER,
> > +					$1, 1));
> > +	ABORT_ON(!head);
> > +	INIT_LIST_HEAD(head);
> > +	list_add_tail(&term->list, head);
> > +
> > +	ALLOC_LIST(list);
> > +	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
> > +	parse_events__free_terms(head);
> > +	$$ = list;
> > +}
> > +|
> > +PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF
> 
> so, how about the event alias has more than 2 parts a-b-c ?
> 

Currently, the patch only handle the format for "a-b" or "a". I think it's enough for current usage.
The event alias with more than 2 parts a-b-c are already handled by hardcode in the lexer.
So I don't think we really need to support a-b-c format now.

> if I remove 'stalled-cycles-frontend' from lexer (patch attached), I'll get error
> parsing it with this code:
> 
> ---
> [jolsa@krava perf]$ ls -l /sys/devices/cpu/events/stalled-cycles-frontend
> -r--r--r-- 1 root root 4096 Sep  6 21:17 /sys/devices/cpu/events/stalled-
> cycles-frontend
> [jolsa@krava perf]$ ./perf record -e stalled-cycles-frontend ls invalid or
> unsupported event: 'stalled-cycles-frontend'
> Run 'perf list' for a list of valid events
> 
>  usage: perf record [<options>] [<command>]
>     or: perf record [<options>] -- <command> [<options>]
> 
>     -e, --event <event>   event selector. use 'perf list' to list available events
> ---
> 
> and.. if we will actually handle this correctly, I think maybe we want to
> remove all the equivalents?

Yes, there will be error if 'stalled-cycles-frontend' from lexer is removed. It's because not only the unsupported a-b-c format but also the middle name cycles. (Cycles could be individual event name or prefix/suffix of many event names. Lexer cannot distinguish them.)
However, why we want to remove it?
The current codes work well. PERF_TYPE_HARDWARE events are seldom changed. So I think it's OK to keep them unchanged.
We only need to handle possible extended events. (Actually, the new PMU events are not frequently added. I think "a-b" format is enough.)

Thanks,
Kan


> 
> thanks,
> jirka
> 
> 
> ---
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 4dd7f0467dd1..c1a354f651ca 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -176,8 +176,6 @@ branch_type		{ return term(yyscanner,
> PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
>  }
> 
>  cpu-cycles|cycles				{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
> -stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
> -stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
>  instructions					{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
>  cache-references				{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
>  cache-misses					{ return sym(yyscanner,
> PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
