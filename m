Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaHMUGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:06:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:50344 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbaHMUGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:06:39 -0400
Date: Wed, 13 Aug 2014 17:06:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf ui/tui: Fix a small callchain display bug
Message-ID: <20140813200634.GG2718@kernel.org>
References: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 03:02:41PM +0900, Namhyung Kim escreveu:
> The currently when perf TUI report shows callchain, the first level
> chains have bogus '+' sign even though only the last one has children.
> 
> Since they are on a single line of the chain, toggling intermediate
> entries has no effect.  Fix it to show '+' sign at the last entry
> only.  Note that non-first level callchain entries don't have this
> problem.
> 
> Before:
> 
>   Children      Self  Command  Shared Object      Symbols
> ---------------------------------------------------------------------------

Please avoid starting a line with --- inside the changeset comment log as this
confuses scripts, that takes that as the end of the comment, like in ...
(see below)

> -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
>    + cpuidle_wrap_enter
>    + cpuidle_enter_tk
>    + cpuidle_idle_call
>    + cpu_idle
> 
> After:
> 
>   Children      Self  Command  Shared Object      Symbols
> ---------------------------------------------------------------------------
> -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
>      cpuidle_wrap_enter
>      cpuidle_enter_tk
>      cpuidle_idle_call
>    + cpu_idle
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

... here ^ ^ ^ ^ ^ 

:-)

Thanks for the fix, checking with 'P' after 'E' to expand everything,
before and after, to then do a:

diff -u perf.hist.0 perf.hist.1

- Arnaldo

>  tools/perf/ui/browsers/hists.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 045c1e16ac59..1818d1275d02 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -228,8 +228,10 @@ static void callchain_node__init_have_children(struct callchain_node *node)
>  {
>  	struct callchain_list *chain;
>  
> -	list_for_each_entry(chain, &node->val, list)
> +	if (!list_empty(&node->val)) {
> +		chain = list_entry(node->val.prev, struct callchain_list, list);
>  		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
> +	}
>  
>  	callchain_node__init_have_children_rb_tree(node);
>  }
> -- 
> 2.0.0
