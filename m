Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3LOMfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:35:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab3LOMfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:35:48 -0500
Date: Sun, 15 Dec 2013 13:35:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v5 1/3] perf diff: color the Delta column
Message-ID: <20131215123543.GA9458@krava.brq.redhat.com>
References: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
 <1386679742-13357-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386679742-13357-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 06:19:00PM +0530, Ramkumar Ramachandra wrote:

SNIP

> +	return scnprintf(hpp->buf, hpp->size, "%*s",
> +			dfmt->header_width, pfmt);
> +}
> +
> +static int hpp__color_delta(struct perf_hpp_fmt *fmt,
> +			struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
> +}
> +
>  static void
>  hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
>  {
> @@ -940,8 +979,16 @@ static void data__hpp_register(struct data__file *d, int idx)
>  	fmt->entry  = hpp__entry_global;
>  
>  	/* TODO more colors */
> -	if (idx == PERF_HPP_DIFF__BASELINE)
> +	switch (idx) {
> +	case PERF_HPP_DIFF__BASELINE:
>  		fmt->color = hpp__color_baseline;
> +		break;
> +	case PERF_HPP_DIFF__DELTA:
> +		fmt->color = hpp__color_delta;
> +		break;
> +	default:
> +		break;
> +	}

please put changes below into separated patch

>  
>  	init_header(d, dfmt);
>  	perf_hpp__column_register(fmt);
> diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
> index 66e44a5..ec5c756 100644
> --- a/tools/perf/util/color.c
> +++ b/tools/perf/util/color.c
> @@ -2,6 +2,8 @@
>  #include "cache.h"
>  #include "color.h"
>  
> +#include <math.h>
> +

nit: extra empty line

>  int perf_use_color_default = -1;
>  
>  static int parse_color(const char *name, int len)
> @@ -298,10 +300,10 @@ const char *get_percent_color(double percent)
>  	 * entries in green - and keep the low overhead places
>  	 * normal:
>  	 */
> -	if (percent >= MIN_RED)
> +	if (fabs(percent) >= MIN_RED)
>  		color = PERF_COLOR_RED;
>  	else {
> -		if (percent > MIN_GREEN)
> +		if (fabs(percent) > MIN_GREEN)
>  			color = PERF_COLOR_GREEN;
>  	}
>  	return color;
> -- 
> 1.8.5.rc0.5.g70ebc73.dirty
> 
