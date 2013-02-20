Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3BTFTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:19:30 -0500
Received: from rydia.net ([69.46.88.68]:60600 "EHLO mail.rydia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3BTFT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:19:29 -0500
Date: Tue, 19 Feb 2013 21:19:27 -0800 (PST)
From: dormando <dormando@rydia.net>
X-X-Sender: dormando@dflat
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "hughd@google.com" <hughd@google.com>
Subject: Re: [PATCH] add extra free kbytes tunable
In-Reply-To: <20130219152936.f079c971.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1302192100100.23162@dflat>
References: <alpine.DEB.2.02.1302111734090.13090@dflat> <A5ED84D3BB3A384992CBB9C77DEDA4D414A98EBF@USINDEM103.corp.hds.com> <511EB5CB.2060602@redhat.com> <alpine.DEB.2.02.1302171546120.10836@dflat> <20130219152936.f079c971.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> The problem is that adding this tunable will constrain future VM
> implementations.  We will forever need to at least retain the
> pseudo-file.  We will also need to make some effort to retain its
> behaviour.
>
> It would of course be better to fix things so you don't need to tweak
> VM internals to get acceptable behaviour.

I sympathize with this. It's presently all that keeps us afloat though.
I'll whine about it again later if nothing else pans out.

> You said:
>
> : We have a server workload wherein machines with 100G+ of "free" memory
> : (used by page cache), scattered but frequent random io reads from 12+
> : SSD's, and 5gbps+ of internet traffic, will frequently hit direct reclaim
> : in a few different ways.
> :
> : 1) It'll run into small amounts of reclaim randomly (a few hundred
> : thousand).
> :
> : 2) A burst of reads or traffic can cause extra pressure, which kswapd
> : occasionally responds to by freeing up 40g+ of the pagecache all at once
> : (!) while pausing the system (Argh).
> :
> : 3) A blip in an upstream provider or failover from a peer causes the
> : kernel to allocate massive amounts of memory for retransmission
> : queues/etc, potentially along with buffered IO reads and (some, but not
> : often a ton) of new allocations from an application. This paired with 2)
> : can cause the box to stall for 15+ seconds.
>
> Can we prioritise these?  2) looks just awful - kswapd shouldn't just
> go off and free 40G of pagecache.  Do you know what's actually in that
> pagecache?  Large number of small files or small number of (very) large
> files?

We have a handful of huge files (6-12ish 200g+) that are mmap'ed and
accessed via address. occasionally madvise (WILLNEED) applied to the
address ranges before attempting to use them. There're a mix of other
files but nothing significant. The mmap's are READONLY and writes are done
via pwrite-ish functions.

I could use some guidance on inspecting/tracing the problem. I've been
trying to reproduce it in a lab, and respecting to 2)'s issue I've found:

- The amount of memory freed back up is either a percentage of total
memory or a percentage of free memory. (a machine with 48G of ram will
"only" free up an extra 4-7g)

- It's most likely to happen after a fresh boot, or if "3 > drop_caches"
is applied with the application down. As it fills it seems to get itself
into trouble, but becomes more stable after that. Unfortunately 1) and 3)
still apply to a stable instance.

- Protecting the DMA32 zone with something like "1 1 32" into
lowmem_reserve_ratio makes the mass-reclaiming less likely to happen.

- While watching "sar -B 1" I'll see kswapd wake up, and scan up to a few
hundred thousand pages before finding anything it actually wants to
reclaim (low vmeff). I've only been able to reproduce this from a clean
start. It can take up to 3 seconds before kswapd starts actually
reclaiming pages.

- So far as I can tell we're almost exclusively using 0 order allocations.
THP is disabled.

There's not much dirty memory involved. It's not flushing out writes while
reclaiming, it just kills off massive amount of cached memory.

We're not running the machines particularily hard... Often less than 30%
CPU usage at peak.
