Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3J1ILA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:11:00 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57272 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3J1IK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:10:58 -0400
X-AuditID: 9c93017e-b7ca6ae000000e8a-75-526e1c0f3e68
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/4] perf tools: Add call-graph option support into .perfconfig
References: <20131026120336.GA24439@gmail.com>
	<1382797536-32303-1-git-send-email-jolsa@redhat.com>
	<1382797536-32303-4-git-send-email-jolsa@redhat.com>
Date: Mon, 28 Oct 2013 17:10:54 +0900
In-Reply-To: <1382797536-32303-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 26 Oct 2013 16:25:35 +0200")
Message-ID: <87bo2995o1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 16:25:35 +0200, Jiri Olsa wrote:
> Adding call-graph option support into .perfconfig file,
> so it's now possible use call-graph option like:
>
>   [top]
>         call-graph = fp
>
>   [record]
>         call-graph = dwarf,8192
>
> Above options ONLY setup the unwind method. To enable
> perf record/top to actually use it the command line
> option -g/-G must be specified.
>
> The --call-graph option overloads .perfconfig setup.
>
> Assuming above configuration:
>
>   $ perf record -g ls
>   - enables dwarf unwind with user stack size dump 8192 bytes
>
>   $ perf top -G
>   - enables frame pointer unwind
>
>   $ perf record --call-graph=fp ls
>   - enables frame pointer unwind
>
>   $ perf top --call-graph=dwarf,4096 ls
>   - enables dwarf unwind with user stack size dump 4096 bytes
>
[SNIP]
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -750,6 +750,8 @@ int record_parse_callchain_opt(const struct option *opt,
>  	struct perf_record_opts *opts = opt->value;
>  	int ret;
>  
> +	opts->call_graph_enabled = !unset;
> +

Why not just using symbol_conf.use_callchain?

Thanks,
Namhyung


>  	/* --no-call-graph */
>  	if (unset) {
>  		opts->call_graph = CALLCHAIN_NONE;
> @@ -770,6 +772,8 @@ int record_callchain_opt(const struct option *opt,
>  {
>  	struct perf_record_opts *opts = opt->value;
>  
> +	opts->call_graph_enabled = !unset;
> +
>  	if (opts->call_graph == CALLCHAIN_NONE)
>  		opts->call_graph = CALLCHAIN_FP;
>  
> @@ -777,6 +781,16 @@ int record_callchain_opt(const struct option *opt,
>  	return 0;
>  }
