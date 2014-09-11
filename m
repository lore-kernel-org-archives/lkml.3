Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaIKLla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:41:30 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57349 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaIKLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:41:28 -0400
Date: Thu, 11 Sep 2014 04:39:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
In-Reply-To: <54110C62.4030702@oracle.com>
Message-ID: <alpine.LSU.2.11.1409110356280.2116@eggly.anvils>
References: <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de> <540127AC.4040804@oracle.com> <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de>
 <540F7D42.1020402@oracle.com> <alpine.LSU.2.11.1409091903390.10989@eggly.anvils> <20140910124732.GT17501@suse.de> <alpine.LSU.2.11.1409101210520.1744@eggly.anvils> <54110C62.4030702@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Sasha Levin wrote:
> On 09/10/2014 03:36 PM, Hugh Dickins wrote:
> > Right, and Sasha  reports that that can fire, but he sees the bug
> > with this patch in and without that firing.
> 
> I've changed that WARN_ON_ONCE() to a VM_BUG_ON_VMA() to get some useful
> VMA information out, and got the following:

Well, thanks, but Mel and I have both failed to perceive any actual
problem arising from that peculiarity.  And Mel's warning, and the 900s
in yesterday's dumps, have shown that it is not correlated with the
pte_mknuma() bug we are chasing.  So there isn't anything that I want to
look up in these vmas.  Or did you notice something interesting in them?

> And on a maybe related note, I've started seeing the following today. It may
> be because we fixed mbind() in trinity but it could also be related to

The fixed trinity may be counter-productive for now, since we think
there is an understandable pte_mknuma() bug coming from that direction,
but have not posted a patch for it yet.

> this issue (free_pgtables() is in the call chain). If you don't think it has
> anything to do with it let me know and I'll start a new thread:
> 
> [ 1195.996803] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 1196.001744] IP: __rb_erase_color (include/linux/rbtree_augmented.h:107 lib/rbtree.c:229 lib/rbtree.c:367)
> [ 1196.001744] Call Trace:
> [ 1196.001744] vma_interval_tree_remove (mm/interval_tree.c:24)
> [ 1196.001744] __remove_shared_vm_struct (mm/mmap.c:232)
> [ 1196.001744] unlink_file_vma (mm/mmap.c:246)
> [ 1196.001744] free_pgtables (mm/memory.c:547)
> [ 1196.001744] exit_mmap (mm/mmap.c:2826)
> [ 1196.001744] mmput (kernel/fork.c:654)
> [ 1196.001744] do_exit (./arch/x86/include/asm/thread_info.h:168 kernel/exit.c:461 kernel/exit.c:746)

I didn't study in any detail, but this one seems much more like the
zeroing and vma corruption that you've been seeing in other dumps.

Though a single pte_mknuma() crash could presumably be caused by vma
corruption (but I think not mere zeroing), the recurrent way in which
you hit that pte_mknuma() bug in particular makes it unlikely to be
caused by random corruption.

You are generating new crashes faster than we can keep up with them.
Would this be a suitable point for you to switch over to testing
3.17-rc, to see if that is as unstable for you as -next is?

That VM_BUG_ON(!(val & _PAGE_PRESENT)) is not in the 3.17-rc tree,
but I think you can "safely" add it to 3.17-rc.  Quotes around
"safely" meaning that we know that there's a bug to hit, at least
in -next, but I don't think it's going to be hit for stupid obvious
reasons.

And you're using a gcc 5 these days?  That's another variable to
try removing from the mix, to see if it makes a difference.

Hugh
