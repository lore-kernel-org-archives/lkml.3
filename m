Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaBGUqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:46:23 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46553 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBGUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:46:21 -0500
Date: Fri, 7 Feb 2014 12:46:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gautham R Shenoy <ego@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org, penberg@kernel.org
Subject: Re: [PATCH] slub: Hold list_lock unconditionally before the call to
 add_full.
In-Reply-To: <20140207184653.GA5799@in.ibm.com>
Message-ID: <alpine.DEB.2.02.1402071245350.4212@chino.kir.corp.google.com>
References: <20140207184653.GA5799@in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Feb 2014, Gautham R Shenoy wrote:

> Hi,
> 
> From the lockdep annotation and the comment that existed before the
> lockdep annotations were introduced, 
> mm/slub.c:add_full(s, n, page) expects to be called with n->list_lock
> held.
> 
> However, there's a call path in deactivate_slab() when
> 
> 	 (new.inuse || n->nr_partial <= s->min_partial) &&
> 	 !(new.freelist) &&
>          !(kmem_cache_debug(s))
> 
> which ends up calling add_full() without holding
> n->list_lock.
> 
> This was discovered while onlining/offlining cpus in 3.14-rc1 due to
> the lockdep annotations added by commit
> c65c1877bd6826ce0d9713d76e30a7bed8e49f38.
> 
> Fix this by unconditionally taking the lock
> irrespective of the state of kmem_cache_debug(s).
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

No, it's not needed unless kmem_cache_debug(s) is actually set, 
specifically s->flags & SLAB_STORE_USER.

You want the patch at http://marc.info/?l=linux-kernel&m=139147105027693 
instead which is already in -mm and linux-next.
