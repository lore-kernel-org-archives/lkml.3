Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaJTKLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbaJTKLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:11:06 -0400
Date: Mon, 20 Oct 2014 12:10:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Support handling complete branch stacks
 as histograms
Message-ID: <20141020101045.GC10629@krava.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:09PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

>  
>  struct callchain_list {
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ec38b..8ba32ce 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -12,6 +12,7 @@
>  #include <stdbool.h>
>  #include <symbol/kallsyms.h>
>  #include "unwind.h"
> +#include "linux/hash.h"
>  
>  int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>  {
> @@ -1364,9 +1365,84 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
>  	return bi;
>  }
>  
> +static int add_callchain_ip(struct machine *machine,
> +			    struct thread *thread,
> +			    struct symbol **parent,
> +			    struct addr_location *root_al,
> +			    int cpumode,
> +			    u64 ip)
> +{
> +	struct addr_location al;
> +
> +	al.filtered = 0;
> +	al.sym = NULL;
> +	if (cpumode == -1)
> +		thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
> +	else
> +		thread__find_addr_location(thread, machine, cpumode, MAP__FUNCTION,
> +				   ip, &al);

this cpumode condition is new (wrt below comment)

> +	if (al.sym != NULL) {
> +		if (sort__has_parent && !*parent &&
> +		    symbol__match_regex(al.sym, &parent_regex))
> +			*parent = al.sym;
> +		else if (have_ignore_callees && root_al &&
> +		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> +			/* Treat this symbol as the root,
> +			   forgetting its callees. */
> +			*root_al = al;
> +			callchain_cursor_reset(&callchain_cursor);
> +		}
> +		if (!symbol_conf.use_callchain)
> +			return -EINVAL;

why is this condition here?

could you please split this change into
  - adding add_callchain_ip function
  - adding more functionality to add_callchain_ip function?

IMO it'd make it cleaner and easier to understand

thanks,
jirka
