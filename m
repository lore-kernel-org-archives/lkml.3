Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790Ab3HHPIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:08:32 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:43260 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965689Ab3HHPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:08:31 -0400
Date: Thu, 8 Aug 2013 12:08:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/19] perf symbol: Save vmlinux or kallsyms path loaded
Message-ID: <20130808150825.GC6102@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-9-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375930261-77273-9-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 10:50:50PM -0400, David Ahern escreveu:
> Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
> not a user specified path). Upcoming perf sched timehist command requires
> kernel symbols for properly computing idle times and prints a warning
> if the kernel symbols are not loaded.

With this we will not know if the user passed something to set those
variables or if internally we did it, doesn't this break any existing
code assumption?

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/symbol.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index c655b9e..1f777f9 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1192,6 +1192,8 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
>  			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
>  		dso__set_long_name(dso, (char *)vmlinux);
>  		dso__set_loaded(dso, map->type);
> +		if (symbol_conf.vmlinux_name == NULL)
> +			symbol_conf.vmlinux_name = strdup(symfs_vmlinux);
>  		pr_debug("Using %s for symbols\n", symfs_vmlinux);
>  	}
>  
> @@ -1325,8 +1327,11 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
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
> 1.7.10.1
