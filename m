Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3LTSAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:00:42 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:45234 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3LTSAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:00:40 -0500
Date: Fri, 20 Dec 2013 15:00:31 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 1/3] [CLEANUP] perf-probe: Expand given path to
 absolute path
Message-ID: <20131220180031.GA28878@ghostprotocols.net>
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
 <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 20, 2013 at 10:02:57AM +0000, Masami Hiramatsu escreveu:
> Expand given path to absolute path in option parser,
> except for a module name. Instead of expanding it later,
> this get the absolute path in early stage.

What is the problem this solves?

Can you provide some output showing the problem, i.e. before you apply
this patch?

Then can you provide the output after the patch is applied?

- Arnaldo
 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/builtin-probe.c    |    9 +++++++++
>  tools/perf/util/probe-event.c |   11 ++---------
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 6ea9e85..b40d064 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -180,6 +180,15 @@ static int opt_set_target(const struct option *opt, const char *str,
>  		else
>  			return ret;
>  
> +		/* Expand given path to absolute path, except for modulename */
> +		if (params.uprobes || strchr(str, '/')) {
> +			str = realpath(str, NULL);
> +			if (!str) {
> +				pr_warning("Failed to find the path of %s.\n",
> +					   str);
> +				return ret;
> +			}
> +		}
>  		params.target = str;
>  		ret = 0;
>  	}
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index d7cff57..05be5de 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2281,7 +2281,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>  	struct perf_probe_point *pp = &pev->point;
>  	struct symbol *sym;
>  	struct map *map = NULL;
> -	char *function = NULL, *name = NULL;
> +	char *function = NULL;
>  	int ret = -EINVAL;
>  	unsigned long long vaddr = 0;
>  
> @@ -2297,12 +2297,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>  		goto out;
>  	}
>  
> -	name = realpath(exec, NULL);
> -	if (!name) {
> -		pr_warning("Cannot find realpath for %s.\n", exec);
> -		goto out;
> -	}
> -	map = dso__new_map(name);
> +	map = dso__new_map(exec);
>  	if (!map) {
>  		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
>  		goto out;
> @@ -2367,7 +2362,5 @@ out:
>  	}
>  	if (function)
>  		free(function);
> -	if (name)
> -		free(name);
>  	return ret;
>  }
> 
