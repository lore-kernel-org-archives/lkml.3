Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaKDMbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:31:51 -0500
Received: from mta-out1.inet.fi ([62.71.2.234]:53754 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaKDMbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:31:49 -0500
Date: Tue, 4 Nov 2014 14:29:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
        "Kirill A. Shutemov" <kirill.shutemov@intel.linux.com>,
        Michel Lespinasse <walken@google.com>, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dbueso@suse.de,
        linux-mm@kvack.org
Subject: Re: [PATCH 08/10] mm/mremap: share the i_mmap_rwsem
Message-ID: <20141104122901.GA28274@node.dhcp.inet.fi>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
 <1414697657-1678-9-git-send-email-dave@stgolabs.net>
 <alpine.LSU.2.11.1411032148230.15596@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1411032148230.15596@eggly.anvils>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:04:24PM -0800, Hugh Dickins wrote:
> I'm glad to see this series back, and nicely presented: thank you.
> Not worth respinning them, but consider 1,2,3,4,5,6,7 and 9 as
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> On Thu, 30 Oct 2014, Davidlohr Bueso wrote:
> 
> > As per the comment in move_ptes(), we only require taking the
> > anon vma and i_mmap locks to ensure that rmap will always observe
> > either the old or new ptes, in the case of need_rmap_lock=true.
> > No modifications to the tree itself, thus share the i_mmap_rwsem.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
> 
> But this one is Nacked by me.  I don't understand how you and Kirill
> could read Michel's painstaking comment on need_rmap_locks, then go
> go ahead and remove the exclusion of rmap_walk().
> 
> I agree the code here does not modify the interval tree, but the
> comment explains how we're moving a pte from one place in the tree
> to another, and in some cases there's a danger that the rmap walk
> might miss the pte from both places (which doesn't matter much to
> most of its uses, but is critical in page migration).
> 
> Or am I the one missing something?

You're completely right.

I've seen the comment (and I've added the missed need_rmap_locks case for
move_huge_pmd() before). What happened is I've over-extrapolated my
experience of rmap walk in case of split_huge_page(), which takes exclusive
anon_vma lock, to the rest of rmap use-cases. This of course was hugely
wrong.

I'm ashamed and feel really bad about the situation. Sorry.

-- 
 Kirill A. Shutemov
