Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaE2LDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:03:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41295 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaE2LDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:03:21 -0400
Message-ID: <538713F1.6000801@hitachi.com>
Date: Thu, 29 May 2014 20:03:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip/urgent ] [BUGFIX] perf/probe: Fix a segfault if asked
 for variable it doesn't find
References: <20140528214406.GE2764@kernel.org> <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo, this fixes the SEGV bug which you reported.

But I've found that perf probe sometimes loses the location of variables
with recent DWARF implementation. I need to check and fix that too.

Anyway, this patch should be applied for fixing critical bug.

Thank you,

(2014/05/29 19:52), Masami Hiramatsu wrote:
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
> 
> 
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


