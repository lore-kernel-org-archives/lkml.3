Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbaLHSiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:38:20 -0500
Received: from smtpauth15.mfg.siteprotect.com ([64.26.60.147]:49029 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756181AbaLHSiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:38:17 -0500
Date: Mon, 8 Dec 2014 13:39:43 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Linux 3.18 released
In-Reply-To: <CA+55aFwK3XtS32iJna-2uXZUfZQNUGC0Z4FmEFHK4JXB_kyojA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1412081331580.28373@pianoman.cluster.toy>
References: <CA+55aFwK3XtS32iJna-2uXZUfZQNUGC0Z4FmEFHK4JXB_kyojA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.5485F021.01D6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2014, Linus Torvalds wrote:

> I'd love to say that we've figured out the problem that plagues 3.17
> for a couple of people, but we haven't. At the same time, there's
> absolutely no point in having everybody else twiddling their thumbs
> when a couple of people are actively trying to bisect an older issue,
> so holding up the release just didn't make sense. Especially since
> that would just have then held things up entirely over the holiday
> break.
> 
> So the merge window for 3.19 is open, and DaveJ will hopefully get his
> bisection done (or at least narrow things down sufficiently that we
> have that "Ahaa" moment) over the next week. But in solidarity with
> Dave (and to make my life easier too ;) let's try to avoid introducing
> any _new_ nasty issues, ok?

It's probably unrelated to DaveJ's issue, but my perf_event fuzzer still 
quickly locks the kernel pretty solid on 3.18.

Just 5 minutes of testing managed to trip over the following issue that 
dates back to at least 3.15-rc7

My notes say last time I tracked down the issue as so:

  What happens is in kernel/core/events.c  find_get_context()
  somehow perf_lock_task_context() returns NULL 
  due to !atomic_inc_not_zero(&ctx->refcount)
  but task->perf_event_ctxp[ctxn] still has a valid value.

There are multiple perf related issues like this that are hard to track 
down.  They are borderline heisenbugs that are possibly race conditions, 
so bisecting doesn't work and even things like enablibg ftrace will make 
the issue go away (or crash ftrace itself).

This particular manifestation of the bug (or bugs) wedges things but I can 
use alt-sysrq from the serial console to see where it is stuck (see 
below; the CPU is stuck in a loop).


[ 2225.916004]  [<ffffffff810e61e9>] ? get_page_from_freelist+0x55/0x781
[ 2225.916004]  [<ffffffff810e6a7c>] __alloc_pages_nodemask+0x167/0x6dc
[ 2225.916004]  [<ffffffff8101a4a3>] ? intel_pmu_enable_all+0x28/0xa4
[ 2225.916004]  [<ffffffff8111f0b3>] kmem_getpages+0x58/0xec
[ 2225.916004]  [<ffffffff81120278>] cache_grow+0xad/0x1d8
[ 2225.916004]  [<ffffffff81120021>] ____cache_alloc+0x237/0x2ce
[ 2225.916004]  [<ffffffff811216b9>] __kmalloc+0x8f/0xf2
[ 2225.916004]  [<ffffffff810dc35d>] ? T.1336+0xe/0x10
[ 2225.916004]  [<ffffffff810dc35d>] T.1336+0xe/0x10
[ 2225.916004]  [<ffffffff810dc8ca>] alloc_perf_context+0x20/0x51
[ 2225.916004]  [<ffffffff810dca33>] find_get_context+0x138/0x1c7
[ 2225.916004]  [<ffffffff810dd029>] SYSC_perf_event_open+0x48b/0x870
[ 2225.916004]  [<ffffffff810dd41c>] SyS_perf_event_open+0xe/0x10
[ 2225.916004]  [<ffffffff81560016>] system_call_fastpath+0x16/0x1b

[ 2256.708004]  [<ffffffff810d7e36>] ? put_ctx+0x40/0x61
[ 2256.708004]  [<ffffffff810dcaa4>] find_get_context+0x1a9/0x1c7
[ 2256.708004]  [<ffffffff810dd029>] SYSC_perf_event_open+0x48b/0x870
[ 2256.708004]  [<ffffffff810dd41c>] SyS_perf_event_open+0xe/0x10
[ 2256.708004]  [<ffffffff81560016>] system_call_fastpath+0x16/0x1b

[ 2303.796003]  [<ffffffff810fa6cb>] ? kmalloc_slab+0x7f/0x8d
[ 2303.796003]  [<ffffffff81121653>] __kmalloc+0x29/0xf2
[ 2303.796003]  [<ffffffff810dc35d>] ? T.1336+0xe/0x10
[ 2303.796003]  [<ffffffff810dc35d>] T.1336+0xe/0x10
[ 2303.796003]  [<ffffffff810dc8ca>] alloc_perf_context+0x20/0x51
[ 2303.796003]  [<ffffffff810dca33>] find_get_context+0x138/0x1c7
[ 2303.796003]  [<ffffffff810dd029>] SYSC_perf_event_open+0x48b/0x870
[ 2303.796003]  [<ffffffff810dd41c>] SyS_perf_event_open+0xe/0x10
[ 2303.796003]  [<ffffffff81560016>] system_call_fastpath+0x16/0x1b

Vince
