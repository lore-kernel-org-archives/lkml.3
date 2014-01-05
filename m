Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaAERbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:31:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaAERbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:31:35 -0500
Date: Sun, 5 Jan 2014 18:31:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 09/21] perf ui/hist: Add support to accumulated hist stat
Message-ID: <20140105173113.GH10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-10-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:15PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Print accumulated stat of a hist entry if requested.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/hist.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/hist.h |  1 +
>  2 files changed, 46 insertions(+)
> 
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index 78f4c92e9b73..eb9c07bcdb01 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -129,6 +129,28 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
>  			  scnprintf, true);					\
>  }
>  
> +#define __HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
> +static u64 he_get_acc_##_field(struct hist_entry *he)				\
> +{										\
> +	return he->stat_acc->_field;						\
> +}										\
> +										\
> +static int hpp__color_acc_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
> +			      struct perf_hpp *hpp, struct hist_entry *he) 	\
> +{										\
> +	return __hpp__fmt(hpp, he, he_get_acc_##_field, " %6.2f%%",		\
> +			  (hpp_snprint_fn)percent_color_snprintf, true);	\
> +}
> +
> +#define __HPP_ENTRY_ACC_PERCENT_FN(_type, _field)				\
> +static int hpp__entry_acc_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,	\
> +			      struct perf_hpp *hpp, struct hist_entry *he) 	\
> +{										\
> +	const char *fmt = symbol_conf.field_sep ? " %.2f" : " %6.2f%%";		\
> +	return __hpp__fmt(hpp, he, he_get_acc_##_field, fmt,			\
> +			  scnprintf, true);					\
> +}
> +
>  #define __HPP_ENTRY_RAW_FN(_type, _field)					\
>  static u64 he_get_raw_##_field(struct hist_entry *he)				\
>  {										\
> @@ -148,17 +170,25 @@ __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
>  __HPP_COLOR_PERCENT_FN(_type, _field)					\
>  __HPP_ENTRY_PERCENT_FN(_type, _field)
>  
> +#define HPP_PERCENT_ACC_FNS(_type, _str, _field, _min_width, _unit_width)\
> +__HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
> +__HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
> +__HPP_COLOR_ACC_PERCENT_FN(_type, _field)				\
> +__HPP_ENTRY_ACC_PERCENT_FN(_type, _field)

how about add 'stat|stat_acc' parameter to the HPP_PERCENT_FNS
macro and use it like:

#define __HPP_COLOR_PERCENT_FN(_type, _field, _stat)                            \
static u64 he_get_##_stat##_field(struct hist_entry *he)                        \
{                                                                               \
        return he->##_stat._field;                                              \
}                                                                               \


and use 'he_get_##_stat##_field' in __HPP_ENTRY_PERCENT_FN

This way you dont need to duplicate the code, that differs
only in the used stat data.. but it's possible I missed
something ;-)

btw just noticed __HPP_COLOR_PERCENT_FN does not use _type

jirka
