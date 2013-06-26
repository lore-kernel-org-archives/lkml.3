Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3FZWaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:30:12 -0400
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:53920 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab3FZWaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:30:10 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 18:30:10 EDT
X-AuditID: 1209190c-b7fa48e000000947-8f-51cb6a44a422
Date: Wed, 26 Jun 2013 18:25:01 -0400
From: Greg Price <price@MIT.EDU>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130626222500.GZ22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <871u7p3bjb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u7p3bjb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsUixCmqreuSdTrQ4MdnK4uLbRfZLA48PsBi
	sXXvGxaLo2f/Mllc3jWHzeLSgQVMFk3LtrJYrDmymN2Bw+PKUw6P0z16Hjtn3WX32LSqk83j
	/b6rbB5zd/UxenzeJBfAHsVlk5Kak1mWWqRvl8CV8en7ZraCWdoVb26vYm5gfCzXxcjJISFg
	IrGq7xALhC0mceHeerYuRi4OIYF9jBI9TVOgnI2MEt/2b2SHcD4zSiz8NpkVpIVFQFXi5P8V
	YO1sAgoSP+avYwaxRQTUJFauv8UC0sAsMItJYs+z1UwgCWGBCInpm/+DNfMKWEvsaD7KDDH1
	AKPE6gM3oRKCEidnPgGbyiygJXHj30ugZg4gW1pi+T8OkDCngIHE8ofnGEFsUQEViWv729km
	MArOQtI9C0n3LITuBYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3QN9XIzS/RSU0o3MYJjRZJn
	B+Obg0qHGAU4GJV4eD1YTgcKsSaWFVfmHmKU5GBSEuUtygAK8SXlp1RmJBZnxBeV5qQWH2KU
	4GBWEuG19gTK8aYkVlalFuXDpKQ5WJTEeUVu7QwUEkhPLEnNTk0tSC2CycpwcChJ8NZlAjUK
	FqWmp1akZeaUIKSZODhBhvMADW8HqeEtLkjMLc5Mh8ifYtTlmHx2y3tGIZa8/LxUKXHeSJAi
	AZCijNI8uDmwFPeKURzoLWHeEJAqHmB6hJv0CmgJE9CSmUtOgSwpSURISTUwduRcvnXj5JVS
	3sdsO5f9sjC7om4km1N53Ou6zSupE03T3XdmT1ee9lGYa2Wp7FvGmO88wQHTa/rTlRwes1Y4
	zzulfP/3hrWnXp9RMLx1aWHBI/1H2x4VT5g/b7vu+7O9CZFmW+M5apM51lbMdGSq/Zb8ePpc
	mV5mvizh8HM9iW4hfRx5L++/VGIpzkg01GIuKk4EAO56wttMAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

Thanks for the detailed review!


On Wed, Jun 26, 2013 at 10:28:56AM +0900, Namhyung Kim wrote:
> On Sat, 22 Jun 2013 23:17:20 -0400, Greg Price wrote:
> > For example, in an application with an expensive function
> > implemented with deeply nested recursive calls, the default
> > call-graph presentation is dominated by the different callchains
> > within that function.  By treating the function as a black box,
> > we can collect the callchains leading into the function and
> > compactly identify what to blame for expensive calls.
> >
> > For example, in this report the callers of garbage_collect() are
> 
> s/callers/callees/ ?

No, 'callers' is right.  This report is made without -G/--inverted, so
the trees are rooted at the inmost callees (the actual values of the
IP) and each node's children are its callers, rather than vice versa.
Here we want to see who is making these expensive calls to
garbage_collect, but the answer to this question is obscured because
the relevant callchains are separated according to which internal
helper functions to garbage_collect were on the stack.


> And it'd be better it shows more lines after garbage_collect so that one
> can see its callers also to understand what it does more clearly.

