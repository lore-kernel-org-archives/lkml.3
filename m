Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab3K1PHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:07:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3K1PHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:07:16 -0500
Date: Thu, 28 Nov 2013 16:07:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 1/4] perf diff: color the Delta column
Message-ID: <20131128150710.GE1245@krava.brq.redhat.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
 <1385550154-11385-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385550154-11385-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 04:32:31PM +0530, Ramkumar Ramachandra wrote:
> Color the numbers in the Delta column either green or red depending on
> whether the number is positive or negative.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 3b67ea2..fe6e200 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -769,6 +769,33 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
>  	return ret;
>  }
>  
> +static int hpp__color_delta(struct perf_hpp_fmt *fmt,
> +			struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	struct diff_hpp_fmt *dfmt =
> +		container_of(fmt, struct diff_hpp_fmt, fmt);
> +	struct hist_entry *pair = get_pair_fmt(he, dfmt);
> +	double percent;
> +	char pfmt[20] = " ";
> +
> +	if (!pair)
> +		goto dummy_print;
> +	if (pair->diff.computed)
> +		percent = pair->diff.period_ratio_delta;
> +	else
> +		percent = compute_delta(he, pair);
> +
> +	if (fabs(percent) >= 0.01) {
> +		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
> +		return color_snprintf(hpp->buf, hpp->size,
> +				percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,

these colors are not consistent with colors in baseline,
moreover all negative values are shown as red

- please check get_percent_color function (used for baseline),
  it checks the percentage against following values:

  #define MIN_GREEN       0.5
  #define MIN_RED         5.0

- you probably want to use that, or whatever other helper
  baseline uses
- also you need to change it to use/check the abs() value
  of the percentage, because it does not count with negative
  values (it's for baseline only so far), which we will get
  in here..


thanks,
jirka
