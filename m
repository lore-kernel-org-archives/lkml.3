Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaALLeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:34:10 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:59830 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaALLeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:34:09 -0500
Date: Sun, 12 Jan 2014 13:33:53 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] thp: fix copy_page_rep GPF by testing is_huge_zero_pmd
 once only
Message-ID: <20140112113353.GA21893@node.dhcp.inet.fi>
References: <alpine.LSU.2.11.1401120112500.4070@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401120112500.4070@eggly.anvils>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 01:25:21AM -0800, Hugh Dickins wrote:
> We see General Protection Fault on RSI in copy_page_rep:
> that RSI is what you get from a NULL struct page pointer.
> 
> RIP: 0010:[<ffffffff81154955>]  [<ffffffff81154955>] copy_page_rep+0x5/0x10
> RSP: 0000:ffff880136e15c00  EFLAGS: 00010286
> RAX: ffff880000000000 RBX: ffff880136e14000 RCX: 0000000000000200
> RDX: 6db6db6db6db6db7 RSI: db73880000000000 RDI: ffff880dd0c00000
> RBP: ffff880136e15c18 R08: 0000000000000200 R09: 000000000005987c
> R10: 000000000005987c R11: 0000000000000200 R12: 0000000000000001
> R13: ffffea00305aa000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f195752f700(0000) GS:ffff880c7fc20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000093010000 CR3: 00000001458e1000 CR4: 00000000000027e0
> Call Trace:
>  [<ffffffff810f2835>] ? copy_user_highpage.isra.43+0x65/0x80
>  [<ffffffff812654b2>] copy_user_huge_page+0x93/0xab
>  [<ffffffff8127cc76>] do_huge_pmd_wp_page+0x710/0x815
>  [<ffffffff81055ab8>] handle_mm_fault+0x15d8/0x1d70
>  [<ffffffff814f909d>] __do_page_fault+0x14d/0x840
>  [<ffffffff810a13ad>] ? SYSC_recvfrom+0x10d/0x210
>  [<ffffffff814f97bf>] do_page_fault+0x2f/0x90
>  [<ffffffff814f6032>] page_fault+0x22/0x30
> 
> do_huge_pmd_wp_page() tests is_huge_zero_pmd(orig_pmd) four times:
> but since shrink_huge_zero_page() can free the huge_zero_page, and
> we have no hold of our own on it here (except where the fourth test
> holds page_table_lock and has checked pmd_same), it's possible for
> it to answer yes the first time, but no to the second or third test.
> Change all those last three to tests for NULL page.
> 
> (Note: this is not the same issue as trinity's DEBUG_PAGEALLOC BUG
> in copy_page_rep with RSI: ffff88009c422000, reported by Sasha Levin
> in https://lkml.org/lkml/2013/3/29/103.  I believe that one is due
> to the source page being split, and a tail page freed, while copy
> is in progress; and not a problem without DEBUG_PAGEALLOC, since
> the pmd_same check will prevent a miscopy from being made visible.)
> 
> Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # v3.10 v3.11 v3.12

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
