Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaAPOh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:37:59 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:37915 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaAPOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:37:54 -0500
Date: Thu, 16 Jan 2014 11:37:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Message-ID: <20140116143749.GA21526@ghostprotocols.net>
References: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 16, 2014 at 10:49:31AM +0900, Namhyung Kim escreveu:
> Gaurav reported that perf cannot profile JIT program if it executes
> the code on heap.  This was because current map__new() only handle JIT
> on anon mappings - extends it to handle no_dso (heap, stack) case too.
> 
> This patch assumes JIT profiling only provides dynamic function
> symbols so check the mapping type to distinguish the case.  It'd
> provide no symbols for data mapping - if we need to support symbols on
> data mappings later it should be changed.

But we do support symbols in data mappings, that is why we have
MAP__VARIABLE, etc, can you elaborate?

Gaurav, do this fixes the problem you reported? Can I have your
Tested-by: tag?

- Arnaldo
 
> Reported-by: Gaurav Jain <gjain@fb.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/map.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 9b9bd719aa19..ee1dd687a262 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>  		map->ino = ino;
>  		map->ino_generation = ino_gen;
>  
> -		if (anon) {
> +		if ((anon || no_dso) && type == MAP__FUNCTION) {
>  			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
>  			filename = newfilename;
>  		}
> @@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>  			 * functions still return NULL, and we avoid the
>  			 * unnecessary map__load warning.
>  			 */
> -			if (no_dso)
> +			if (type != MAP__FUNCTION)
>  				dso__set_loaded(dso, map->type);
>  		}
>  	}
> -- 
> 1.7.11.7
