Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaGQIQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:16:16 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52579 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaGQIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:16:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/5] perf tools: Add --debug optionto set debug variable
References: <1405374411-29012-1-git-send-email-jolsa@kernel.org>
	<1405374411-29012-5-git-send-email-jolsa@kernel.org>
Date: Thu, 17 Jul 2014 17:15:49 +0900
In-Reply-To: <1405374411-29012-5-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Mon, 14 Jul 2014 23:46:50 +0200")
Message-ID: <87wqbc1juy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 14 Jul 2014 23:46:50 +0200, Jiri Olsa wrote:
> Adding --debug option as a way to setup debug variables.
> Starting with support for verbose, more will come.
>
> It's possible to use it now with report command:
>   $ perf --debug verbose   ...
>   $ perf --debug verbose=2 ...
>
> I'll need this support to add separated debug variable
> for ordered events change in order to separate debug
> output out of standard verbose stream.
>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/Documentation/perf-report.txt |  6 +++++
>  tools/perf/Documentation/perf.txt        | 10 +++++++-
>  tools/perf/perf.c                        | 13 +++++++++-
>  tools/perf/util/debug.c                  | 44 ++++++++++++++++++++++++++++++++
>  tools/perf/util/debug.h                  |  2 ++
>  5 files changed, 73 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index d2b59af62bc0..53b6ad8e4d4d 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -25,6 +25,12 @@ OPTIONS
>  --verbose::
>          Be more verbose. (show symbol address, etc)
>  
> +--debug::
> +        Setup debug variable (just verbose for now) in value
> +        range (0, 10). Use like:
> +           --debug verbose   # sets verbose = 1
> +           --debug verbose=2 # sets verbose = 2
> +
>  -n::
>  --show-nr-samples::
>  	Show the number of samples for each symbol
> diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
> index 0eeb247dc7d2..c75a42822c53 100644
> --- a/tools/perf/Documentation/perf.txt
> +++ b/tools/perf/Documentation/perf.txt
> @@ -8,7 +8,15 @@ perf - Performance analysis tools for Linux
>  SYNOPSIS
>  --------
>  [verse]
> -'perf' [--version] [--help] COMMAND [ARGS]
> +'perf' [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]

Hmm.. is this really needed?  Also, there're other options might be
added here.  What about just saying

  'perf' [--version] [--help] [OPTIONS] COMMAND [ARGS]

?

Thanks,
Namhyung


> +
> +OPTIONS
> +-------
> +--debug::
> +	Setup debug variable (just verbose for now) in value
> +	range (0, 10). Use like:
> +	  --debug verbose   # sets verbose = 1
> +	  --debug verbose=2 # sets verbose = 2
>  
>  DESCRIPTION
>  -----------
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 95c58fc15284..eed3fb2a3af0 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -13,11 +13,12 @@
>  #include "util/quote.h"
>  #include "util/run-command.h"
>  #include "util/parse-events.h"
> +#include "util/debug.h"
>  #include <api/fs/debugfs.h>
>  #include <pthread.h>
>  
>  const char perf_usage_string[] =
> -	"perf [--version] [--help] COMMAND [ARGS]";
> +	"perf [--version] [--debug variable[=VALUE]] [--help] COMMAND [ARGS]";
>  
>  const char perf_more_info_string[] =
>  	"See 'perf help COMMAND' for more information on a specific command.";
> @@ -212,6 +213,16 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
>  				printf("%s ", p->cmd);
>  			}
>  			exit(0);
> +		} else if (!strcmp(cmd, "--debug")) {
> +			if (*argc < 2) {
> +				fprintf(stderr, "No variable specified for --debug.\n");
> +				usage(perf_usage_string);
> +			}
> +			if (perf_debug_option((*argv)[1]))
> +				usage(perf_usage_string);
> +
> +			(*argv)++;
> +			(*argc)--;
>  		} else {
>  			fprintf(stderr, "Unknown option: %s\n", cmd);
>  			usage(perf_usage_string);
> diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
> index c208d6f56e63..71d419362634 100644
> --- a/tools/perf/util/debug.c
> +++ b/tools/perf/util/debug.c
> @@ -105,3 +105,47 @@ void trace_event(union perf_event *event)
>  	}
>  	printf(".\n");
>  }
> +
> +static struct debug_variable {
> +	const char *name;
> +	int *ptr;
> +} debug_variables[] = {
> +	{ .name = "verbose", .ptr = &verbose },
> +	{ .name = NULL, }
> +};
> +
> +int perf_debug_option(const char *str)
> +{
> +	struct debug_variable *var = &debug_variables[0];
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
> index 1cb808123242..89fb6b0f7ab2 100644
> --- a/tools/perf/util/debug.h
> +++ b/tools/perf/util/debug.h
> @@ -39,4 +39,6 @@ void pr_stat(const char *fmt, ...);
>  
>  int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
>  
> +int perf_debug_option(const char *str);
> +
>  #endif	/* __PERF_DEBUG_H */
