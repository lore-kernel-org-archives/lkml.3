Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3LENuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:50:51 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:37771 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3LENut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:50:49 -0500
Date: Thu, 5 Dec 2013 10:50:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/4] perf trace: Add option to specify machine type
Message-ID: <20131205135039.GB10333@ghostprotocols.net>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
 <1386211302-31303-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386211302-31303-5-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 07:41:42PM -0700, David Ahern escreveu:
> Perhaps there is a better way to do this; I could not think of one and
> I don't see any field in the tracepoint that can be leveraged. So ...
> 
> perf-trace autodetects the machine type (e.g., i386, x86_64, etc) via
> libaudit.

And that means that using perf.data files from another machine, say,
ARM, will produce completely bogus results :-\

We need a way to store this info in the perf.data header, i.e. use the
same algorithm that libaudit uses in audit_detect_machine() (and set the
open_id as well, btw) at 'perf record' time and store it somewhere.

What we have now that could be used?

Lets see:

[acme@zoo linux]$ perf report | grep 'arch'
# arch : x86_64
[acme@zoo linux]$

Would that be enough? Stephane?

- Arnaldo

> When running 32-bit apps on a 64-bit kernel the wrong machine
> type is used to convert syscall numbers to names leading to wrong information
> getting displayed to the user. This option allows the user to override
> the machine type to use.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-trace.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 0203324fe585..4a78a39b684a 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -2274,6 +2274,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
>  	};
>  	const char *output_name = NULL;
>  	const char *ev_qualifier_str = NULL;
> +	const char *machine_str = NULL;
>  	const struct option trace_options[] = {
>  	OPT_BOOLEAN(0, "comm", &trace.show_comm,
>  		    "show the thread COMM next to its id"),
> @@ -2308,6 +2309,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
>  		    "Show only syscall summary with statistics"),
>  	OPT_BOOLEAN('S', "with-summary", &trace.summary,
>  		    "Show all syscalls and summary with statistics"),
> +	OPT_STRING('M', NULL, &machine_str, "x86|x86_64",
> +		     "Advanced: machine type for converting system calls: x86, x86_64"),
>  	OPT_END()
>  	};
>  	int err;
> @@ -2318,6 +2321,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
>  
> +	if (machine_str) {
> +		if (strcmp(machine_str, "x86") == 0)
> +			trace.audit.machine = MACH_X86;
> +		else if (strcmp(machine_str, "x86_64") == 0)
> +			trace.audit.machine = MACH_86_64;
> +		else {
> +			pr_err("Invalid machine type\n");
> +			return -EINVAL;
> +		}
> +	}
> +
>  	/* summary_only implies summary option, but don't overwrite summary if set */
>  	if (trace.summary_only)
>  		trace.summary = trace.summary_only;
> -- 
> 1.8.3.4 (Apple Git-47)
