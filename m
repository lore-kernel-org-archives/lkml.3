Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3KANSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:18:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3KANSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:18:02 -0400
Date: Fri, 1 Nov 2013 14:17:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 14/14] perf report: Add -g cumulative option
Message-ID: <20131101131734.GG10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-15-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-15-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:56:16PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The -g cumulative option is for showing accumulated overhead (period)
> value as well as self overhead.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Documentation/perf-report.txt |  2 ++
>  tools/perf/builtin-report.c              |  3 +++
>  tools/perf/util/callchain.c              | 12 +++++++++++-
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 10a279871251..b150bfb734f4 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -130,6 +130,8 @@ OPTIONS
>  	- graph: use a graph tree, displaying absolute overhead rates.
>  	- fractal: like graph, but displays relative rates. Each branch of
>  		 the tree is considered as a new profiled object. +
> +        - cumulative: accumulate callchain to parent entry so that they can
> +		    show up in the output.
>  
>  	order can be either:
>  	- callee: callee based call graph.
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 3b626127c8d6..281053b28898 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -1030,6 +1030,9 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
>  	else if (!strncmp(tok, "fractal", strlen(arg)))
>  		callchain_param.mode = CHAIN_GRAPH_REL;
>  
> +	else if (!strncmp(tok, "cumulative", strlen(arg)))
> +		callchain_param.mode = CHAIN_CUMULATIVE;
> +
>  	else if (!strncmp(tok, "none", strlen(arg))) {
>  		callchain_param.mode = CHAIN_NONE;
>  		symbol_conf.use_callchain = false;
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index c10052c6e73c..c3c73eb839df 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -150,6 +150,14 @@ sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_root *chain_root,
>  	rb_root->rb_node = chain_root->node.rb_root.rb_node;
>  }
>  
> +static void
> +sort_chain_cumulative(struct rb_root *rb_root __maybe_unused,
> +		      struct callchain_root *chain_root __maybe_unused,
> +		      u64 min_hit __maybe_unused,
> +		      struct callchain_param *param __maybe_unused)
> +{
> +}

maybe add some commentary explaning that it's intentionaly empty

or maybe dont set it and do following check
in __hists__insert_output_entry:

        if (symbol_conf.use_callchain && callchain_param.sort)
                callchain_param.sort(&he->sorted_chain, he->callchain,
                                      min_callchain_hits, &callchain_param);


jirka
