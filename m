Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaJTR5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJTR5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:57:32 -0400
Date: Mon, 20 Oct 2014 19:57:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] perf, tools: Enable printing the srcline in the
 history
Message-ID: <20141020175715.GB9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:11PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

> -		if (chain->ms.sym)
> -			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
> -		else
> -			ret += fprintf(fp, "                %p\n",
> -					(void *)(long)chain->ip);
> +		ret += fprintf(fp, "                %s\n", callchain_list__sym_name(chain,
> +					bf, sizeof(bf), false));
>  	}
>  
>  	return ret;
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 265457c..b7ee210 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -655,3 +655,32 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
>  out:
>  	return 1;
>  }
> +
> +char *callchain_list__sym_name(struct callchain_list *cl,
> +			       char *bf, size_t bfsize, bool show_dso)
> +{
> +	int printed;
> +
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
> +			printed = scnprintf(bf, bfsize, "%s",
> +					    cl->ms.sym->name);
> +	} else
> +		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
> +
> +	if (show_dso)
> +		scnprintf(bf + printed, bfsize - printed, " %s",
> +			  cl->ms.map ?
> +			  cl->ms.map->dso->short_name :
> +			  "unknown");
> +
> +	return bf;

could you please get the callchain_list__sym_name factoring code
separated of the new changes you introduce?

thanks,
jirka
