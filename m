Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936588AbaBDXIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:08:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbaBDXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:07:59 -0500
Date: Tue, 4 Feb 2014 15:07:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Bob Liu <bob.liu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] mm: keep page cache radix tree nodes in check
Message-Id: <20140204150756.d7f46af4385026ce61c89c55@linux-foundation.org>
In-Reply-To: <1391475222-1169-11-git-send-email-hannes@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
	<1391475222-1169-11-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Feb 2014 19:53:42 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Previously, page cache radix tree nodes were freed after reclaim
> emptied out their page pointers.  But now reclaim stores shadow
> entries in their place, which are only reclaimed when the inodes
> themselves are reclaimed.  This is problematic for bigger files that
> are still in use after they have a significant amount of their cache
> reclaimed, without any of those pages actually refaulting.  The shadow
> entries will just sit there and waste memory.  In the worst case, the
> shadow entries will accumulate until the machine runs out of memory.
> 
> To get this under control, the VM will track radix tree nodes
> exclusively containing shadow entries on a per-NUMA node list.
> Per-NUMA rather than global because we expect the radix tree nodes
> themselves to be allocated node-locally and we want to reduce
> cross-node references of otherwise independent cache workloads.  A
> simple shrinker will then reclaim these nodes on memory pressure.
> 
> A few things need to be stored in the radix tree node to implement the
> shadow node LRU and allow tree deletions coming from the list:
> 
> 1. There is no index available that would describe the reverse path
>    from the node up to the tree root, which is needed to perform a
>    deletion.  To solve this, encode in each node its offset inside the
>    parent.  This can be stored in the unused upper bits of the same
>    member that stores the node's height at no extra space cost.
> 
> 2. The number of shadow entries needs to be counted in addition to the
>    regular entries, to quickly detect when the node is ready to go to
>    the shadow node LRU list.  The current entry count is an unsigned
>    int but the maximum number of entries is 64, so a shadow counter
>    can easily be stored in the unused upper bits.
> 
> 3. Tree modification needs tree lock and tree root, which are located
>    in the address space, so store an address_space backpointer in the
>    node.  The parent pointer of the node is in a union with the 2-word
>    rcu_head, so the backpointer comes at no extra cost as well.
> 
> 4. The node needs to be linked to an LRU list, which requires a list
>    head inside the node.  This does increase the size of the node, but
>    it does not change the number of objects that fit into a slab page.

changelog forgot to mention that this reclaim is performed via a
shrinker...

How expensive is that list walk in scan_shadow_nodes()?  I assume in
the best case it will bale out after nr_to_scan iterations?

