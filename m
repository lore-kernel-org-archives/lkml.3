Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3EVMc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:32:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:9021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab3EVMc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:32:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,719,1363158000"; 
   d="scan'208";a="338186386"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <519BC864.1010602@sr71.net>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-7-git-send-email-kirill.shutemov@linux.intel.com>
 <519BC864.1010602@sr71.net>
Subject: Re: [PATCHv4 06/39] thp, mm: avoid PageUnevictable on active/inactive
 lru lists
Content-Transfer-Encoding: 7bit
Message-Id: <20130522123451.A3D08E0090@blue.fi.intel.com>
Date: Wed, 22 May 2013 15:34:51 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > 
> > active/inactive lru lists can contain unevicable pages (i.e. ramfs pages
> > that have been placed on the LRU lists when first allocated), but these
> > pages must not have PageUnevictable set - otherwise shrink_active_list
> > goes crazy:
> > 
> > kernel BUG at /home/space/kas/git/public/linux-next/mm/vmscan.c:1122!
> > invalid opcode: 0000 [#1] SMP
> > CPU 0
> > Pid: 293, comm: kswapd0 Not tainted 3.8.0-rc6-next-20130202+ #531
> > RIP: 0010:[<ffffffff81110478>]  [<ffffffff81110478>] isolate_lru_pages.isra.61+0x138/0x260
> > RSP: 0000:ffff8800796d9b28  EFLAGS: 00010082'
> ...
> 
> I'd much rather see a code snippet and description the BUG_ON() than a
> register and stack dump.  That line number is wrong already. ;)

Good point.

> > For lru_add_page_tail(), it means we should not set PageUnevictable()
> > for tail pages unless we're sure that it will go to LRU_UNEVICTABLE.
> > Let's just copy PG_active and PG_unevictable from head page in
> > __split_huge_page_refcount(), it will simplify lru_add_page_tail().
> > 
> > This will fix one more bug in lru_add_page_tail():
> > if page_evictable(page_tail) is false and PageLRU(page) is true, page_tail
> > will go to the same lru as page, but nobody cares to sync page_tail
> > active/inactive state with page. So we can end up with inactive page on
> > active lru.
> > The patch will fix it as well since we copy PG_active from head page.
> 
> This all seems good, and if it fixes a bug, it should really get merged
> as it stands.  Have you been actually able to trigger that bug in any
> way in practice?

I was only able to trigger it on ramfs transhuge pages split.
I doubt there's a way to reproduce it on current upstream code.

> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks!

-- 
 Kirill A. Shutemov
