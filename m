Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaGNHvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:51:13 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55145 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaGNHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:51:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] perf tools: Add --debug optionto set debug variable
References: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
	<1405202188-5029-5-git-send-email-jolsa@kernel.org>
Date: Mon, 14 Jul 2014 16:51:06 +0900
In-Reply-To: <1405202188-5029-5-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Sat, 12 Jul 2014 23:56:28 +0200")
Message-ID: <87egxo2xat.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 12 Jul 2014 23:56:28 +0200, Jiri Olsa wrote:
> Adding --debug option as a way to setup debug variables.
> Starting with support for verbose, more will come.
>
> It's possible to use it now with report command:
>   $ perf report --debug verbose
>   $ perf report --debug verbose=2
>
> I'll need this support to add separated debug variable
> for ordered events change in order to separate debug
> output out of standard verbose stream.

Hmm.. okay.  I think there'll be more users for this.


>
> Also removing unneeded getopt.h includes.

I guess Arnaldo wants to see it as a separate change ;-)


> +static struct variables_t {
> +	const char *name;
> +	int *ptr;
> +} variables[] = {

This is a too general name.  How about debug_variable or debug_domain?

Thanks,
Namhyung


> +	{ .name = "verbose", .ptr = &verbose },
> +	{ .name = NULL, }
> +};
> +
> +int perf_debug_option(const struct option *opt __maybe_unused, const char *str,
> +		      int unset __maybe_unused)
> +{
> +	struct variables_t *var = &variables[0];
> +	char *vstr, *s = strdup(str);
> +	int v = 1;
> +
> +	vstr = strchr(s, '=');
> +	if (vstr)
> +		*vstr++ = 0;
> +
> +	while (var->name) {
> +		if (!strcmp(s, var->name))
> +			break;
> +		var++;
> +	}
> +
> +	if (!var->name) {
> +		pr_err("Unknown debug variable name '%s'\n", s);
> +		free(s);
> +		return -1;
> +	}
> +
> +	if (vstr) {
> +		v = atoi(vstr);
> +		/*
> +		 * Allow only values in range (0, 10),
> +		 * otherwise set 0.
> +		 */
> +		v = (v < 0) || (v > 10) ? 0 : v;
> +	}
> +
> +	*var->ptr = v;
> +	free(s);
> +	return 0;
> +}
> diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
> index 1cb8081..295fee5 100644
> --- a/tools/perf/util/debug.h
> +++ b/tools/perf/util/debug.h
> @@ -7,6 +7,7 @@
>  #include "../ui/helpline.h"
>  #include "../ui/progress.h"
>  #include "../ui/util.h"
> +#include "parse-options.h"
>  
>  extern int verbose;
>  extern bool quiet, dump_trace;
> @@ -39,4 +40,6 @@ void pr_stat(const char *fmt, ...);
>  
>  int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
>  
> +int perf_debug_option(const struct option *opt, const char *str, int unset);
> +
>  #endif	/* __PERF_DEBUG_H */
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 98e3047..dca9145 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -26,7 +26,6 @@
>  #include <errno.h>
>  #include <stdio.h>
>  #include <unistd.h>
> -#include <getopt.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <stdarg.h>
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index ea3fd7f..54d9e9b 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -22,7 +22,6 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#include <getopt.h>
>  #include <stdarg.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