If you mean the commit message, the 'after' example that follows shows
this.  In the actual output (without the 'grep -m10' I've used here)
the patch doesn't affect those lines, and plenty more are in fact shown.

I could make the 'before' example longer too, and then we'd see what
the callers were in the callchains that look like
  gc_mark <- mark_keyvalue <- st_foreach <- gc_mark_children
    <- rb_gc_mark <- rb_vm_mark <- gc_mark_children <- gc_marks
    <- garbage_collect <- (the rest of a callchain).
But the callchains that have something else instead of that particular
sequence of eight helper functions (gc_mark called by ... called by
gc_marks) inside garbage_collect won't be included -- they're shown
in other places in the tree.  So it's actually precisely by using this
option that it's possible to see the callers completely, rather than
scattered across many places.


> > scattered across the tree:
> > $ perf report -d ruby 2>- | grep -m10 ^[^#]*[a-z]
> >     22.03%     ruby  [.] gc_mark
> >                --- gc_mark
> >                   |--59.40%-- mark_keyvalue
> >                   |          st_foreach
> >                   |          gc_mark_children
> >                   |          |--99.75%-- rb_gc_mark
> >                   |          |          rb_vm_mark
> >                   |          |          gc_mark_children
> >                   |          |          gc_marks
> >                   |          |          |--99.00%-- garbage_collect
> >
> > If we make garbage_collect() a black box, its callers are coalesced:
> 
> Again, s/callers/callees/ ?

Same as above.


> > $ perf report --blackbox garbage_collect -d ruby 2>- | grep -m10 ^[^#]*[a-z]
> >     72.92%     ruby  [.] garbage_collect
> >                --- garbage_collect
> >                    vm_xmalloc
> >                   |--47.08%-- ruby_xmalloc
> >                   |          st_insert2
> >                   |          rb_hash_aset
> >                   |          |--98.45%-- features_index_add
> >                   |          |          rb_provide_feature
> >                   |          |          rb_require_safe
> >                   |          |          vm_call_method


[snip]
> >  tools/perf/builtin-report.c | 19 ++++++++++++++++---
> >  tools/perf/builtin-top.c    |  3 +--
> >  tools/perf/util/machine.c   | 26 +++++++++++++++++---------
> >  tools/perf/util/machine.h   |  9 ++++++++-
> >  tools/perf/util/session.c   |  3 +--
> 
> You need to update the doc too.

Ah, thanks.  Will do.


> >  5 files changed, 43 insertions(+), 17 deletions(-)
> [SNIP]
> > @@ -1211,8 +1214,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
> >  					   MAP__FUNCTION, ip, &al, NULL);
> >  		if (al.sym != NULL) {
> >  			if (sort__has_parent && !*parent &&
> > -			    symbol__match_parent_regex(al.sym))
> > +			    symbol__match_regex(al.sym, &parent_regex))
> >  				*parent = al.sym;
> > +			else if (have_blackbox && root_al &&
> > +			         symbol__match_regex(al.sym, &blackbox_regex)) {
> > +				*root_al = al;
> > +				callchain_cursor_reset(&callchain_cursor);
> 
> Okay, this is where the magic happens. :)

Indeed! :)

> So it overwrites the original 'al' in process_sample_event() to
> blackboxed symbol and drop the callchain.  Wouldn't it deserve a
> comment? :)

I could do that.  Perhaps something like
  /* ignore the callchain we had so far, i.e. this symbol's callees */
Sound like what you had in mind?



> > +			}
> >  			if (!symbol_conf.use_callchain)
> >  				break;
> pp
> This is unrelated to this patch, but why is this line needed?  I guess
> this check should be done before calling this function.

Hmm.  We actually can get into this function when
!symbol_conf.use_callchain, if we're using say --sort=parent.  But I'm
still somewhat puzzled, because in that case it looks like we'll break
the loop after the first address with a symbol, even if we didn't find
the 'parent' there, which seems like it wouldn't serve the purpose.
Probably I'm still missing something.

FWIW, this logic has worked essentially the same way since v2.6.31-rc4~3^2~63.

Cheers,
Greg
