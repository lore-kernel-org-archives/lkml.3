Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3KKLUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:20:25 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:32802 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KKLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:20:17 -0500
Date: Mon, 11 Nov 2013 12:20:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Prevent condition that all sort keys are
 elided
Message-ID: <20131111112013.GC15810@gmail.com>
References: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> If given sort keys are all elided there'll be no output except for the
> overhead column - actually the TUI shows a noisy output.  In this case
> it'd be better to show up the sort keys rather than elide.
> 
> Before:
> 
>   $ perf report -s comm -c perf
>   (...)
>   # Overhead
>   # ........
>   #
>      100.00%
> 
> After:
> 
>   $ perf report -s comm -c perf
>   (...)
>   # Overhead  Command
>   # ........  .......
>   #
>      100.00%     perf
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/sort.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 3c1b75c8b9a6..fb7d556ad721 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1137,6 +1137,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
>  
>  void sort__setup_elide(FILE *output)
>  {
> +	struct sort_entry *se;
> +
>  	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
>  				"dso", output);
>  	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
> @@ -1172,4 +1174,14 @@ void sort__setup_elide(FILE *output)
>  					"snoop", output);
>  	}
>  
> +	/*
> +	 * It makes no sense to elide all of sort entries.
> +	 * Just revert them to show up again.
> +	 */
> +	list_for_each_entry(se, &hist_entry__sort_list, list)
> +		if (!se->elide)
> +			return;

(Nit: please use curly braces around multi-line statements.)

> +
> +	list_for_each_entry(se, &hist_entry__sort_list, list)
> +		se->elide = false;

Looks good otherwise - this is the first step in the sort/key behavior 
improvements that we talked about a few days ago, right?

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
