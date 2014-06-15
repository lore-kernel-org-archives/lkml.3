Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaFOMqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 08:46:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46135 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaFOMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 08:46:39 -0400
Subject: Re: [RFC/PATCH] perf tools: Fix segfault in cumulative.callchain
 report
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
References: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jun 2014 21:46:31 +0900
Message-ID: <1402836391.1684.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-06-15 (일), 10:35 +0200, Jiri Olsa:
> heya,
> not completely sure this is what we want to do, but have no
> streght to dive into annotation code ;-)

Currently, cumulative entries do not accounts annotation info so
annotation only works for normal entries.  I'm not sure we should
support it or not, but anyway it also needs some updates on the
annotation code IMHO.

So I'm okay with disabling annotation on pure cumulative entries.

Thanks,
Namhyung


> 
> ---
> When cumulative callchain mode is on, we could get samples with
> with no actual hits. This breaks the assumption of the annotation
> code, that each sample has annotation counts allocated and leads
> to segfault.
> 
> Fixing this by additional checks for annotation stats.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 52c03fb..04a229a 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -17,6 +17,7 @@
>  #include "../util.h"
>  #include "../ui.h"
>  #include "map.h"
> +#include "annotate.h"
>  
>  struct hist_browser {
>  	struct ui_browser   b;
> @@ -1593,13 +1594,18 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
>  					 bi->to.sym->name) > 0)
>  				annotate_t = nr_options++;
>  		} else {
> -
>  			if (browser->selection != NULL &&
>  			    browser->selection->sym != NULL &&
> -			    !browser->selection->map->dso->annotate_warned &&
> -				asprintf(&options[nr_options], "Annotate %s",
> -					 browser->selection->sym->name) > 0)
> -				annotate = nr_options++;
> +			    !browser->selection->map->dso->annotate_warned) {
> +				struct annotation *notes;
> +
> +				notes = symbol__annotation(browser->selection->sym);
> +
> +				if (notes->src &&
> +				    asprintf(&options[nr_options], "Annotate %s",
> +						 browser->selection->sym->name) > 0)
> +					annotate = nr_options++;
> +			}
>  		}
>  
>  		if (thread != NULL &&
> @@ -1656,6 +1662,7 @@ retry_popup_menu:
>  
>  		if (choice == annotate || choice == annotate_t || choice == annotate_f) {
>  			struct hist_entry *he;
> +			struct annotation *notes;
>  			int err;
>  do_annotate:
>  			if (!objdump_path && perf_session_env__lookup_objdump(env))
> @@ -1679,6 +1686,10 @@ do_annotate:
>  				he->ms.map = he->branch_info->to.map;
>  			}
>  
> +			notes = symbol__annotation(he->ms.sym);
> +			if (!notes->src)
> +				continue;
> +
>  			/*
>  			 * Don't let this be freed, say, by hists__decay_entry.
>  			 */



