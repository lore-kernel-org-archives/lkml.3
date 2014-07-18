Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071AbaGRQix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:38:53 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:32923 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaGRQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:38:51 -0400
Date: Fri, 18 Jul 2014 12:38:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Richard Yao <ryao@gentoo.org>
Cc: linux-kernel@vger.kernel.org, mthode@mthode.org, kernel@gentoo.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@openvz.org>,
        Rik van Riel <riel@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Dave Chinner <dchinner@redhat.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: vmscan: unlock_page page when forcing reclaim
Message-ID: <20140718163843.GK29639@cmpxchg.org>
References: <1405698484-25803-1-git-send-email-ryao@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405698484-25803-1-git-send-email-ryao@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:48:02AM -0400, Richard Yao wrote:
> A small userland program I wrote to assist me in drive forensic
> operations soft deadlocked on Linux 3.14.4. The stack trace from /proc
> was:
> 
> [<ffffffff8112968e>] sleep_on_page_killable+0xe/0x40
> [<ffffffff81129829>] wait_on_page_bit_killable+0x79/0x80
> [<ffffffff811299a5>] __lock_page_or_retry+0x95/0xc0
> [<ffffffff8112a95b>] filemap_fault+0x21b/0x420
> [<ffffffff8115685e>] __do_fault+0x6e/0x520
> [<ffffffff81156de3>] handle_pte_fault+0xd3/0x1f0
> [<ffffffff81157073>] __handle_mm_fault+0x173/0x290
> [<ffffffff811571d2>] handle_mm_fault+0x42/0xb0
> [<ffffffff81587a11>] __do_page_fault+0x191/0x490
> [<ffffffff81587dec>] do_page_fault+0xc/0x10
> [<ffffffff81584622>] page_fault+0x22/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The program used mmap() to do a linear scan of the device on 64-bit
> hardware. The block device in question was 200GB in size and the system
> had only 8GB of RAM. All IO operations stopped following pageout.
> 
> shrink_page_list() seemed to have raced with filemap_fault() by evicting
> a page when we had an active fault handler. This is possible only
> because 02c6de8d757cb32c0829a45d81c3dfcbcafd998b altered the behavior of
> shrink_page_list() to ignore references. Consequently, we must call
> unlock_page() instead of __clear_page_locked() when doing this so that
> waiters are notified. unlock_page() here will cause active page fault
> handlers to retry (depending on the architecture), which avoids the soft
> deadlock.

I don't really understand how the scenario you describe can happen.

Successfully reclaiming a page means that __remove_mapping() was able
to freeze a page count of 2 (page cache and LRU isolation), but
filemap_fault() increases the refcount on the page before trying to
lock the page.  If __remove_mapping() wins, find_get_page() does not
work and the fault does not lock the page.  If find_get_page() wins,
__remove_mapping() does not work and the reclaimer aborts and does a
regular unlock_page().

page_check_references() is purely about reclaim strategy, it should
not be essential for correctness.
