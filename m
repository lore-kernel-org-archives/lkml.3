Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaHMLsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaHMLsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:48:39 -0400
Date: Wed, 13 Aug 2014 13:48:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 03/13] perf annotate: Move session handling out of
 __cmd_annotate()
Message-ID: <20140813114822.GD2370@krava.brq.redhat.com>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
 <1407825645-24586-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407825645-24586-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:40:35PM +0900, Namhyung Kim wrote:

SNIP

>  
> @@ -301,6 +281,10 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  			.ordering_requires_timestamps = true,
>  		},
>  	};
> +	struct perf_data_file file = {
> +		.path  = input_name,
> +		.mode  = PERF_DATA_MODE_READ,
> +	};
>  	const struct option options[] = {
>  	OPT_STRING('i', "input", &input_name, "file",
>  		    "input file name"),
> @@ -308,7 +292,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  		   "only consider symbols in these dsos"),
>  	OPT_STRING('s', "symbol", &annotate.sym_hist_filter, "symbol",
>  		    "symbol to annotate"),
> -	OPT_BOOLEAN('f', "force", &annotate.force, "don't complain, do it"),
> +	OPT_BOOLEAN('f', "force", &file.force, "don't complain, do it"),
>  	OPT_INCR('v', "verbose", &verbose,
>  		    "be more verbose (show symbol address, etc)"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
> @@ -341,6 +325,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  		    "Show event group information together"),
>  	OPT_END()
>  	};
> +	int ret;
>  
>  	argc = parse_options(argc, argv, options, annotate_usage, 0);
>  
> @@ -353,11 +338,16 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	setup_browser(true);
>  
> +	annotate.session = perf_session__new(&file, false, &annotate.tool);
> +	if (annotate.session == NULL)
> +		return -ENOMEM;

I know you're just moving code, but perf_session__new could
fail for more reasons than just ENOMEM, which is the most
unlikely case ;-) -1 is probably better option here

jirka
