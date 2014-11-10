Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaKJU6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:58:30 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39034 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaKJU61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:58:27 -0500
Date: Mon, 10 Nov 2014 15:58:15 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joerg Roedel <joro@8bytes.org>,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 3/5] lib: lockless generic and arch independent page
 table (gpt) v2.
Message-ID: <20141110205814.GA4186@gmail.com>
References: <1415644096-3513-1-git-send-email-j.glisse@gmail.com>
 <1415644096-3513-4-git-send-email-j.glisse@gmail.com>
 <CA+55aFwHd4QYopHvd=H6hxoQeqDV3HT6=436LGU-FRb5A0p7Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwHd4QYopHvd=H6hxoQeqDV3HT6=436LGU-FRb5A0p7Vg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:22:03PM -0800, Linus Torvalds wrote:
> Ok, so things are somewhat calm, and I'm trying to take time off to
> see what's going on. And I'm not happy.
> 
> On Mon, Nov 10, 2014 at 10:28 AM,  <j.glisse@gmail.com> wrote:
> >
> > Page table is a common structure format most notably use by cpu mmu. The
> > arch depend page table code has strong tie to the architecture which makes
> > it unsuitable to be use by other non arch specific code.
> 
> Please don't call this thing a "generic page table".
> 
> It is no such thing. The *real* page tables are page tables. This is
> some kind of "mapping lookup", and has nothing to do with page tables
> as far as I can see. Why do you call it a page table?

I did this because intention is to use it to implement hardware page
table for different hardware (in my case AMD, NVidia). So it would be
use for real page table just not for cpu but for gpu.

Also during Linux Plumber people working on IOMMU expressed there wish to
see some generic "page table" code that can be share among IOMMU as most
IOMMU use a page table directory hierarchy for mapping and it is not the
same as the one use by the CPU.

Those are the two main reasons why i named it page table. It simply full
fill same role as CPU page table but for other hardware block and it tries
to do it in a generic way.

> 
> Also, why isn't this just using our *existing* generic mapping
> functionality, which already uses a radix tree, and has a lot of
> lockless models? We already *have* something like that, and it's
> called a "struct address_space".
> 
> And if you *just* want the tree, why don't you use "struct radix_tree_root".

struct radix_tree_root would not have fields i need to implement a generic
"page table" as i need callback from user to build page directory entry.

> 
> And if it's generic, why do you have that odd insane conditional
> locking going on?
> 

I am not sure to which locking you are refering to here. The design is
to allow concurrent readers and faulters to operate at same time. For
this i need reader to ignore newly faulted|created directory. So during
table walk done there is a bit of trickery to achieve just that.

> In other words, looking at this, I just go "this is re-implementing
> existing models, and uses naming that is actively misleading".
> 
> I think it's actively horrible, in other words. The fact that you have
> one ACK on it already makes me go "Hmm". Is there some actual reason
> why this would be called a page table, when even your explanation very
> much clarifies that it is explicitly written to *not* be an actual
> page table.
> 
> I also find it absolutely disgusting how you use USE_SPLIT_PTE_PTLOCKS
> for this, which seems to make absolutely zero sense. So you're sharing
> the config with the *real* page tables for no reason I can see.
> 

Update to page directory are synchronize through the spinlock of each
page backing a directory this is why i rely on that option. As explained
above i am trying to adapt the design of CPU page table to other hw page
table. The only difference is that the page directory entry and the page
table entry are different from the CPU and vary from one hw to the other.

I wanted to have generic code that can accomodate different hw at runtime
and not target one specific single CPU format at build time.

> I'm also looking at the "locking". It's insane. It's wrong, and
> doesn't have any serialization. Using the bit operations for locking
> is not correct. We've gotten over that years ago.

Bit operation are not use for locking at least not for inter-thread sync.
They are use for intra-thread synchronization because walk down of one
directory often needs to go over entry of one directory several times there
is a need to remember btw of those loop which entry inside the current
directory the current thread needs to care about. All the bit operations
are use only for that. Everything else is using the struct page spinlock
or global common spinlock and atomic to keep directory page alive.

All wlock are struct local to a thread and not share.

> 
> Rik, the fact that you acked this just makes all your other ack's be
> suspect. Did you do it just because it was from Red Hat, or do you do
> it because you like seeing Acked-by's with your name?
> 
> Anyway, this gets a NAK from me. Maybe I'm missing something, but I
> think naming is supremely important, and I really don't see the point
> of this. At a minimum, it needs a *hell* of a lot more explanations
> for all it does. And quite frankly, I don't think that will be
> sufficient, since the whole "bitops for locking" looks downright
> buggy, and it's not at all clear why you want this in the first place
> as opposed to just using gang lookups on the radix trees that we
> already have, and that is well-tested and known to scale fine.
> 
> So really, it boils down to: why is this any better than radix trees
> that are well-named, tested, and work?

I hope all the above help clarify my intention and i apologize for lack
of clarity in my commit message and in the code comment. I can include
the above motivation to make this clear.

If you still dislike me reusing the page table name i am open to any
suggestion for a better name. But in my mind this is really intended to
be use to implement hw specific page table and i would like to share
the guts of it among different hw and possibly with IOMMU folks too.

Thanks for taking time to look at this, much appreciated.

Cheers,
Jérôme

> 
>                 Linus
