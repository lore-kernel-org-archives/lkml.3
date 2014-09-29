Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaI2IfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaI2IfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:35:10 -0400
Date: Mon, 29 Sep 2014 10:34:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2 1/2] perf callchain: Create an address space per thread
Message-ID: <20140929083452.GA1223@krava.brq.redhat.com>
References: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411966692-26648-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:58:11PM +0900, Namhyung Kim wrote:
> The unw_addr_space_t in libunwind represents an address space to be
> used for stack unwinding.  It doesn't need to be create/destory
> everytime to unwind callchain (as in get_entries) and can have a same
> lifetime as thread (unless exec called).
> 
> So move the address space construction/destruction logic to the thread
> lifetime handling functions.  This is a preparation to enable caching
> in the unwind library.
> 
> Note that it saves unw_addr_space_t object using thread__set_priv().
> It seems currently only used by perf trace and perf kvm stat commands
> which don't use callchain.
> 
> Acked-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arun Sharma <asharma@fb.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/thread.c           |  6 ++++++
>  tools/perf/util/unwind-libunwind.c | 30 +++++++++++++++++++++++++-----
>  tools/perf/util/unwind.h           | 17 +++++++++++++++++
>  3 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index a9df7f2c6dc9..2b7b2d91c016 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -7,6 +7,7 @@
>  #include "util.h"
>  #include "debug.h"
>  #include "comm.h"
> +#include "unwind.h"
>  
>  int thread__init_map_groups(struct thread *thread, struct machine *machine)
>  {
> @@ -37,6 +38,9 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>  		thread->cpu = -1;
>  		INIT_LIST_HEAD(&thread->comm_list);
>  
> +		if (unwind__prepare_access(thread) < 0)
> +			goto err_thread;

So this is something we need to do only for DWARF unwind via libunwind.
Do we want some condition to bypass this in for the rest of the cases?

I think we could check for symbol_conf.use_callchain and for the
PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER sample types in evlist,
something like:

  bool has_dwarf_data_for_callchains = symbol_conf.use_callchain && evlist_sample_type_has(evlist, PERF_SAMPLE_REGS_USER|PERF_SAMPLE_STACK_USER)

;-)

thanks,
jirka
