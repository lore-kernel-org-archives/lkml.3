Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaAHPQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:16:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbaAHPQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:16:52 -0500
Date: Wed, 8 Jan 2014 13:16:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 4/8] perf tools: Improve the message of perf list for
 unexpected input.
Message-ID: <20140108151637.GC2626@infradead.org>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
 <f03103f44fd4c4889920ff57f2cb5b6d2aea2435.1388416837.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f03103f44fd4c4889920ff57f2cb5b6d2aea2435.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 30, 2013 at 10:26:39AM -0500, Dongsheng Yang escreveu:
> Example:
>         # perf list test
> 
>         List of pre-defined events (to be used in -e):
>         # echo $?
>         0
> 
> Verification:
>         # perf list test
> 
>         No event for test.

?

Are we "testing" events?

The message is not clear, I can get some info from looking at the Usage,
but not from 'No event for test'.

At a minimum 'test' (whatevet invalid type/class is specified and found
to be invalid/unknown) should be quoted.

Perhaps the message should be along the lines of:

	# perf list test

	'test' is not a valid event type, please see the usage below for
	acceptable ones.

>         Usage:
>                 perf list [hw|sw|cache|tracepoint|pmu|event_glob]
>         # echo $?
>         255
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/builtin-list.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..fed6792 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -19,6 +19,7 @@
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
> +	unsigned int count = 0;
>  	const struct option list_options[] = {
>  		OPT_END()
>  	};
> @@ -41,26 +42,27 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  		if (i)
>  			putchar('\n');
>  		if (strncmp(argv[i], "tracepoint", 10) == 0)
> -			print_tracepoint_events(NULL, NULL, false);
> +			count += print_tracepoint_events(NULL, NULL, false);
>  		else if (strcmp(argv[i], "hw") == 0 ||
>  			 strcmp(argv[i], "hardware") == 0)
> -			print_events_type(PERF_TYPE_HARDWARE);
> +			count += print_events_type(PERF_TYPE_HARDWARE);
>  		else if (strcmp(argv[i], "sw") == 0 ||
>  			 strcmp(argv[i], "software") == 0)
> -			print_events_type(PERF_TYPE_SOFTWARE);
> +			count += print_events_type(PERF_TYPE_SOFTWARE);
>  		else if (strcmp(argv[i], "cache") == 0 ||
>  			 strcmp(argv[i], "hwcache") == 0)
> -			print_hwcache_events(NULL, false);
> +			count += print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
> -			print_pmu_events(NULL, false);
> +			count += print_pmu_events(NULL, false);
>  		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			print_events(NULL, true);
> +			count += print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
>  
>  			if (sep == NULL) {
> -				print_events(argv[i], false);
> +				if(!(count += print_events(argv[i], false)))
> +					goto err_out;
>  				continue;
>  			}
>  			sep_idx = sep - argv[i];
> @@ -69,9 +71,16 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  				return -1;
>  
>  			s[sep_idx] = '\0';
> -			print_tracepoint_events(s, s + sep_idx + 1, false);
> +			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, false)))
> +				goto err_out;
>  			free(s);
>  		}
>  	}
> +
>  	return 0;
> +
> +err_out:
> +	pr_info("\nNo event for %s.\n", argv[i]);
> +	pr_info("Usage:\n\t%s\n", list_usage[0]);
> +	return -1;
>  }
> -- 
> 1.8.2.1
