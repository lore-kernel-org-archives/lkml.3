Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaIFTjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 15:39:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaIFTjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 15:39:21 -0400
Date: Sat, 6 Sep 2014 21:39:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH v4 3/3] perf tools: Add support to new style format of
 kernel PMU event
Message-ID: <20140906193917.GF6059@krava.brq.redhat.com>
References: <1409671770-17260-1-git-send-email-kan.liang@intel.com>
 <1409671770-17260-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409671770-17260-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:29:30AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>

SNIP

>  }
> +|
> +PE_KERNEL_PMU_EVENT
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *head = malloc(sizeof(*head));
> +	struct parse_events_term *term;
> +	struct list_head *list;
> +
> +	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +					$1, 1));
> +	ABORT_ON(!head);
> +	INIT_LIST_HEAD(head);
> +	list_add_tail(&term->list, head);
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_pmu(list, &data->idx, "cpu", head));
> +	parse_events__free_terms(head);
> +	$$ = list;
> +}
> +|
> +PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF

so, how about the event alias has more than 2 parts a-b-c ?

if I remove 'stalled-cycles-frontend' from lexer (patch attached),
I'll get error parsing it with this code:

---
[jolsa@krava perf]$ ls -l /sys/devices/cpu/events/stalled-cycles-frontend 
-r--r--r-- 1 root root 4096 Sep  6 21:17 /sys/devices/cpu/events/stalled-cycles-frontend
[jolsa@krava perf]$ ./perf record -e stalled-cycles-frontend ls
invalid or unsupported event: 'stalled-cycles-frontend'
Run 'perf list' for a list of valid events

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list available events
---

and.. if we will actually handle this correctly, I think maybe we want
to remove all the PERF_TYPE_HARDWARE equivalents? 

thanks,
jirka


---
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 4dd7f0467dd1..c1a354f651ca 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -176,8 +176,6 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 }
 
 cpu-cycles|cycles				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
-stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
-stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
 instructions					{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS); }
 cache-references				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_REFERENCES); }
 cache-misses					{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
