Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3KTRrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:47:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3KTRrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:47:13 -0500
Date: Wed, 20 Nov 2013 17:47:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git bits and pieces
Message-ID: <20131120174712.GG10323@ZenIV.linux.org.uk>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120174211.GF10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 05:42:11PM +0000, Al Viro wrote:
> [Apologies for delay; I'd spent the last day hunting down something that
> turned out to be a VM leak completely unrelated to this stuff - it's
> present in mainline, for starters.  Unreliable reproducers make for fun
> bisects ;-/  Anyway, by now I'm absolutely sure that this is a VM bug and
> not something I had somehow managed to break, so...]

BTW, something odd happened to mm/memory.c - either a mangled patch
or a lost followup.  Take a look at the last commit in there:
commit ea1e7ed33708c7a760419ff9ded0a6cb90586a50
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Thu Nov 14 14:31:53 2013 -0800

    mm: create a separate slab for page->ptl allocation
    
    If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
    is 72 bytes.  For page->ptl they will be allocated from kmalloc-96 slab,
    so we loose 24 on each.  An average system can easily allocate few tens
    thousands of page->ptl and overhead is significant.
    
    Let's create a separate slab for page->ptl allocation to solve this.
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Fair enough, and yes, it does create that separate slab.  The problem is,
it's still using kmalloc/kfree for those beasts - page_ptl_cachep isn't
used at all...
