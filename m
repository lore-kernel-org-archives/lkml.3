Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaFJEgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:36:42 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46778 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaFJEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:36:41 -0400
Date: Mon, 9 Jun 2014 21:35:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>, suresh.b.siddha@intel.com,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm,x86: warning at arch/x86/mm/pat.c:781
 untrack_pfn+0x65/0xb0()
In-Reply-To: <5393D995.8010805@oracle.com>
Message-ID: <alpine.LSU.2.11.1406092127180.1505@eggly.anvils>
References: <5347E4FB.2090705@oracle.com> <5393D995.8010805@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Sasha Levin wrote:
> On 04/11/2014 08:50 AM, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel I've stumbled on the following:
> 
> Ping? Still happening (rarely on -next):
> 
> [ 5818.038245] WARNING: CPU: 4 PID: 22726 at arch/x86/mm/pat.c:781 untrack_pfn+0x65/0xb0()
> [ 5818.044203] Modules linked in:
> [ 5818.045172] CPU: 4 PID: 22726 Comm: trinity-c239 Tainted: G        W     3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #596
> [ 5818.048317]  0000000000000009 ffff8800024d3be8 ffffffff9e50fe6b 0000000000000001
> [ 5818.050516]  0000000000000000 ffff8800024d3c28 ffffffff9b15f96c ffff8800024d3c38
> [ 5818.052567]  ffff88000203f400 0000000000000000 ffff8800024d3d68 ffff8800024d3d68
> [ 5818.053785] Call Trace:
> [ 5818.054483] dump_stack (lib/dump_stack.c:52)
> [ 5818.055586] warn_slowpath_common (kernel/panic.c:430)
> [ 5818.056763] warn_slowpath_null (kernel/panic.c:465)
> [ 5818.057789] untrack_pfn (arch/x86/mm/pat.c:781 (discriminator 3))
> [ 5818.059412] unmap_single_vma (mm/memory.c:1327)
> [ 5818.061530] ? pagevec_lru_move_fn (include/linux/pagevec.h:44 mm/swap.c:435)
> [ 5818.063412] unmap_vmas (mm/memory.c:1377 (discriminator 1))
> [ 5818.064610] unmap_region (mm/mmap.c:2363 (discriminator 3))
> [ 5818.065453] ? validate_mm_rb (mm/mmap.c:404)
> [ 5818.066422] ? vma_rb_erase (mm/mmap.c:449 include/linux/rbtree_augmented.h:219 include/linux/rbtree_augmented.h:227 mm/mmap.c:488)
> [ 5818.067316] do_munmap (mm/mmap.c:3359 mm/mmap.c:2561)
> [ 5818.068126] move_vma (mm/mremap.c:313)
> [ 5818.069000] SyS_mremap (mm/mremap.c:446 mm/mremap.c:508 mm/mremap.c:477)
> [ 5818.069839] tracesys (arch/x86/kernel/entry_64.S:542)

I could easily be wrong, but I think of this one as another manifestation
of the filemap.c:202 BUG_ON(page_mapped(page)) bug, whatever that is.

In each case, we have a BUG or WARNING at the point where we detect that
there should have been a pte in a page table, but it somehow disappeared.

VM_PFNMAP in this case, an ordinary file mapping in the other case; and
nothing to show in the anonymous case, there the page would just leak.

Hugh
