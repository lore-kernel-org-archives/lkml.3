Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaAOPNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:13:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaAOPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:13:39 -0500
Date: Wed, 15 Jan 2014 16:12:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] perf, tools: Enable printing the srcline in the
 history
Message-ID: <20140115151255.GC17358@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389661461-18996-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:04:19PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For lbr-as-callgraph we need to see the line number in the history,
> because many LBR entries can be in a single function, and just
> showing the same function name many times is not useful.
> 
> When the history code is configured to sort by address, also try to
> resolve the address to a file:srcline and display this in the browser.
> If that doesn't work still display the address.
> 
> This can be also useful without LBRs for understanding which call in a large
> function (or in which inlined function) called something else.
> 
> Contains fixes from Namhyung Kim
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/ui/browsers/hists.c | 15 ++++++++++++---
>  tools/perf/ui/stdio/hist.c     | 16 +++++++++++++---
>  tools/perf/util/callchain.h    |  1 +
>  tools/perf/util/machine.c      |  2 +-
>  tools/perf/util/srcline.c      |  6 ++++--
>  5 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index b720b92..060fffc 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -399,9 +399,18 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
>  {
>  	int printed;
>  
> -	if (cl->ms.sym)
> -		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
> -	else
> +	if (cl->ms.sym) {
> +		if (callchain_param.key == CCKEY_ADDRESS &&
> +		    cl->ms.map && !cl->srcline)
> +			cl->srcline = get_srcline(cl->ms.map->dso,
> +						  map__rip_2objdump(cl->ms.map,
> +								    cl->ip));
> +		if (cl->srcline)
> +			printed = scnprintf(bf, bfsize, "%s %s",
> +					cl->ms.sym->name, cl->srcline);
> +		else
> +			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
> +	} else
>  		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);

above function 'callchain_list__sym_name' could be exported

>  
>  	if (show_dso)
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 831fbb7..a494eed 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -56,9 +56,19 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
>  		} else
>  			ret += fprintf(fp, "%s", "          ");
>  	}
> -	if (chain->ms.sym)
> -		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
> -	else
> +	if (chain->ms.sym) {
> +		if (callchain_param.key == CCKEY_ADDRESS &&
> +		    chain->ms.map)
> +			chain->srcline = get_srcline(chain->ms.map->dso,
> +						  map__rip_2objdump(
> +							  chain->ms.map,
> +							  chain->ip));
> +		if (chain->srcline)
> +			ret += fprintf(fp, "%s %s\n",
> +				       chain->ms.sym->name, chain->srcline);
> +		else
> +			ret += fprintf(fp, "%s\n", chain->ms.sym->name);
> +	} else
>  		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);

and this place could call it

jirka
