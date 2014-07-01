Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbaGARqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:46:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:40990 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743AbaGARqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:46:21 -0400
Date: Tue, 1 Jul 2014 13:46:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: mm: memcontrol: rewrite uncharge API: problems
Message-ID: <20140701174612.GC1369@cmpxchg.org>
References: <alpine.LSU.2.11.1406301558090.4572@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406301558090.4572@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, Jun 30, 2014 at 04:55:10PM -0700, Hugh Dickins wrote:
> Hi Hannes,
> 
> Your rewrite of the memcg charge/uncharge API is bold and attractive,
> but I'm having some problems with the way release_pages() now does
> uncharging in I/O completion context.

Yes, I need to make the uncharge path IRQ-safe.  This looks doable.

> At the bottom see the lockdep message I get when I start shmem swapping.
> Which I have not begun to attempt to decipher (over to you!), but I do
> see release_pages() mentioned in there (also i915, hope it's irrelevant).

This seems to be about uncharge acquiring the IRQ-unsafe soft limit
tree lock while the outer release_pages() holds the IRQ-safe lru_lock.
A separate issue, AFAICS, that would also be fixed by IRQ-proofing the
uncharge path.

> Which was already worrying me on the PowerPC G5, when moving tasks from
> one memcg to another and removing the old, while swapping and swappingoff
> (I haven't tried much else actually, maybe it's much easier to reproduce).
> 
> I get "unable to handle kernel paging at 0x180" oops in __raw_spinlock <
> res_counter_uncharge_until < mem_cgroup_uncharge_end < release_pages <
> free_pages_and_swap_cache < tlb_flush_mmu_free < tlb_finish_mmu <
> unmap_region < do_munmap (or from exit_mmap < mmput < do_exit).
> 
> I do have CONFIG_MEMCG_SWAP=y, and I think 0x180 corresponds to the
> memsw res_counter spinlock, if memcg is NULL.  I don't understand why
> usually the PowerPC: I did see something like it once on this x86 laptop,
> maybe having lockdep in on this slows things down enough not to hit that.
> 
> I've stopped those crashes with patch below: the memcg_batch uncharging
> was never designed for use from interrupts.  But I bet it needs more work:
> to disable interrupts, or do something clever with atomics, or... over to
> you again.

I was convinced I had tested these changes with lockdep enabled, but
it must have been at an earlier stage while developing the series.
Otherwise, I should have gotten the same splat as you report.

Thanks for the report, I hope to have something useful ASAP.
