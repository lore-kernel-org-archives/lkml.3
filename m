Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3EUUKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:10:01 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53722 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3EUUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:09:59 -0400
Date: Tue, 21 May 2013 13:09:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sk_page_frag_refill OOM killing spree
In-Reply-To: <1369150280.3301.230.camel@edumazet-glaptop>
Message-ID: <alpine.DEB.2.02.1305211309100.31504@chino.kir.corp.google.com>
References: <20130521122845.GD16412@breakpoint.cc> <1369150280.3301.230.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013, Eric Dumazet wrote:

> On Tue, 2013-05-21 at 14:28 +0200, Florian Westphal wrote:
> > Hi Eric,
> > 
> > seems like sk_page_frag_refill() can cause oom-killer invocation:
> > 
> > postgres invoked oom-killer: gfp_mask=0x42d0, order=3, oom_score_adj=0
> > Pid: 10551, comm: postgres Tainted: G           O 3.8.6-5.g613ca40-smp #1
> > Call Trace:
> >  [<c106dbd5>] ? dump_header+0x60/0x191
> >  [<c1133d3a>] ? ___ratelimit+0xb2/0xc4
> >  [<c106dfd3>] ? oom_kill_process+0x61/0x2d1
> >  [<c1030042>] ? has_capability_noaudit+0x1c/0x23
> >  [<c106df0f>] ? oom_badness+0x8c/0xef
> >  [<c106e446>] ? out_of_memory+0x203/0x247
> >  [<c107128a>] ? __alloc_pages_nodemask+0x42b/0x4c3
> >  [<c11fa66a>] ? sk_page_frag_refill+0x6a/0xd2
> >  [<c1233548>] ? tcp_sendmsg+0x3e8/0x7c6
> >  [<c124f34b>] ? inet_sendmsg+0x6b/0x75
> >  [<c11f74d8>] ? sock_sendmsg+0x8d/0xa6
> >  [<c11f7b83>] ? sys_sendto+0x105/0x130
> >  [<c1025927>] ? __kunmap_atomic+0x62/0x8a
> >  [<c1025940>] ? __kunmap_atomic+0x7b/0x8a
> >  [<c1073d78>] ? __lru_cache_add+0x18/0x47
> >  [<c10812f9>] ? handle_pte_fault+0x745/0x751
> >  [<c1025a2d>] ? kmap_atomic_prot+0xd3/0xf1
> >  [<c10817da>] ? handle_mm_fault+0x112/0x121
> >  [<c11f7be5>] ? sys_send+0x37/0x3b
> > 
> > The system is busy, so, order-3 alloc failure doesn't strike me as odd.
> > 
> > There are no allocation failures with order != 3.
> > 
> > Sometimes this can happen in very short sucession, i.e.
> > and oom-killer did end up zapping 30 processes or so.
> > 

Aside from the __GFP_NORETRY issue, could you post the full oom killer log 
where it kills more than one process with /proc/sys/vm/oom_dump_tasks 
enabled?  That shouldn't happen unless you have a memory leak.
