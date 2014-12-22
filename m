Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaLVWMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:12:14 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:43132 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaLVWMN (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 22 Dec 2014 17:12:13 -0500
Message-ID: <1419286325.8812.3.camel@stgolabs.net>
Subject: Re: mm: NULL ptr deref in unlink_file_vma
From: Davidlohr Bueso <dave@stgolabs.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Dec 2014 14:12:05 -0800
In-Reply-To: <20141222191452.GA20295@node.dhcp.inet.fi>
References: <549832E2.8060609@oracle.com>
	 <20141222180102.GA8072@node.dhcp.inet.fi> <54985D59.5010506@oracle.com>
	 <20141222191452.GA20295@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 21:14 +0200, Kirill A. Shutemov wrote:
> Other thing:
> 
>  unmap_mapping_range()
>    i_mmap_lock_read(mapping);
>    unmap_mapping_range_tree()
>      unmap_mapping_range_vma()
>        zap_page_range_single()
>          unmap_single_vma()
> 	   untrack_pfn()
> 	     vma->vm_flags &= ~VM_PAT;
> 
> It seems we modify ->vm_flags without mmap_sem taken, means we can corrupt
> them.

yep. Although one thing that wouldn't match this would be the mlock'd
bad page when freeing in both of Sasha's previous reports, as we would
need to have VM_PFNMAP when calling untrack_pfn().

> Sasha could you check if you hit untrack_pfn()?
> 
> The problem probably was hidden by exclusive i_mmap_lock on
> unmap_mapping_range(), but it's not exclusive anymore afrer Dave's
> patchset.
> 
> Konstantin, you've modified untrack_pfn() back in 2012 to change
> ->vm_flags. Any coments?
> 
> For now, I would propose to revert the commit and probably re-introduce it
> after v3.19:
> 
> From 14392c69fcfeeda34eb9f75d983dad32698cdd5c Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 22 Dec 2014 21:01:54 +0200
> Subject: [PATCH] Revert "mm/memory.c: share the i_mmap_rwsem"
> 
> This reverts commit c8475d144abb1e62958cc5ec281d2a9e161c1946.
> 
> There are several[1][2] of bug reports which points to this commit as potential
> cause[3].
> 
> Let's revert it until we figure out what's going on.
> 
> [1] https://lkml.org/lkml/2014/11/14/342
> [2] https://lkml.org/lkml/2014/12/22/213
> [3] https://lkml.org/lkml/2014/12/9/741
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>

I certainly have no problem with this. Furthermore we snuck this one in
kinda last minute, so:

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

Thanks,
Davidlohr

