Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaDHH4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:56:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:34924 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbaDHH43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:56:29 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 07/15 V3] perf, c2c: Add in sort on physid
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-8-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 16:56:25 +0900
In-Reply-To: <1395689826-215033-8-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:58 -0400")
Message-ID: <87k3b0w8ye.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:36:58 -0400, Don Zickus wrote:
> Now that the infrastructure is set, add in the support to use
> hist_entry to sort on physid.
>
> V2: use new mmap2 sort
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/builtin-c2c.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> index d7eaf81..b5742bd 100644
> --- a/tools/perf/builtin-c2c.c
> +++ b/tools/perf/builtin-c2c.c
> @@ -7,6 +7,7 @@
>  #include "util/tool.h"
>  #include "util/debug.h"
>  #include <api/fs/fs.h>
> +#include "util/annotate.h"

Why is this #include needed?


[SNIP]
> @@ -163,7 +169,33 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
>  		return 0;
>  	}
>  
> -	return 0;
> +	cost = sample->weight;
> +	if (!cost)
> +		cost = 1;
> +
> +	/*
> +	 * must pass period=weight in order to get the correct
> +	 * sorting from hists__collapse_resort() which is solely
> +	 * based on periods. We want sorting be done on nr_events * weight
> +	 * and this is indirectly achieved by passing period=weight here
> +	 * and the he_stat__add_period() function.
> +	 */
> +	he = __hists__add_entry(&c2c->hists, al, parent, NULL, mi,
> +				cost, cost, 0);
> +	if (!he) {
> +		err = -ENOMEM;
> +		goto out_mem;
> +	}
> +
> +	c2c->hists.stats.total_period += cost;
> +	hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
> +	return err;
> +
> +out_mem:
> +	/* implicitly freed by __hists__add_entry */
> +	free(mi);
> +out:

It seems this 'out' lable is not used anywhere..


> +	return err;
>  }
>  
>  /* setup the basic events for most coverage, options added later */
> @@ -266,10 +298,28 @@ out:
>  	return err;
>  }
>  
> +static int perf_c2c__init(struct perf_c2c *c2c)
> +{
> +	sort__mode = SORT_MODE__PHYSID;
> +	sort__wants_unique = 1;
> +	sort_order = "daddr,iaddr,pid,tid";

Where are the SORT_MODE__PHYSID, sort__wants_unique and "daddr", "iaddr"
sort keys defined?

Also, more importantly, I think the sort order should contain at least
"mem" and "snoop" keys to group samples based on the exact hitm
information.

In my understanding, if two samples are captured at exactly same
position with a same data access but different hitm info, they cannot be
classified and just use the hitm info of first entry.

Thanks,
Namhyung

> +
> +	if (setup_sorting() < 0) {
> +		pr_err("can not setup sorting\n");
> +		return -1;
> +	}
> +
> +	hists__init(&c2c->hists);
> +
> +	return 0;
> +}
>  static int perf_c2c__report(struct perf_c2c *c2c)
>  {
>  	setup_pager();
>  
> +	if (perf_c2c__init(c2c))
> +		return -1;
> +
>  	if (c2c->raw_records)
>  		perf_c2c__fprintf_header(stdout);
