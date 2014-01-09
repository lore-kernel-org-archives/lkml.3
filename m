Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaAICYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:24:38 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46373 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaAICYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:24:36 -0500
Date: Wed, 8 Jan 2014 18:24:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [PATCH] mm: slub: fix ALLOC_SLOWPATH stat
In-Reply-To: <20140106204300.DE79BA86@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1401081824170.15616@chino.kir.corp.google.com>
References: <20140106204300.DE79BA86@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Dave Hansen wrote:

> There used to be only one path out of __slab_alloc(), and
> ALLOC_SLOWPATH got bumped in that exit path.  Now there are two,
> and a bunch of gotos.  ALLOC_SLOWPATH can now get set more than once
> during a single call to __slab_alloc() which is pretty bogus.
> Here's the sequence:
> 
> 1. Enter __slab_alloc(), fall through all the way to the
>    stat(s, ALLOC_SLOWPATH);
> 2. hit 'if (!freelist)', and bump DEACTIVATE_BYPASS, jump to
>    new_slab (goto #1)
> 3. Hit 'if (c->partial)', bump CPU_PARTIAL_ALLOC, goto redo
>    (goto #2)
> 4. Fall through in the same path we did before all the way to
>    stat(s, ALLOC_SLOWPATH)
> 5. bump ALLOC_REFILL stat, then return
> 
> Doing this is obviously bogus.  It keeps us from being able to
> accurately compare ALLOC_SLOWPATH vs. ALLOC_FASTPATH.  It also
> means that the total number of allocs always exceeds the total
> number of frees.
> 
> This patch moves stat(s, ALLOC_SLOWPATH) to be called from the
> same place that __slab_alloc() is.  This makes it much less
> likely that ALLOC_SLOWPATH will get botched again in the
> spaghetti-code inside __slab_alloc().
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>
