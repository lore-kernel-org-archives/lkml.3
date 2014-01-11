Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaAKQDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:03:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKQDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:03:17 -0500
Date: Sat, 11 Jan 2014 17:02:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/28] perf report: Cache cumulative callchains
Message-ID: <20140111160254.GD1131@krava.brq.redhat.com>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170793-21926-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:46:15PM +0900, Namhyung Kim wrote:
> It is possble that a callchain has cycles or recursive calls.  In that
> case it'll end up having entries more than 100% overhead in the
> output.  In order to prevent such entries, cache each callchain node
> and skip if same entry already cumulated.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 54 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 06330736485b..087d01cac1aa 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -363,7 +363,27 @@ static int
>  iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
>  			      struct addr_location *al __maybe_unused)
>  {
> +	struct callchain_cursor_node *node;
> +	struct hist_entry **he_cache;
> +
>  	callchain_cursor_commit(&callchain_cursor);
> +
> +	/*
> +	 * This is for detecting cycles or recursions so that they're
> +	 * cumulated only one time to prevent entries more than 100%
> +	 * overhead.
> +	 */
> +	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
> +	if (he_cache == NULL)
> +		return -ENOMEM;
> +
> +	iter->priv = he_cache;
> +	iter->curr = 0;
> +
> +	node = callchain_cursor_current(&callchain_cursor);
> +	if (node == NULL)
> +		return 0;

some leftover? looks like nop..

jirka

> +
>  	return 0;
>  }
>  

SNIP
