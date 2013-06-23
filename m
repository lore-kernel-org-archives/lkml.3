Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3FWVxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3FWVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:53:41 -0400
Date: Sun, 23 Jun 2013 23:53:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Greg Price <price@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130623215327.GA995@krava.redhat.com>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623031720.GW22203@biohazard-cafe.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 11:17:20PM -0400, Greg Price wrote:
> For example, in an application with an expensive function
> implemented with deeply nested recursive calls, the default
> call-graph presentation is dominated by the different callchains
> within that function.  By treating the function as a black box,
> we can collect the callchains leading into the function and
> compactly identify what to blame for expensive calls.
> 
> For example, in this report the callers of garbage_collect() are
> scattered across the tree:
> $ perf report -d ruby 2>- | grep -m10 ^[^#]*[a-z]
>     22.03%     ruby  [.] gc_mark
>                --- gc_mark
>                   |--59.40%-- mark_keyvalue
>                   |          st_foreach
>                   |          gc_mark_children
>                   |          |--99.75%-- rb_gc_mark
>                   |          |          rb_vm_mark
>                   |          |          gc_mark_children
>                   |          |          gc_marks
>                   |          |          |--99.00%-- garbage_collect
> 
> If we make garbage_collect() a black box, its callers are coalesced:
> $ perf report --blackbox garbage_collect -d ruby 2>- | grep -m10 ^[^#]*[a-z]
>     72.92%     ruby  [.] garbage_collect
>                --- garbage_collect
>                    vm_xmalloc
>                   |--47.08%-- ruby_xmalloc
>                   |          st_insert2
>                   |          rb_hash_aset
>                   |          |--98.45%-- features_index_add
>                   |          |          rb_provide_feature
>                   |          |          rb_require_safe
>                   |          |          vm_call_method

Seems useful, sort of oposite to parent option (-p)

few comments below

SNIP

>  		 * Special case: if there's an argument left then assume that
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 67bdb9f..abec83d 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -775,8 +775,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
>  		    sample->callchain) {
>  			err = machine__resolve_callchain(machine, evsel,
>  							 al.thread, sample,
> -							 &parent);
> -
> +							 &parent, NULL);
>  			if (err)
>  				return;
>  		}

Any reason why not add this for top?

> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ecad6..a14489c 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -11,6 +11,10 @@
>  #include <stdbool.h>
>  #include "unwind.h"
>  
> +regex_t blackbox_regex;
> +const char *blackbox_pattern;
> +int have_blackbox = 0;

util/sort.c mich be better place for this

It could also make sense to allow sorting on this
the same way as we do for '-s parent' and report only
'[other]' and 'blackbox' entries.

Also I dont like the 'blackbox' option name, it should
complement the parent option somehow.. but no idea ;-)

I tested this on separate example and numbers seem ok.

jirka
