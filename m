Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3KZMDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:03:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab3KZMC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:02:59 -0500
Date: Tue, 26 Nov 2013 13:02:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 3/5] perf diff: generalize hpp__color_delta for -c
Message-ID: <20131126120254.GI1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-4-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385274025-30282-4-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 11:50:23AM +0530, Ramkumar Ramachandra wrote:

SNIP

>  		container_of(fmt, struct diff_hpp_fmt, fmt);
>  	struct hist_entry *pair = get_pair_fmt(he, dfmt);
> -	double percent;
> +	double delta;
>  	char pfmt[20] = " ";
>  
>  	if (!pair)
>  		goto dummy_print;
>  	if (pair->diff.computed)
> -		percent = pair->diff.period_ratio_delta;
> +		switch (comparison_method) {
> +		case COMPUTE_DELTA:
> +			delta = pair->diff.period_ratio_delta;
> +			break;
> +		default:
> +			BUG_ON(1);
> +		}
>  	else
> -		percent = compute_delta(he, pair);
> +		switch (comparison_method) {
> +		case COMPUTE_DELTA:
> +			delta = compute_delta(he, pair);
> +			break;
> +		default:
> +			BUG_ON(1);
> +		}
>  
> -	if (!he->dummy && fabs(percent) >= 0.01) {
> -		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
> -		return color_snprintf(hpp->buf, hpp->size,
> -				percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
> -				pfmt, percent);
> +	if (!he->dummy) {
> +		switch (comparison_method) {
> +		case COMPUTE_DELTA:
> +			if (fabs(delta) < 0.01)
> +				goto dummy_print;
> +			scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
> +			return color_snprintf(hpp->buf, hpp->size,
> +					delta > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
> +					pfmt, delta);
> +			break;

I think it'd be better to have just one switch for
comparison_method and do all the processing within

thanks,
jirka
