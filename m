Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3KCJqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:46:36 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45696 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3KCJqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:46:34 -0500
Date: Sun, 3 Nov 2013 10:46:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131103094629.GA5330@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <5274114B.7010302@gmail.com>
 <1383340291.2653.33.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383340291.2653.33.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Fri, 2013-11-01 at 16:38 -0400, KOSAKI Motohiro wrote:
> > (11/1/13 4:17 PM), Davidlohr Bueso wrote:
> >
> > > While caching the last used vma already does a nice job avoiding 
> > > having to iterate the rbtree in find_vma, we can improve. After 
> > > studying the hit rate on a load of workloads and environments, it 
> > > was seen that it was around 45-50% - constant for a standard desktop 
> > > system (gnome3 + evolution + firefox + a few xterms), and multiple 
> > > java related workloads (including Hadoop/terasort), and aim7, which 
> > > indicates it's better than the 35% value documented in the code.
> > >
> > > By also caching the largest vma, that is, the one that contains most 
> > > addresses, there is a steady 10-15% hit rate gain, putting it above 
> > > the 60% region. This improvement comes at a very low overhead for a 
> > > miss. Furthermore, systems with !CONFIG_MMU keep the current logic.
> > 
> > I'm slightly surprised this cache makes 15% hit. Which application get 
> > a benefit? You listed a lot of applications, but I'm not sure which is 
> > highly depending on largest vma.
> 
> Well I chose the largest vma because it gives us a greater chance of 
> being already cached when we do the lookup for the faulted address.
> 
> The 15% improvement was with Hadoop. According to my notes it was at 
> ~48% with the baseline kernel and increased to ~63% with this patch.
> 
> In any case I didn't measure the rates on a per-task granularity, but at 
> a general system level. When a system is first booted I can see that the 
> mmap_cache access rate becomes the determinant factor and when adding a 
> workload it doesn't change much. One exception to this was a kernel 
> build, where we go from ~50% to ~89% hit rate on a vanilla kernel.

~90% during a kernel build is pretty impressive.

Still the ad-hoc nature of the caching worries me a bit - but I don't have 
any better ideas myself.

[I've Cc:-ed Linus, in case he has any better ideas.]

Thanks,

	Ingo
