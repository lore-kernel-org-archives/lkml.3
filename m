Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbaDAFBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:01:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55034 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaDAFBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:01:53 -0400
Message-ID: <533A4839.60406@hitachi.com>
Date: Tue, 01 Apr 2014 14:01:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Fix --line option behavior
References: <1396327677-3657-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1396327677-3657-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/01 13:47), Namhyung Kim wrote:
> The commit 5a62257a3ddd1 ("perf probe: Replace line_list with
> intlist") replaced line_list to intlist but it has a problem that if a
> same line was added again, it'd return -EEXIST rather than 1.

Ah, right! that's a different behavior.

> Since line_range_walk_cb() only checks the result being negative, it
> resulted in failure or segfault sometimes.

Could you give me an example input of the segfault? I'd like to trace
it down.

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you very much!

> ---
>  tools/perf/util/probe-finder.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index df0238654698..3bf0c8cdccb7 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1441,13 +1441,15 @@ static int line_range_walk_cb(const char *fname, int lineno,
>  			      void *data)
>  {
>  	struct line_finder *lf = data;
> +	int err;
>  
>  	if ((strtailcmp(fname, lf->fname) != 0) ||
>  	    (lf->lno_s > lineno || lf->lno_e < lineno))
>  		return 0;
>  
> -	if (line_range_add_line(fname, lineno, lf->lr) < 0)
> -		return -EINVAL;
> +	err = line_range_add_line(fname, lineno, lf->lr);
> +	if (err < 0 && err != -EEXIST)
> +		return err;
>  
>  	return 0;
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


