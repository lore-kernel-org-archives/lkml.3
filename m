Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FZB3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:29:00 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62647 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3FZB26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:28:58 -0400
X-AuditID: 9c93017d-b7c09ae000006fa0-b1-51ca43d840ee
From: Namhyung Kim <namhyung@kernel.org>
To: Greg Price <price@MIT.EDU>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of call graph
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
	<20130111052736.GG3054@ghostprotocols.net>
	<20130623031720.GW22203@biohazard-cafe.mit.edu>
Date: Wed, 26 Jun 2013 10:28:56 +0900
In-Reply-To: <20130623031720.GW22203@biohazard-cafe.mit.edu> (Greg Price's
	message of "Sat, 22 Jun 2013 23:17:20 -0400")
Message-ID: <871u7p3bjb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, 22 Jun 2013 23:17:20 -0400, Greg Price wrote:
> For example, in an application with an expensive function
> implemented with deeply nested recursive calls, the default
> call-graph presentation is dominated by the different callchains
> within that function.  By treating the function as a black box,
> we can collect the callchains leading into the function and
> compactly identify what to blame for expensive calls.
>
> For example, in this report the callers of garbage_collect() are

s/callers/callees/ ?

And it'd be better it shows more lines after garbage_collect so that one
can see its callers also to understand what it does more clearly.


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

Again, s/callers/callees/ ?


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
>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Greg Price <price@mit.edu>
> ---
>
> On Fri, Jan 11, 2013 at 02:27:36AM -0300, Arnaldo Carvalho de Melo wrote:
>> Looks like an interesting feature, will review this soon,
>
> Rebased on top of v3.10-rc7, please take a look at your convenience.
>
>
>  tools/perf/builtin-report.c | 19 ++++++++++++++++---
>  tools/perf/builtin-top.c    |  3 +--
>  tools/perf/util/machine.c   | 26 +++++++++++++++++---------
>  tools/perf/util/machine.h   |  9 ++++++++-
>  tools/perf/util/session.c   |  3 +--

You need to update the doc too.

>  5 files changed, 43 insertions(+), 17 deletions(-)
[SNIP]
> @@ -1211,8 +1214,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  					   MAP__FUNCTION, ip, &al, NULL);
>  		if (al.sym != NULL) {
>  			if (sort__has_parent && !*parent &&
> -			    symbol__match_parent_regex(al.sym))
> +			    symbol__match_regex(al.sym, &parent_regex))
>  				*parent = al.sym;
> +			else if (have_blackbox && root_al &&
> +			         symbol__match_regex(al.sym, &blackbox_regex)) {
> +				*root_al = al;
> +				callchain_cursor_reset(&callchain_cursor);

Okay, this is where the magic happens. :)

So it overwrites the original 'al' in process_sample_event() to
blackboxed symbol and drop the callchain.  Wouldn't it deserve a
comment? :)


> +			}
>  			if (!symbol_conf.use_callchain)
>  				break;
pp
This is unrelated to this patch, but why is this line needed?  I guess
this check should be done before calling this function.

Thanks,
Namhyung

