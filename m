Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3LATsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:48:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3LATsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:48:12 -0500
Date: Sun, 1 Dec 2013 20:48:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v4 1/3] perf diff: color the Delta column
Message-ID: <20131201194809.GA1215@krava.brq.redhat.com>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
 <1385732192-27713-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385732192-27713-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 07:06:30PM +0530, Ramkumar Ramachandra wrote:
> Color the numbers in the Delta column using percent_color_snprintf().
> Generalize the function so that we can accommodate all three comparison
> methods in the future: delta, ratio, and wdiff.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 3b67ea2..c970aae 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -769,6 +769,45 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
>  	return ret;
>  }
>  
> +static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
> +				struct perf_hpp *hpp, struct hist_entry *he,
> +				int comparison_method)
> +{
> +	struct diff_hpp_fmt *dfmt =
> +		container_of(fmt, struct diff_hpp_fmt, fmt);
> +	struct hist_entry *pair = get_pair_fmt(he, dfmt);
> +	double diff;
> +	char pfmt[20] = " ";
> +
> +	if (!pair)
> +		goto dummy_print;
> +
> +	switch(comparison_method){
> +	case COMPUTE_DELTA:
> +		if (pair->diff.computed)
> +			diff = pair->diff.period_ratio_delta;
> +		else
> +			diff = compute_delta(he, pair);
> +
> +		if (fabs(diff) < 0.01)
> +			goto dummy_print;
> +		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
> +		return percent_color_snprintf(hpp->buf, hpp->size,
> +					pfmt, fabs(diff));

we dont want print fabs(diff)..  we just want percent_color_snprintf
assign proper color for negative numbers, the change needs to go there

jirka
