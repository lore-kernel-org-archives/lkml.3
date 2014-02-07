Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaBGUwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:52:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaBGUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:52:34 -0500
Date: Fri, 7 Feb 2014 12:52:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2014-02-05 list_lru_add lockdep splat
Message-Id: <20140207125233.4b84482453da6a656ff427dd@linux-foundation.org>
In-Reply-To: <20140206164136.GC6963@cmpxchg.org>
References: <alpine.LSU.2.11.1402051944210.27326@eggly.anvils>
	<20140206164136.GC6963@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014 11:41:36 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> 
> Make the shadow lru->node[i].lock IRQ-safe to remove the order
> dictated by interruption.  This slightly increases the IRQ-disabled
> section in the shadow shrinker, but it still drops all locks and
> enables IRQ after every reclaimed shadow radix tree node.
> 
> ...
>
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -273,7 +273,10 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
>  	unsigned long max_nodes;
>  	unsigned long pages;
>  
> +	local_irq_disable();
>  	shadow_nodes = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
> +	local_irq_enable();

This is a bit ugly-looking.

A reader will look at that and wonder why the heck we're disabling
interrupts here.  Against what?  Is there some way in which we can
clarify this?

Perhaps adding list_lru_count_node_irq[save] and
list_lru_walk_node_irq[save] would be better - is it reasonable to
assume this is the only caller of the list_lru code which will ever
want irq-safe treatment?

This is all somewhat a side-effect of list_lru implementing its own
locking rather than requiring caller-provided locking.  It's always a
mistake.

