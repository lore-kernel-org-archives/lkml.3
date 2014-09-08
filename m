Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIHOqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaIHOqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:46:19 -0400
Date: Mon, 8 Sep 2014 10:46:03 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        kkolasa@winsoft.pl, dm-devel@redhat.com
Subject: Re: [PATCH] slab: implement kmalloc guard
In-Reply-To: <alpine.DEB.2.11.1409080932490.20388@gentwo.org>
Message-ID: <alpine.LRH.2.02.1409081041160.29432@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409051833510.9790@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.11.1409080932490.20388@gentwo.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2014, Christoph Lameter wrote:

> On Fri, 5 Sep 2014, Mikulas Patocka wrote:
> 
> > This patch adds a new option DEBUG_KMALLOC that makes it possible to
> > detect writes beyond the end of space allocated with kmalloc. Normally,
> > the kmalloc function rounds the size to the next power of two (there is
> > exception to this rule - sizes 96 and 192). Slab debugging detects only
> > writes beyond the end of the slab object, it is unable to detect writes
> > beyond the end of kmallocated size that fit into the slab object.
> >
> > The motivation for this patch was this: There was 6 year old bug in
> > dm-crypt (d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed) where the driver would
> > write beyond the end of kmallocated space, but the bug went undetected
> > because the write would fit into the power-of-two-sized slab object. Only
> > recent changes to dm-crypt made the bug show up. There is similar problem
> > in the nx-crypto driver in the function nx_crypto_ctx_init - again,
> > because kmalloc rounds the size up to the next power of two, this bug went
> > undetected.
> 
> The problem with the kmalloc array for debugging is inded that it is
> only for powers of two for efficiency purposes. In the debug
> situation we may not have the need for that efficiency. Maybe simply
> creating kmalloc arrays for each size will do the trick?

I don't know what you mean. If someone allocates 10000 objects with sizes 
from 1 to 10000, you can't have 10000 slab caches - you can't have a slab 
cache for each used size. Also - you can't create a slab cache in 
interrupt context.

> > This patch works for slab, slub and slob subsystems. The end of slab block
> > can be found out with ksize (this patch renames it to __ksize). At the end
> > of the block, we put a structure kmalloc_guard. This structure contains a
> > magic number and a real size of the block - the exact size given to
> 
> We already have a redzone structure to check for writes over the end of
> the object. Lets use that.

So, change all three slab subsystems to use that.

Mikulas
