Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3HNNFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:05:31 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:49194 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab3HNNFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:05:30 -0400
Date: Wed, 14 Aug 2013 09:05:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130814130526.GA28628@htj.dyndns.org>
References: <520AAF9C.1050702@tilera.com>
 <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
 <20130813232904.GJ28996@mtj.dyndns.org>
 <520AC215.4050803@tilera.com>
 <20130813234629.4ce2ec70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813234629.4ce2ec70.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 11:46:29PM -0700, Andrew Morton wrote:
> What does "nest" mean?  lru_add_drain_all() calls itself recursively,
> presumably via some ghastly alloc_percpu()->alloc_pages(GFP_KERNEL)
> route?  If that ever happens then we'd certainly want to know about it.
> Hopefully PF_MEMALLOC would prevent infinite recursion.
> 
> If "nest" means something else then please enlighten me!
> 
> As for "doing it simultaneously", I assume we're referring to
> concurrent execution from separate threads.  If so, why would that "buy
> us anything"?  Confused.  As long as each thread sees "all pages which
> were in pagevecs at the time I called lru_add_drain_all() get spilled
> onto the LRU" then we're good.  afaict the implementation will do this.

I was wondering whether we can avoid all allocations by just
pre-allocating all resources.  If it can't call itself if we get rid
of all allocations && running multiple instances of them doesn't buy
us anything, the best solution would be allocating work items
statically and synchronize their use using a mutex.  That way the
whole thing wouldn't need any allocation.

Thanks.

-- 
tejun
