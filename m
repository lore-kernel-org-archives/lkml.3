Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaABWD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:03:58 -0500
Received: from mail-gg0-f180.google.com ([209.85.161.180]:39645 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:03:57 -0500
Date: Thu, 2 Jan 2014 14:03:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Grygorii Strashko <grygorii.strashko@ti.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, akpm@linux-foundation.org,
        tj@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as
 input parameter
In-Reply-To: <52C1635D.9070703@ti.com>
Message-ID: <alpine.DEB.2.02.1401021400160.21537@chino.kir.corp.google.com>
References: <1387578536-18280-1-git-send-email-santosh.shilimkar@ti.com> <alpine.DEB.2.02.1312261542260.9342@chino.kir.corp.google.com> <52C1635D.9070703@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Grygorii Strashko wrote:

> > > diff --git a/mm/memblock.c b/mm/memblock.c
> > > index 71b11d9..6af873a 100644
> > > --- a/mm/memblock.c
> > > +++ b/mm/memblock.c
> > > @@ -707,11 +707,9 @@ void __init_memblock __next_free_mem_range(u64 *idx,
> > > int nid,
> > >   	struct memblock_type *rsv = &memblock.reserved;
> > >   	int mi = *idx & 0xffffffff;
> > >   	int ri = *idx >> 32;
> > > -	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
> > > 
> > > -	if (nid == MAX_NUMNODES)
> > > -		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use
> > > NUMA_NO_NODE instead\n",
> > > -			     __func__);
> > > +	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is
> > > deprecated. Use NUMA_NO_NODE instead\n"))
> > > +		nid = NUMA_NO_NODE;
> > > 
> > >   	for ( ; mi < mem->cnt; mi++) {
> > >   		struct memblock_region *m = &mem->regions[mi];
> > 
> > Um, why do this at runtime?  This is only used for
> > for_each_free_mem_range(), which is used rarely in x86 and memblock-only
> > code.  I'm struggling to understand why we can't deterministically fix the
> > callers if this condition is possible.
> > 
> 
> 
> Unfortunately, It's not so simple as from first look :(
> We've modified __next_free_mem_range_x() functions which are part of
> Memblock APIs (like memblock_alloc_xxx()) and Nobootmem APIs.
> These APIs are used as directly as indirectly (as part of callbacks from other
> MM modules like Sparse), as result, it's not trivial to identify all places
> where MAX_NUMNODES will be used as input parameter.
> 

These functions are only used for for_each_free_mem_range() and 
for_each_free_mem_range_reverse().  I can very easily find which callers 
are passing MAX_NUMNODES deterministically.

NACK to doing this at runtime.
