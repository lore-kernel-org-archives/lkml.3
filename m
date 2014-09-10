Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaIJCrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:47:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59986 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaIJCrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:47:15 -0400
Date: Tue, 9 Sep 2014 19:45:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
In-Reply-To: <540F7D42.1020402@oracle.com>
Message-ID: <alpine.LSU.2.11.1409091903390.10989@eggly.anvils>
References: <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de> <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de> <540F7D42.1020402@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Sasha Levin wrote:
> On 09/09/2014 05:33 PM, Mel Gorman wrote:
> > On Mon, Sep 08, 2014 at 01:56:55PM -0400, Sasha Levin wrote:
> >> On 09/08/2014 01:18 PM, Mel Gorman wrote:
> >>> A worse possibility is that somehow the lock is getting corrupted but
> >>> that's also a tough sell considering that the locks should be allocated
> >>> from a dedicated cache. I guess I could try breaking that to allocate
> >>> one page per lock so DEBUG_PAGEALLOC triggers but I'm not very
> >>> optimistic.
> >>
> >> I did see ptl corruption couple days ago:
> >>
> >> 	https://lkml.org/lkml/2014/9/4/599
> >>
> >> Could this be related?
> >>
> > 
> > Possibly although the likely explanation then would be that there is
> > just general corruption coming from somewhere. Even using your config
> > and applying a patch to make linux-next boot (already in Tejun's tree)
> > I was unable to reproduce the problem after running for several hours. I
> > had to run trinity on tmpfs as ext4 and xfs blew up almost immediately
> > so I have a few questions.
> 
> I agree it could be a case of random corruption somewhere else, it's just
> that the amount of times this exact issue reproduced

Yes, I doubt it's random corruption; but I've been no more successful
than Mel in working it out (I share responsibility for that VM_BUG_ON).

Sasha, you say you're getting plenty of these now, but I've only seen
the dump for one of them, on Aug26: please post a few more dumps, so
that we can look for commonality.

And please attach a disassembly of change_protection_range() (noting
which of the dumps it corresponds to, in case it has changed around):
"Code" just shows a cluster of ud2s for the unlikely bugs at end of the
function, we cannot tell at all what should be in the registers by then.

I've been rather assuming that the 9d340902 seen in many of the
registers in that Aug26 dump is the pte val in question: that's
SOFT_DIRTY|PROTNONE|RW.

I think RW on PROTNONE is unusual but not impossible (migration entry
replacement racing with mprotect setting PROT_NONE, after it's updated
vm_page_prot, before it's reached the page table).  But exciting though
that line of thought is, I cannot actually bring it to a pte_mknuma bug,
or any bug at all.

Mel, no way can it be the cause of this bug - unless Sasha's later
traces actually show a different stack - but I don't see the call
to change_prot_numa() from queue_pages_range() sharing the same
avoidance of PROT_NONE that task_numa_work() has (though it does
have an outdated comment about PROT_NONE which should be removed).
So I think that site probably does need PROT_NONE checking added.

Hugh
