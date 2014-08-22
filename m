Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaHVPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:16:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:58796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbaHVPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:16:56 -0400
Date: Fri, 22 Aug 2014 12:16:51 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] perf tools: Add +field argument support for --sort
 option
Message-ID: <20140822151651.GC3473@kernel.org>
References: <1408715919-25990-1-git-send-email-jolsa@kernel.org>
 <1408715919-25990-3-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408715919-25990-3-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 22, 2014 at 03:58:39PM +0200, Jiri Olsa escreveu:
> Adding support to add field(s) to default sort order
> via using the '+' prefix, like for report:
> 
>   $ perf report
>   Samples: 2K of event 'cycles', Event count (approx.): 882172583
>   Overhead  Command          Shared Object                Symbol
>      7.39%  swapper          [kernel.kallsyms]            [k] intel_idle
>      1.97%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock
>      1.39%  firefox          [snd_hda_intel]              [k] azx_get_position
>      1.11%  firefox          libpthread-2.17.so           [.] pthread_mutex_unlock
> 
>   $ perf report -s +cpu
>   Samples: 2K of event 'cycles', Event count (approx.): 882172583
>   Overhead  Command          Shared Object                Symbol                      CPU
>      2.89%  swapper          [kernel.kallsyms]            [k] intel_idle              000
>      2.61%  swapper          [kernel.kallsyms]            [k] intel_idle              002
>      1.20%  swapper          [kernel.kallsyms]            [k] intel_idle              001
>      0.82%  firefox          libpthread-2.17.so           [.] pthread_mutex_lock      002
> 
> Works in general for commands using --sort option.
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
>  tools/perf/util/sort.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 1958637cf136..b3d7dc1837ec 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1446,12 +1446,38 @@ static const char *get_default_sort_order(void)
>  	return default_sort_orders[sort__mode];
>  }
>  
> +static int setup_sort_order(void)
> +{
> +#define BUF_MAX 4096

This is an arbitrary value, and you will use this just here, so you
could just have used a number and later used sizeof(buf).

Anyway, what bothers me is the use of yet another static buffer.

The thing to use here is asprintf, that will do it all for you, format
_and_ allocate a buffer the size you need.

> +	static char buf[BUF_MAX];
> +
> +	if (!sort_order || is_strict_order(sort_order))
> +		return 0;
> +
> +	if (!strlen(sort_order + 1)) {
> +		error("Invalid --fields key: `+'");
> +		return -EINVAL;
> +	}
> +
> +	scnprintf(buf, BUF_MAX, "%s,%s",
> +		  get_default_sort_order(),
> +		  sort_order + 1);
> +
> +	sort_order = buf;

I.e. it would be better to have this as:

	char *new_sort_order;

	if (sort_order[1] == '\0') {
		error("Invalid --fields key: `+'");
		return -EINVAL;
	}

	if (asprintf(&new_sort_order, "%s,%s",
		     get_default_sort_order(), sort_order + 1) < 0) {
		error("Not enough memory to set up --sort");
		return -ENOMEM;
	}
		
	sort_order = new_sort_order;

> +	return 0;


Also please fix the error message, there is a cut'n'paste error there :-)

I applied the --fields one.

- Arnaldo

> +#undef BUF_MAX
> +}
> +
>  static int __setup_sorting(void)
>  {
>  	char *tmp, *tok, *str;
> -	const char *sort_keys = sort_order;
> +	const char *sort_keys;
>  	int ret = 0;
>  
> +	if (setup_sort_order())
> +		return -EINVAL;
> +
> +	sort_keys = sort_order;
>  	if (sort_keys == NULL) {
>  		if (is_strict_order(field_order)) {
>  			/*
> -- 
> 1.8.3.1
