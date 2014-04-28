Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaD1Kjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:39:33 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:46700 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaD1Kjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:39:31 -0400
Message-ID: <535E2FDC.2020309@de.ibm.com>
Date: Mon, 28 Apr 2014 12:39:24 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 1/3] perf tools: Cache register accesses for unwind processing
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com> <1397756352-26694-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397756352-26694-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042810-2966-0000-0000-00000B13DF6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/14 19:39, Jiri Olsa wrote:
> Caching registers value into an array. Got about 4% speed up
> of perf_reg_value function for report command processing
> dwarf unwind stacks.
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
> 

Want such a speedup, 
but it does not compile on my s390x system:

  CC       util/top.o
In file included from util/event.h:10:0,
                 from util/event.c:2:
util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
In file included from util/event.h:10:0,
                 from util/callchain.h:7,
                 from util/hist.h:6,
                 from util/evsel.h:11,
                 from util/evsel.c:18:
util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
In file included from /home/cborntra/REPOS/linux/tools/perf/util/event.h:10:0,
                 from /home/cborntra/REPOS/linux/tools/perf/util/debug.h:6,
                 from util/cpumap.h:8,
                 from util/top.c:9:
/home/cborntra/REPOS/linux/tools/perf/util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
/home/cborntra/REPOS/linux/tools/perf/util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
In file included from /home/cborntra/REPOS/linux/tools/perf/util/event.h:10:0,
                 from /home/cborntra/REPOS/linux/tools/perf/util/debug.h:6,
                 from util/cpumap.h:8,
                 from util/evlist.c:12:
/home/cborntra/REPOS/linux/tools/perf/util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
/home/cborntra/REPOS/linux/tools/perf/util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
  CC       util/usage.o
  CC       util/wrapper.o
  CC       util/sigchain.o
In file included from util/event.h:10:0,
                 from util/header.h:8,
                 from util/parse-options.c:4:
util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
cc1: all warnings being treated as errors
make[1]: *** [util/parse-options.o] Error 1
make[1]: *** Waiting for unfinished jobs....
cc1: all warnings being treated as errors
cc1: all warnings being treated as errors
make[1]: *** [util/event.o] Error 1
make[1]: *** [util/evsel.o] Error 1
In file included from util/event.h:10:0,
                 from util/debug.h:6,
                 from util/usage.c:10:
util/perf_regs.h:24:6: error: ‘struct regs_dump’ declared inside parameter list [-Werror]
util/perf_regs.h:24:6: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]
cc1: all warnings being treated as errors
make[1]: *** [util/usage.o] Error 1
cc1: all warnings being treated as errors
make[1]: *** [util/evlist.o] Error 1
cc1: all warnings being treated as errors
make[1]: *** [util/top.o] Error 1


