Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaBEVT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:19:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39092 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752560AbaBEVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:19:54 -0500
Date: Wed, 5 Feb 2014 16:19:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
Message-ID: <20140205161952.781e3a0e@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com>
	<1391588133-15469-1-git-send-email-vdavydov@parallels.com>
	<20140205195837.GA6857@home.goodmis.org>
	<alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com>
	<20140205155840.43d6b4ad@gandalf.local.home>
	<alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 13:07:05 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> The functions that manipulate the partial lists was modified by 
> c65c1877bd68 ("slub: use lockdep_assert_held") which replaced commentary 
> with runtime checking on debug kernels with lockdep enabled.  I'm not sure 
> adding more code to do the remove_partial() and __remove_partial() variant 
> is the right solution to just bypass the check; if anything, I think we 
> should accept the fact that the comment should have been "requires 
> n->list_lock if the slab cache can be accessed by other cpus" that makes 
> it clear we don't need it for init and destroy paths.

Then add the comment that clears this up. But lets not add spinlocks
just to quiet something if they truly are not needed.

We use "__" variants all the time. That's really not extra code.

Heck, if you want, call it remove_freed_partial() that shows that this
version skips the check because it is freed.

And if you don't want to have remove_freed_partial() being called by
remove_partial() than still keep the "__" variant, add a
"__always_inline" to it, and then do:

static __always_inline
__remove_partial(struct kmem_cache_node *n, struct page *page)
{
        list_del(&page->lru);
        n->nr_partial--;
}

static inline remove_partial(struct kmem_cache_node *n,
                             struct page *page)
{
        lockdep_assert_held(&n->list_lock);
        __remove_partial(n, page);
}


static inline remove_freed_partial(struct kmem_cache_node *n,
                             struct page *page)
{
        __remove_partial(n, page);
}

The naming like this documents itself.

-- Steve

