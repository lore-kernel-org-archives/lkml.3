Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3KVSpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:45:10 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:50176 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:45:04 -0500
Date: Fri, 22 Nov 2013 15:44:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf symbol: Save vmlinux or kallsyms path loaded
Message-ID: <20131122184458.GE11305@ghostprotocols.net>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
 <1384806771-2945-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384806771-2945-4-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 18, 2013 at 01:32:46PM -0700, David Ahern escreveu:
> Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
> not a user specified path). Upcoming perf sched timehist command requires
> kernel symbols for properly computing idle times and prints a warning
> if the kernel symbols are not loaded.

What would happen if strdup failed here?

Why don't we undo anything done so far in this function and return an
error?

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/symbol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index f55c18da1e40..915eb6c4a248 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1437,6 +1437,8 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
>  			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
>  		dso__set_long_name(dso, (char *)vmlinux);
>  		dso__set_loaded(dso, map->type);
> +		if (symbol_conf.vmlinux_name == NULL)
> +			symbol_conf.vmlinux_name = strdup(symfs_vmlinux);
>  		pr_debug("Using %s for symbols\n", symfs_vmlinux);
>  	}
>  
> @@ -1629,8 +1631,11 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
>  
>  do_kallsyms:
>  	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
> -	if (err > 0)
> +	if (err > 0) {
> +		if (symbol_conf.kallsyms_name == NULL)
> +			symbol_conf.kallsyms_name = strdup(kallsyms_filename);
>  		pr_debug("Using %s for symbols\n", kallsyms_filename);
> +	}
>  	free(kallsyms_allocated_filename);
>  
>  	if (err > 0 && !dso__is_kcore(dso)) {
> -- 
> 1.8.3.4 (Apple Git-47)
