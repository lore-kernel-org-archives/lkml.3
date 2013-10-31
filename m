Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3JaUKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:10:09 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:44035 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3JaUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:10:07 -0400
Date: Thu, 31 Oct 2013 18:09:50 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michael Hudson-Doyle <michael.hudson@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tools: Remove cast of non-varadic function to
 varadic
Message-ID: <20131031200950.GA5949@infradead.org>
References: <877gctxlry.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gctxlry.fsf@canonical.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 31, 2013 at 12:50:25PM -0700, Michael Hudson-Doyle escreveu:
> 4fb71074a570 (perf ui/hist: Consolidate hpp helpers) introduced a cast of
> percent_color_snprintf to a function pointer type with varargs.  Change
> percent_color_snprintf to be varadic and remove the cast.
> 
> The symptom of this was all percentages being reported as 0.00% in perf
> report --stdio output on armhf.

git bisect + visual inspection, right? Anyway, good catch, interesting
it caused problems on just one arch, or have you tested this in other
arches?

Namhyung?

- Arnaldo
 
> Signed-off-by: Michael Hudson-Doyle <michael.hudson@linaro.org>
> ---
>  tools/perf/ui/hist.c    |  2 +-
>  tools/perf/util/color.c | 11 +++++++++--
>  tools/perf/util/color.h |  2 +-
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index 0a19328..78f4c92 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -117,7 +117,7 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
>  			      struct perf_hpp *hpp, struct hist_entry *he) 	\
>  {										\
>  	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
> -			  (hpp_snprint_fn)percent_color_snprintf, true);	\
> +			  percent_color_snprintf, true);			\
>  }
>  
>  #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
> diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
> index 11e46da..66e44a5 100644
> --- a/tools/perf/util/color.c
> +++ b/tools/perf/util/color.c
> @@ -318,8 +318,15 @@ int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
>  	return r;
>  }
>  
> -int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
> +int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
>  {
> -	const char *color = get_percent_color(percent);
> +	va_list args;
> +	double percent;
> +	const char *color;
> +
> +	va_start(args, fmt);
> +	percent = va_arg(args, double);
> +	va_end(args);
> +	color = get_percent_color(percent);
>  	return color_snprintf(bf, size, color, fmt, percent);
>  }
> diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
> index dea082b..fced384 100644
> --- a/tools/perf/util/color.h
> +++ b/tools/perf/util/color.h
> @@ -39,7 +39,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
>  int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
>  int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
>  int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
> -int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent);
> +int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...);
>  int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
>  const char *get_percent_color(double percent);
>  
> -- 
> 1.8.3.2
