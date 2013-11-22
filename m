Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3KVPO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:14:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3KVPO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:14:56 -0500
Date: Fri, 22 Nov 2013 16:14:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [INCOMPLETE PATCH 4/4] perf diff: give Ratio column an
 appropriate color
Message-ID: <20131122151451.GC10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-5-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385044427-13995-5-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:03:47PM +0530, Ramkumar Ramachandra wrote:
> In
> 
>   $ perf diff -c ratio
> 
> color the Ratio column using percent_color_snprintf().
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  The incomplete bit is marked using a TODO; removing two trailing '%'
>  symbols doesn't seem to work. Can someone please tell me how to fix
>  this problem?

aah here it is..

jirka

> 
>  Thanks.
> 
>  tools/perf/builtin-diff.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 4477aa2..844841e 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -786,6 +786,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  		case COMPUTE_DELTA:
>  			delta = pair->diff.period_ratio_delta;
>  			break;
> +		case COMPUTE_RATIO:
> +			delta = pair->diff.period_ratio;
> +			break;
>  		default:
>  			BUG_ON(1);
>  		}
> @@ -794,6 +797,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  		case COMPUTE_DELTA:
>  			delta = compute_delta(he, pair);
>  			break;
> +		case COMPUTE_RATIO:
> +			delta = compute_ratio(he, pair);
> +			break;
>  		default:
>  			BUG_ON(1);
>  		}
> @@ -806,6 +812,12 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  					delta > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
>  					pfmt, delta);
>  			break;
> +		case COMPUTE_RATIO:
> +			/* TODO: strip trailing % without breaking color */
> +			scnprintf(pfmt, 20, "%%%d.6f%%%%", dfmt->header_width - 1);
> +			return percent_color_snprintf(hpp->buf, hpp->size,
> +						pfmt, delta);
> +			break;
>  		default:
>  			BUG_ON(1);
>  		}
> @@ -821,6 +833,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
>  	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
>  }
>  
> +static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
> +			struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
> +}
> +
>  static void
>  hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
>  {
> @@ -1002,6 +1020,9 @@ static void data__hpp_register(struct data__file *d, int idx)
>  	case PERF_HPP_DIFF__DELTA:
>  		fmt->color = hpp__color_delta;
>  		break;
> +	case PERF_HPP_DIFF__RATIO:
> +		fmt->color = hpp__color_ratio;
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 1.8.5.rc0.5.g70ebc73.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
