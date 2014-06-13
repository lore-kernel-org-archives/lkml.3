Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaFMMHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:07:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64098 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaFMMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:07:50 -0400
Subject: Re: [PATCH 13/17] perf tools: Add perf_config_u64 function
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1402610913-19059-14-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
	 <1402610913-19059-14-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 21:07:43 +0900
Message-ID: <1402661263.2178.21.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-13 (금), 00:08 +0200, Jiri Olsa:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> Adding perf_config_u64 function to be able to parse
> 'llong' values out of config file.
> 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/cache.h  |  1 +
>  tools/perf/util/config.c | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index 7b176dd..5cf9e1b 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -22,6 +22,7 @@ typedef int (*config_fn_t)(const char *, const char *, void *);
>  extern int perf_default_config(const char *, const char *, void *);
>  extern int perf_config(config_fn_t fn, void *);
>  extern int perf_config_int(const char *, const char *);
> +extern u64 perf_config_u64(const char *, const char *);
>  extern int perf_config_bool(const char *, const char *);
>  extern int config_error_nonbool(const char *);
>  extern const char *perf_config_dirname(const char *, const char *);
> diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
> index 24519e1..e68bbe3 100644
> --- a/tools/perf/util/config.c
> +++ b/tools/perf/util/config.c
> @@ -286,6 +286,20 @@ static int parse_unit_factor(const char *end, unsigned long *val)
>  	return 0;
>  }
>  
> +static int perf_parse_llong(const char *value, long long *ret)
> +{
> +	if (value && *value) {
> +		char *end;
> +		long val = strtoll(value, &end, 0);

Why not declare the val as long long?

> +		unsigned long factor = 1;

Also please add a blank line between declaration and actual body.

Thanks,
Namhyung


> +		if (!parse_unit_factor(end, &factor))
> +			return 0;
> +		*ret = val * factor;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static int perf_parse_long(const char *value, long *ret)
>  {
>  	if (value && *value) {
> @@ -307,6 +321,14 @@ static void die_bad_config(const char *name)
>  	die("bad config value for '%s'", name);
>  }
>  
> +u64 perf_config_u64(const char *name, const char *value)
> +{
> +	long long ret = 0;
> +	if (!perf_parse_llong(value, &ret))
> +		die_bad_config(name);
> +	return (u64) ret;
> +}
> +
>  int perf_config_int(const char *name, const char *value)
>  {
>  	long ret = 0;



