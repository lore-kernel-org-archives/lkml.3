Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3LOMfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:35:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3LOMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:35:19 -0500
Date: Sun, 15 Dec 2013 13:35:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v5 3/3] perf diff: color the Weighted Diff column
Message-ID: <20131215123515.GA12431@krava.brq.redhat.com>
References: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
 <1386679742-13357-4-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386679742-13357-4-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 06:19:02PM +0530, Ramkumar Ramachandra wrote:
> In
> 
>   $ perf diff -c wdiff:M,N
> 
> color the numbers in the Weighted Diff column either green or red,
> depending on whether the number is positive or negative.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index c07cd3c..8e6e541 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -777,6 +777,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  		container_of(fmt, struct diff_hpp_fmt, fmt);
>  	struct hist_entry *pair = get_pair_fmt(he, dfmt);
>  	double diff;
> +	s64 wdiff;
>  	char pfmt[20] = " ";
>  
>  	if (!pair)
> @@ -805,6 +806,18 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
>  		return value_color_snprintf(hpp->buf, hpp->size,
>  					pfmt, diff);
> +	case COMPUTE_WEIGHTED_DIFF:
> +		if (he->dummy)
> +			goto dummy_print;
> +		if (pair->diff.computed)
> +			wdiff = pair->diff.wdiff;
> +		else
> +			wdiff = compute_wdiff(he, pair);
> +
> +		scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
> +		return color_snprintf(hpp->buf, hpp->size,
> +				wdiff > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
> +				pfmt, wdiff);

this one is still wrong, you either need to use 'abs(wdiff) > 0'
or call value_color_snprintf (which is better) as in previous cases

jirka
