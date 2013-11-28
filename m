Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3K1Igt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:36:49 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51085 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3K1Igr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:36:47 -0500
X-AuditID: 9c93017e-b7ba2ae00000088c-5e-5297009de50c
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf symbols: Move idle syms check from top to generic function
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
	<1384806771-2945-3-git-send-email-dsahern@gmail.com>
Date: Thu, 28 Nov 2013 17:36:44 +0900
In-Reply-To: <1384806771-2945-3-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 18 Nov 2013 13:32:45 -0700")
Message-ID: <871u20rkgz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Just minor nits below..

On Mon, 18 Nov 2013 13:32:45 -0700, David Ahern wrote:
> Allows list of idle symbols to be leveraged by other commands,
> such as the upcoming timehist command.

[SNIP]
> +bool symbol__is_idle(struct symbol *sym)
> +{
> +	const char * const idle_symbols[] = {

Wouldn't it better making it static?  It seems to build a table
everytime otherwise.


> +		"cpu_idle",
> +		"intel_idle",
> +		"default_idle",
> +		"native_safe_halt",
> +		"enter_idle",
> +		"exit_idle",
> +		"mwait_idle",
> +		"mwait_idle_with_hints",
> +		"poll_idle",
> +		"ppc64_runlatch_off",
> +		"pseries_dedicated_idle_sleep",
> +		NULL
> +	};
> +
> +	int i;
> +
> +	if (!sym)
> +		return false;
> +
> +	for (i = 0; idle_symbols[i]; i++) {

Also we can use ARRAY_SIZE() here and let the last NULL go IMHO.

Thanks,
Namhyung


> +		if (!strcmp(idle_symbols[i], sym->name))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int map__process_kallsym_symbol(void *arg, const char *name,
>  				       char type, u64 start)
>  {
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 07de8fea2f48..ad13c5d50b91 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -240,6 +240,7 @@ size_t symbol__fprintf(struct symbol *sym, FILE *fp);
>  bool symbol_type__is_a(char symbol_type, enum map_type map_type);
>  bool symbol__restricted_filename(const char *filename,
>  				 const char *restricted_filename);
> +bool symbol__is_idle(struct symbol *sym);
>  
>  int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
>  		  struct symsrc *runtime_ss, symbol_filter_t filter,
