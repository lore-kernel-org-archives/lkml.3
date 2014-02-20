Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaBTWXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaBTWXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:23:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
References: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        akpm <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Has slab ctor operation changed? -- was [PATCH 1/1] afs: afs_alloc_inode: use kmem_cache_zalloc
Date: Thu, 20 Feb 2014 22:23:15 +0000
Message-ID: <32740.1392934995@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabian Frederick <fabf@skynet.be> wrote:

> afs_vnode is currently cleared with 2 memsets after allocation and 
> 1 in constructor (afs_i_init_once).
> 	-This patch calls zalloc for explicit zero fill.

Ummm...  This patch isn't necessarily correct in the substantiative portions.

Since afs_i_init_once() is called by the slab allocator during the course of
kmem_cache_alloc(), how does kmem_cache_zalloc() interact with that?

IIRC, it used to be that the ctor() function was called when the pages were
allocated to the slab - and it wasn't called again, even if the object was
allocated, deallocated and reallocated.  This means that things like locks and
lists don't need reinitialising after allocation.

So afs_i_init_once() theoretically constructs the stuff that can be reused,
and afs_alloc_inode() therefore has to clear the non-reusable state.

Of course, it's possible that the slab allocator no longer works like this...

David
