Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaE3GDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:03:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52105 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaE3GDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:03:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip/urgent ] [BUGFIX] perf/probe: Fix a segfault if asked for variable it doesn't find
References: <20140528214406.GE2764@kernel.org>
	<20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
Date: Fri, 30 May 2014 15:03:03 +0900
In-Reply-To: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Thu, 29 May 2014 19:52:32 +0900")
Message-ID: <874n07g5wo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 29 May 2014 19:52:32 +0900, Masami Hiramatsu wrote:
> Fix a segfault bug by asking for variable it doesn't find.
> Since the convert_variable() didn't handle error code returned
> from convert_variable_location(), it just passed an incomplete
> variable field and then a segfault was occured when formatting
> the field.
>
> This fixes that bug by handling success code correctly in
> convert_variable(). Other callers of convert_variable_location()
> are correctly checking the return code.
>
> This bug was introduced by following commit. But another hidden
> erroneous error handling has been there previuosly (-ENOMEM case).

And -ERANGE too.. :)

Thanks,
Namhyung

>
>  commit 3d918a12a1b3088ac16ff37fa52760639d6e2403
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/probe-finder.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 5627621..9d8eb26 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -511,12 +511,12 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
>  
>  	ret = convert_variable_location(vr_die, pf->addr, pf->fb_ops,
>  					&pf->sp_die, pf->tvar);
> -	if (ret == -ENOENT)
> +	if (ret == -ENOENT || ret == -EINVAL)
>  		pr_err("Failed to find the location of %s at this address.\n"
>  		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
>  	else if (ret == -ENOTSUP)
>  		pr_err("Sorry, we don't support this variable location yet.\n");
> -	else if (pf->pvar->field) {
> +	else if (ret == 0 && pf->pvar->field) {
>  		ret = convert_variable_fields(vr_die, pf->pvar->var,
>  					      pf->pvar->field, &pf->tvar->ref,
>  					      &die_mem);
