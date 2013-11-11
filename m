Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3KKNgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:36:01 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43743 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3KKNfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:35:53 -0500
Date: Mon, 11 Nov 2013 10:35:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, Maynard Johnson <mpjohn@us.ibm.com>
Subject: Re: [RFC][PATCH] Fix inhert with perf record --pid
Message-ID: <20131111133544.GA18956@ghostprotocols.net>
References: <20131109020233.GA10009@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109020233.GA10009@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 08, 2013 at 06:02:33PM -0800, Sukadev Bhattiprolu escreveu:
> A gently tested RFC patch...

Can you please check recent threads with patches by Adrian Hunter and
Jiri Olsa, both probably addressing this problem, at some point there is
an explanation about the inherit scalability issues and how to overcome
it with a proposed new patch.

I'll probably merge today after trying to improve the changelog.

Look for:

 [PATCH V3 06/11] perf record: Add an option to force per-cpu mmaps

- ARnaldo

> ---
> 
> 
> From 38554891fc41082b767f24ce3293658f7329a691 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 8 Nov 2013 17:14:06 -0800
> Subject: [PATCH] Fix inhert with perf record --pid
> 
> If a target process is identified by its pid:
> 
> 	perf record --pid 1234
> 
> perf record does not follow any _newly_ created children of the
> process. perf_evlist__config() clears the ->inherit flag.
> 
>         if (evlist->cpus->map[0] < 0)
> 		opts->no_inherit = true;
> 
> It can be fixed and descendants can be followed, by this change
> below, but is this behavior by design ?
> 
> We do follow the children if the same process is started by perf:
> 
> 	perf record ./a.out
> 
> This was reported by Maynard Johnson <mpjohn@us.ibm.com>
> 
> On a related note, perf_target__validate() has this:
> 
>         /* CPU and PID are mutually exclusive */
>         if (target->tid && target->cpu_list) {
>                 target->cpu_list = NULL;
>                 if (ret == PERF_ERRNO_TARGET__SUCCESS)
>                         ret = PERF_ERRNO_TARGET__PID_OVERRIDE_CPU;
>         }
> 
> Again, its not clear why pid and cpu are exclusive in this case:
> 
> 	perf record --pid 1234 -C 0,1,2
> 
> The system call allows the both pid and cpu to be specified.
> 
> Looking at commit, I see that this check was pulled in from builtin-top.c.
> 
> 	commit 4bd0f2d2c0cf14de9c84c2fe689120c6b0f667c8
> 	Author: Namhyung Kim <namhyung.kim@lge.com>
> 	Date:   Thu Apr 26 14:15:18 2012 +0900
> 
> Does that check apply to 'perf record' or only 'perf top' ?
> 
> Appreciate any comments.
> 
> ---
>  tools/perf/util/evlist.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index e584cd3..c81d01a 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -742,7 +742,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
>  		return -1;
>  
>  	if (perf_target__has_task(target))
> -		evlist->cpus = cpu_map__dummy_new();
> +		evlist->cpus = cpu_map__new(target->cpu_list);
>  	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
>  		evlist->cpus = cpu_map__dummy_new();
>  	else
> -- 
> 1.7.1
