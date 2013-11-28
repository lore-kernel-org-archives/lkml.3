Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab3K1PI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab3K1PIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:08:55 -0500
Date: Thu, 28 Nov 2013 16:08:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 2/4] perf diff: generalize hpp__color_delta for -c
Message-ID: <20131128150847.GF1245@krava.brq.redhat.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
 <1385550154-11385-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385550154-11385-3-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 04:32:32PM +0530, Ramkumar Ramachandra wrote:
> Generalize the function so that we can accommodate all three comparison
> methods: delta, ratio, and wdiff.

This patch basicaly factor the code you added in previous one.

Could we use the function below from the beggining?

jirka
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index fe6e200..20284c3 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -769,31 +769,44 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
>  	return ret;
>  }
>  
> -static int hpp__color_delta(struct perf_hpp_fmt *fmt,
> -			struct perf_hpp *hpp, struct hist_entry *he)
> +static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
> +				struct perf_hpp *hpp, struct hist_entry *he,
> +				int comparison_method)
>  {
>  	struct diff_hpp_fmt *dfmt =
>  		container_of(fmt, struct diff_hpp_fmt, fmt);
>  	struct hist_entry *pair = get_pair_fmt(he, dfmt);
> -	double percent;
> +	double diff;
>  	char pfmt[20] = " ";
>  
>  	if (!pair)
>  		goto dummy_print;
> -	if (pair->diff.computed)
> -		percent = pair->diff.period_ratio_delta;
> -	else
> -		percent = compute_delta(he, pair);
>  
> -	if (fabs(percent) >= 0.01) {
> +	switch(comparison_method){
> +	case COMPUTE_DELTA:
> +		if (pair->diff.computed)
> +			diff = pair->diff.period_ratio_delta;
> +		else
> +			diff = compute_delta(he, pair);
> +
> +		if (fabs(diff) < 0.01)
> +			goto dummy_print;
>  		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
>  		return color_snprintf(hpp->buf, hpp->size,
> -				percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
> -				pfmt, percent);
> -	} else
> +				diff > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
> +				pfmt, diff);
> +	default:
> +		BUG_ON(1);
> +	}
>  dummy_print:
> -		return scnprintf(hpp->buf, hpp->size, "%*s",
> -				dfmt->header_width, pfmt);
> +	return scnprintf(hpp->buf, hpp->size, "%*s",
> +			dfmt->header_width, pfmt);
> +}
> +
> +static int hpp__color_delta(struct perf_hpp_fmt *fmt,
> +			struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
>  }
>  
>  static void
> -- 
> 1.8.5.rc0.5.g70ebc73.dirty
> 
