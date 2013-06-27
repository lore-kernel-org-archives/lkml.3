Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3F0E6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:58:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49972 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3F0E6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:58:18 -0400
X-AuditID: 9c930179-b7cafae000004567-e9-51cbc6681e09
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
	<871u7p3bjb.fsf@sejong.aot.lge.com>
	<20130626222500.GZ22203@biohazard-cafe.mit.edu>
Date: Thu, 27 Jun 2013 13:58:16 +0900
In-Reply-To: <20130626222500.GZ22203@biohazard-cafe.mit.edu> (Greg Price's
	message of "Wed, 26 Jun 2013 18:25:01 -0400")
Message-ID: <87obas176f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 18:25:01 -0400, Greg Price wrote:
> Hi Namhyung,
>
> Thanks for the detailed review!
>
>
> On Wed, Jun 26, 2013 at 10:28:56AM +0900, Namhyung Kim wrote:
>> On Sat, 22 Jun 2013 23:17:20 -0400, Greg Price wrote:
>> > For example, in an application with an expensive function
>> > implemented with deeply nested recursive calls, the default
>> > call-graph presentation is dominated by the different callchains
>> > within that function.  By treating the function as a black box,
>> > we can collect the callchains leading into the function and
>> > compactly identify what to blame for expensive calls.
>> >
>> > For example, in this report the callers of garbage_collect() are
>> 
>> s/callers/callees/ ?
>
> No, 'callers' is right.  This report is made without -G/--inverted, so
> the trees are rooted at the inmost callees (the actual values of the
> IP) and each node's children are its callers, rather than vice versa.
> Here we want to see who is making these expensive calls to
> garbage_collect, but the answer to this question is obscured because
> the relevant callchains are separated according to which internal
> helper functions to garbage_collect were on the stack.
>
>
>> And it'd be better it shows more lines after garbage_collect so that one
>> can see its callers also to understand what it does more clearly.
>
> If you mean the commit message, the 'after' example that follows shows
> this.  In the actual output (without the 'grep -m10' I've used here)
> the patch doesn't affect those lines, and plenty more are in fact shown.
>
> I could make the 'before' example longer too, and then we'd see what
> the callers were in the callchains that look like
>   gc_mark <- mark_keyvalue <- st_foreach <- gc_mark_children
>     <- rb_gc_mark <- rb_vm_mark <- gc_mark_children <- gc_marks
>     <- garbage_collect <- (the rest of a callchain).
> But the callchains that have something else instead of that particular
> sequence of eight helper functions (gc_mark called by ... called by
> gc_marks) inside garbage_collect won't be included -- they're shown
> in other places in the tree.  So it's actually precisely by using this
> option that it's possible to see the callers completely, rather than
> scattered across many places.

Okay, I can see your point now.  Thanks for the explanation.


>> [SNIP]
>> > @@ -1211,8 +1214,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>> >  					   MAP__FUNCTION, ip, &al, NULL);
>> >  		if (al.sym != NULL) {
>> >  			if (sort__has_parent && !*parent &&
>> > -			    symbol__match_parent_regex(al.sym))
>> > +			    symbol__match_regex(al.sym, &parent_regex))
>> >  				*parent = al.sym;
>> > +			else if (have_blackbox && root_al &&
>> > +			         symbol__match_regex(al.sym, &blackbox_regex)) {
>> > +				*root_al = al;
>> > +				callchain_cursor_reset(&callchain_cursor);
>> 
>> Okay, this is where the magic happens. :)
>
> Indeed! :)
>
>> So it overwrites the original 'al' in process_sample_event() to
>> blackboxed symbol and drop the callchain.  Wouldn't it deserve a
>> comment? :)
>
> I could do that.  Perhaps something like
>   /* ignore the callchain we had so far, i.e. this symbol's callees */
> Sound like what you had in mind?

More important thing is, I think, it updates the original al (root_al)
so that the perf will see the new symbol as if it was sampled in the
first place and it will collect all of its callers in one place.

>
>
>> > +			}
>> >  			if (!symbol_conf.use_callchain)
>> >  				break;
>> pp
>> This is unrelated to this patch, but why is this line needed?  I guess
>> this check should be done before calling this function.
>
> Hmm.  We actually can get into this function when
> !symbol_conf.use_callchain, if we're using say --sort=parent.  But I'm
> still somewhat puzzled, because in that case it looks like we'll break
> the loop after the first address with a symbol, even if we didn't find
> the 'parent' there, which seems like it wouldn't serve the purpose.

Right, that's what I want to say.

We already have the check before calling this function so breaking the
loop after checking only first callchain node looks strange.  If we
don't want to see callchains but only parents, it should either check
every callchain nodes or fail out as an unsupported operation IMHO.

Thanks,
Namhyung


> Probably I'm still missing something.
>
> FWIW, this logic has worked essentially the same way since v2.6.31-rc4~3^2~63.
>
> Cheers,
> Greg
