Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560Ab3DCRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:06:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36842 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213Ab3DCRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:06:20 -0400
Date: Wed, 3 Apr 2013 14:06:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/10] perf sort: Add 'addr' sort key
Message-ID: <20130403170610.GA5493@ghostprotocols.net>
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
 <1364991979-3008-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364991979-3008-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I expected was that the result was this:

perf report --sort addr | grep -v ^# | sort -k2 -n | less

And in hexadecimal, can you fix this?

- Arnaldo

Em Wed, Apr 03, 2013 at 09:26:12PM +0900, Namhyung Kim escreveu:
>  static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 14c2fe20aa62..9599f805828f 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -43,12 +43,13 @@ enum hist_column {
>  	HISTC_COMM,
>  	HISTC_PARENT,
>  	HISTC_CPU,
> +	HISTC_SRCLINE,

Why move SRCLINE?

> +	HISTC_ADDR,
>  	HISTC_MISPREDICT,
>  	HISTC_SYMBOL_FROM,
>  	HISTC_SYMBOL_TO,
>  	HISTC_DSO_FROM,
>  	HISTC_DSO_TO,
> -	HISTC_SRCLINE,
>  	HISTC_LOCAL_WEIGHT,
>  	HISTC_GLOBAL_WEIGHT,
>  	HISTC_MEM_DADDR_SYMBOL,
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 1dbf16949250..5640a95b3575 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -342,6 +342,34 @@ struct sort_entry sort_cpu = {
>  	.se_width_idx	= HISTC_CPU,
>  };
>  
> +/* --sort addr */
> +
> +static int64_t
> +sort__addr_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	return right->ip - left->ip;
> +}
> +
> +static int hist_entry__addr_snprintf(struct hist_entry *self, char *bf,
> +				     size_t size, unsigned int width)
> +{
> +	struct map *map = self->ms.map;
> +	u64 addr = self->ip;
> +
> +	if (map)
> +		addr = map->unmap_ip(map, self->ip);
> +
> +	return repsep_snprintf(bf, size, "%#*llu", width, addr);
> +}
> +
> +struct sort_entry sort_addr = {
> +	.se_header      = "Address",
> +	.se_cmp	        = sort__addr_cmp,
> +	.se_snprintf    = hist_entry__addr_snprintf,
> +	.se_width_idx	= HISTC_ADDR,
> +};
> +
> +
>  /* sort keys for branch stacks */
>  
>  static int64_t
> @@ -871,6 +899,7 @@ static struct sort_dimension common_sort_dimensions[] = {
>  	DIM(SORT_PARENT, "parent", sort_parent),
>  	DIM(SORT_CPU, "cpu", sort_cpu),
>  	DIM(SORT_SRCLINE, "srcline", sort_srcline),
> +	DIM(SORT_ADDR, "addr", sort_addr),
>  };
>  
>  #undef DIM
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index 0232d476da87..0815e344f38c 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -138,6 +138,7 @@ enum sort_type {
>  	SORT_PARENT,
>  	SORT_CPU,
>  	SORT_SRCLINE,
> +	SORT_ADDR,
>  
>  	/* branch stack specific sort keys */
>  	__SORT_BRANCH_STACK,
> -- 
> 1.7.11.7
