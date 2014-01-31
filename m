Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaAaLug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 06:50:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44782 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154AbaAaLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 06:50:30 -0500
X-Sasl-enc: NlQLbQvKn6s2M//IrbWMT43bCIGYyKL85tkITo0GzLtE 1391169029
Message-ID: <52EB8E03.1030505@iki.fi>
Date: Fri, 31 Jan 2014 13:50:27 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
References: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 03:49 AM, Namhyung Kim wrote:
> Gaurav reported that perf cannot profile JIT program if it executes
> the code on heap.  This was because current map__new() only handle JIT
> on anon mappings - extends it to handle no_dso (heap, stack) case too.
>
> This patch assumes JIT profiling only provides dynamic function
> symbols so check the mapping type to distinguish the case.  It'd
> provide no symbols for data mapping - if we need to support symbols on
> data mappings later it should be changed.
>
> Reported-by: Gaurav Jain <gjain@fb.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Looks OK to me.  Gaurav, does this fix your problem?

> ---
>   tools/perf/util/map.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 9b9bd719aa19..ee1dd687a262 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>   		map->ino = ino;
>   		map->ino_generation = ino_gen;
>   
> -		if (anon) {
> +		if ((anon || no_dso) && type == MAP__FUNCTION) {
>   			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
>   			filename = newfilename;
>   		}
> @@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>   			 * functions still return NULL, and we avoid the
>   			 * unnecessary map__load warning.
>   			 */
> -			if (no_dso)
> +			if (type != MAP__FUNCTION)
>   				dso__set_loaded(dso, map->type);
>   		}
>   	}

