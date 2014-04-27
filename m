Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaD0O33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:29:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56481 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaD0O31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:29:27 -0400
Subject: Re: [PATCH 1/3] perf tools: Cache register accesses for unwind
 processing
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
In-Reply-To: <1397756352-26694-2-git-send-email-jolsa@redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
	 <1397756352-26694-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Apr 2014 23:29:21 +0900
Message-ID: <1398608961.1689.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

2014-04-17 (목), 19:39 +0200, Jiri Olsa:
> Caching registers value into an array. Got about 4% speed up
> of perf_reg_value function for report command processing
> dwarf unwind stacks.

I'm not familiar with the code base, so probably silly questions:  Where
does the speed up come from?  IOW I don't know what's the difference
between the regs->regs and regs->cached_regs.  And does the cached_regs
contain correct values of registers for each frame?

Thanks,
Namhyung

> 
> Output from report over 1.5 GB data with DWARF unwind stacks:
> (TODO fix perf diff)
> 
>   current code:
>    6.81%  perf.old  perf.old                   [.] perf_reg_value
> 
>   change:
>    2.24%  perf      perf                       [.] perf_reg_value
> 
> And little bit of speed up:
> 
>  Performance counter stats for './perf.old report -i perf-test.data --stdio':
> 
>    134,664,011,577      cycles:u                  #    2.472 GHz
>    189,677,227,475      instructions:u            #    1.41  insns per cycle
>       54465.096050      task-clock (msec)         #    0.998 CPUs utilized
> 
>       54.598339009 seconds time elapsed
> 
>  Performance counter stats for './perf report -i perf-test.data --stdio':
> 
>    124,478,681,672      cycles:u                  #    2.466 GHz
>    168,998,379,866      instructions:u            #    1.36  insns per cycle
>       50487.110482      task-clock (msec)         #    0.997 CPUs utilized
> 
>       50.635824229 seconds time elapsed
> 
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/event.h     |  5 +++++
>  tools/perf/util/perf_regs.c | 10 +++++++++-
>  tools/perf/util/perf_regs.h |  4 +++-
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 38457d4..970d4eb 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -7,6 +7,7 @@
>  #include "../perf.h"
>  #include "map.h"
>  #include "build-id.h"
> +#include "perf_regs.h"
>  
>  struct mmap_event {
>  	struct perf_event_header header;
> @@ -87,6 +88,10 @@ struct regs_dump {
>  	u64 abi;
>  	u64 mask;
>  	u64 *regs;
> +
> +	/* Cached values/mask filled by first register access. */
> +	u64 cache_regs[PERF_REGS_MAX];
> +	u64 cache_mask;
>  };
>  
>  struct stack_dump {
> diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
> index a3539ef..43168fb 100644
> --- a/tools/perf/util/perf_regs.c
> +++ b/tools/perf/util/perf_regs.c
> @@ -1,11 +1,15 @@
>  #include <errno.h>
>  #include "perf_regs.h"
> +#include "event.h"
>  
>  int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
>  {
>  	int i, idx = 0;
>  	u64 mask = regs->mask;
>  
> +	if (regs->cache_mask & (1 << id))
> +		goto out;
> +
>  	if (!(mask & (1 << id)))
>  		return -EINVAL;
>  
> @@ -14,6 +18,10 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
>  			idx++;
>  	}
>  
> -	*valp = regs->regs[idx];
> +	regs->cache_mask |= (1 << id);
> +	regs->cache_regs[id] = regs->regs[idx];
> +
> +out:
> +	*valp = regs->cache_regs[id];
>  	return 0;
>  }
> diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
> index d6e8b6a..80d8ab1 100644
> --- a/tools/perf/util/perf_regs.h
> +++ b/tools/perf/util/perf_regs.h
> @@ -2,15 +2,17 @@
>  #define __PERF_REGS_H
>  
>  #include "types.h"
> -#include "event.h"
>  
>  #ifdef HAVE_PERF_REGS_SUPPORT
>  #include <perf_regs.h>
>  
> +struct regs_dump;
> +
>  int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
>  
>  #else
>  #define PERF_REGS_MASK	0
> +#define PERF_REGS_MAX	0
>  
>  static inline const char *perf_reg_name(int id __maybe_unused)
>  {



