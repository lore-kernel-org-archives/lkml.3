Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaBEVZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:25:43 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44082 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaBEVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:25:41 -0500
Date: Wed, 5 Feb 2014 13:25:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140205161952.781e3a0e@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1402051324370.14325@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <20140205195837.GA6857@home.goodmis.org> <alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com> <20140205155840.43d6b4ad@gandalf.local.home>
 <alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com> <20140205161952.781e3a0e@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> Then add the comment that clears this up. But lets not add spinlocks
> just to quiet something if they truly are not needed.
> 
> We use "__" variants all the time. That's really not extra code.
> 
> Heck, if you want, call it remove_freed_partial() that shows that this
> version skips the check because it is freed.
> 
> And if you don't want to have remove_freed_partial() being called by
> remove_partial() than still keep the "__" variant, add a
> "__always_inline" to it, and then do:
> 
> static __always_inline
> __remove_partial(struct kmem_cache_node *n, struct page *page)
> {
>         list_del(&page->lru);
>         n->nr_partial--;
> }
> 
> static inline remove_partial(struct kmem_cache_node *n,
>                              struct page *page)
> {
>         lockdep_assert_held(&n->list_lock);
>         __remove_partial(n, page);
> }
> 
> 
> static inline remove_freed_partial(struct kmem_cache_node *n,
>                              struct page *page)
> {
>         __remove_partial(n, page);
> }
> 
> The naming like this documents itself.
> 

Looks like you've got something prepared already!  Mind sending it to 
Pekka as a patch based on linux-next?
