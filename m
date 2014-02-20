Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaBTKkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbaBTKkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:40:32 -0500
Date: Thu, 20 Feb 2014 11:39:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/8] perf report: Add --percentage option
Message-ID: <20140220103950.GA11018@krava.brq.redhat.com>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
 <1392000446-14744-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392000446-14744-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:47:20AM +0900, Namhyung Kim wrote:
> The --percentage option is for controlling overhead percentage
> displayed.  It can only receive either of "relative" or "absolute".
> 
> "relative" means it's relative to filtered entries only so that the
> sum of shown entries will be always 100%.  "absolute" means it retains
> the original value before and after the filter is applied.

SNIP

> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index 78f4c92e9b73..714f3f00ea55 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -21,10 +21,13 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
>  
>  	if (fmt_percent) {
>  		double percent = 0.0;
> +		u64 total = hists->stats.total_period;
>  
> -		if (hists->stats.total_period)
> -			percent = 100.0 * get_field(he) /
> -				  hists->stats.total_period;
> +		if (symbol_conf.filter_relative)
> +			total = hists->stats.total_filtered_period;
> +
> +		if (total)
> +			percent = 100.0 * get_field(he) / total;
>  
>  		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
>  	} else
> @@ -41,6 +44,9 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
>  			u64 period = get_field(pair);
>  			u64 total = pair->hists->stats.total_period;
>  
> +			if (symbol_conf.filter_relative)
> +				total = pair->hists->stats.total_filtered_period;
> +
>  			if (!total)
>  				continue;

looks like we could use something like:

perf_hists__total_period(hists)
{
	u64 total = hists->stats.total_period;

	if (symbol_conf.filter_relative)
		total = hists->stats.total_filtered_period;

	return total;
}

probably on other places as well

jirka
