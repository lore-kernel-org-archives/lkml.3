Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269Ab3IEMmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:42:50 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38197 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3IEMmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:42:49 -0400
Date: Thu, 5 Sep 2013 14:42:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.12
Message-ID: <20130905124242.GB20519@somewhere>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFyyJpCC0EFfPpGYi+6goWbA+LZbrkFcLNW3x8xYHfKvdQ@mail.gmail.com>
 <20130905105639.GB21407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130905105639.GB21407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 12:56:39PM +0200, Ingo Molnar wrote:
> 
> (Cc:-ed Frederic and Namhyung as well, it's about bad overhead in 
> tools/perf/util/hist.c.)
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, Sep 3, 2013 at 6:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > Please pull the latest perf-core-for-linus git tree from:
> > 
> > I don't think this is new at all, but I just tried to do a perf
> > record/report of "make -j64 test" on git:
> > 
> > It's a big perf.data file (1.6G), but after it has done the
> > "processing time ordered events" thing it results in:
> > 
> > ┌─Warning:───────────────────────────────────┐
> > │Processed 8672030 events and lost 71 chunks!│
> > │Check IO/CPU overload!                      │
> > │                                            │
> > │                                            │
> > │Press any key...                            │
> > └────────────────────────────────────────────┘
> > 
> > and then it just hangs using 100% CPU time. Pressing any key doesn't
> > do anything.
> > 
> > It may well still be *doing* something, and maybe it will come back
> > some day with results. But it sure doesn't show any indication that it
> > will.
> > 
> > Try this (in a current git source tree: note, by "git" I actually mean
> > git itself, not some random git repository)::
> > 
> >     perf record -g -e cycles:pp make -j64 test >& out
> >     perf report
> > 
> > maybe you can reproduce it.
> 
> I managed to reproduce it on a 32-way box via:
> 
>      perf record -g make -j64 bzImage >/dev/null 2>&1
> 
> It's easier to debug it without the TUI:
> 
>      perf --no-pages report --stdio
> 
> It turns out that even with a 400 MB perf.data the 'perf report' call will 
> eventually finish - here it ran for almost half an hour(!) on a fast box.
> 
> Arnaldo, the large overhead is in hists__collapse_resort(), in particular 
> it's doing append_chain_children() 99% of the time:
> 
> -  99.74%  perf  perf               [.] append_chain_children                                                         ◆
>    - append_chain_children                                                                                            ▒
>       - 99.76% merge_chain_branch                                                                                     ▒
>          - merge_chain_branch                                                                                         ▒
>             + 98.04% hists__collapse_resort                                                                           ▒
>             + 1.96% merge_chain_branch                                                                                ▒
> +   0.05%  perf  perf               [.] merge_chain_branch                                                            ▒
> +   0.03%  perf  libc-2.17.so       [.] _int_free                                                                     ▒
> +   0.03%  perf  libc-2.17.so       [.] __libc_calloc                                                                 ▒
> +   0.02%  perf  [kernel.kallsyms]  [k] account_user_time                                                             ▒
> +   0.02%  perf  libc-2.17.so       [.] _int_malloc                                                                   ▒
> 
> It seems to be stuck in hists__collapse_resort().
> 
> In particular the overhead arises because the following loop in 
> append_chain_children():
> 
>         /* lookup in childrens */
>         chain_for_each_child(rnode, root) {
>                 unsigned int ret = append_chain(rnode, cursor, period);
> 
> Reaches very long counts and the algorithm gets quadratic (at least). The 
> child count reaches over 100,000 entries in the end (!).
> 
> I don't think the high child count in itself is anomalous: a kernel build 
> generates thousands of processes, tons of symbol ranges and tens of 
> millions of call chain entries.
> 
> So I think what we need here is to speed up the lookup: put children into 
> a secondary, ->pos,len indexed range-rbtree and do a binary search instead 
> of a linear search over 100,000 child entries ... or something like that.

You're right it's worth trying.

At least it might give better results for such high scale callchain trees.
I'll see what I can come up with.

> 
> Btw., a side note, append_chain() is a rather confusing function in 
> itself, with logic-inversion gems like:
> 
>                 if (!found)
>                         found = true;

The check is pointless yeah, I'll remove that.

> 
> All that should be cleaned up as well I guess.
> 
> The 'IO overload' message appears to be a separate, unrelated bug, it just 
> annoyingly does not get refreshed away in the TUI before 
> hists__collapse_resort() is called, and there's also no progress bar for 
> the hists__collapse_resort() pass, so to the user it all looks like a 
> deadlock.
> 
> So there's at least two bugs here:
> 
>   - the bad overhead in hists__collapse_resort()
> 
>   - bad usability if hists__collapse_resort() takes more than 1 second to finish

Also IIUC, collapsing/merging hists is only used for comm hists merging, due to
set_task_comm after exec.

Perhaps we can do better to anticipate the comm of a process based on tid/pid, fork
and comm events? This way we can avoid late collapses/merges. In the best case we
could get rid of collapses entirely and that would be some nice fresh air for util/hist.c

And ideally, the comm should be associated to a lifetime as a thread can change
its comm anytime.

At least we should be able to limit collapses significantly.
I can try to make callchains more scalable, but collapsing is a heavy weight operation
for them in any case.

> Thanks,
> 
> 	Ingo
