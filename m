Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3LKWp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:45:28 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:36840 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:45:27 -0500
Date: Wed, 11 Dec 2013 14:45:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@gentwo.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] mm: slab/slub: use page->list consistently instead
 of page->lru
In-Reply-To: <20131211223631.51094A3D@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1312111443130.7354@chino.kir.corp.google.com>
References: <20131211223631.51094A3D@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> 'struct page' has two list_head fields: 'lru' and 'list'.
> Conveniently, they are unioned together.  This means that code
> can use them interchangably, which gets horribly confusing like
> with this nugget from slab.c:
> 
> >	list_del(&page->lru);
> >	if (page->active == cachep->num)
> >		list_add(&page->list, &n->slabs_full);
> 
> This patch makes the slab and slub code use page->list
> universally instead of mixing ->list and ->lru.
> 
> It also adds some comments to attempt to keep new users from
> picking up uses of ->list.
> 
> So, the new rule is: page->list is what the slabs use.  page->lru
> is for everybody else.  This is a pretty arbitrary rule, but we
> need _something_.  Maybe we should just axe the ->list one and
> make the sl?bs use ->lru.
> 

I'd recommend this suggestion, I don't see why the slab allocators can't 
use a page->lru field to maintain their lists of slab pages and it makes 
the code much cleaner.  Anybody hacking thise code will know it's not 
really a lru and we're just reusing a field from struct page without 
adding unnecessary complexity.
