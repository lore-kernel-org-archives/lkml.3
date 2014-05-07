Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaEGV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:29:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaEGV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:29:27 -0400
Date: Wed, 7 May 2014 14:29:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, slab: suppress out of memory warning unless debug
 is enabled
Message-Id: <20140507142925.b0e31514d4cd8d5857b10850@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1405071418410.8389@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405071418410.8389@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 14:19:19 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> When the slab or slub allocators cannot allocate additional slab pages, they 
> emit diagnostic information to the kernel log such as current number of slabs, 
> number of objects, active objects, etc.  This is always coupled with a page 
> allocation failure warning since it is controlled by !__GFP_NOWARN.
> 
> Suppress this out of memory warning if the allocator is configured without debug 
> supported.  The page allocation failure warning will indicate it is a failed 
> slab allocation, so this is only useful to diagnose allocator bugs.
> 
> Since CONFIG_SLUB_DEBUG is already enabled by default for the slub allocator, 
> there is no functional change with this patch.  If debug is disabled, however, 
> the warnings are now suppressed.
> 

I'm not seeing any reason for making this change.

> @@ -1621,11 +1621,17 @@ __initcall(cpucache_init);
>  static noinline void
>  slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
>  {
> +#if DEBUG
>  	struct kmem_cache_node *n;
>  	struct page *page;
>  	unsigned long flags;
>  	int node;
>  
> +	if (gfpflags & __GFP_NOWARN)
> +		return;
> +	if (!printk_ratelimit())
> +		return;

printk_ratelimit() is lame - it uses a single global state.  So if
random net driver is using printk_ratelimit(), that driver and slab
will interfere with each other.

We don't appear to presently have a handy macro to do this properly -
you might care to add one and switch printk_ratelimited() and
pr_debug_ratelimited() over to using it.  And various sites in
include/linux/device.h, I guess.


