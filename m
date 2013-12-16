Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3LPUTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3LPUTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:19:05 -0500
Date: Mon, 16 Dec 2013 21:19:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH -mm 1/2] mm: thp: __get_page_tail_foll() can use
	get_huge_page_tail()
Message-ID: <20131216201930.GB6616@redhat.com>
References: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216201900.GA6616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216201900.GA6616@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Change __get_page_tail_foll() to use get_huge_page_tail()
to avoid the code duplication.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/internal.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a85a3ab..a346ba1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -47,12 +47,9 @@ static inline void __get_page_tail_foll(struct page *page,
 	 * page_cache_get_speculative()) on tail pages.
 	 */
 	VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	VM_BUG_ON(page_mapcount(page) < 0);
 	if (get_page_head)
 		atomic_inc(&page->first_page->_count);
-	if (compound_tail_refcounted(page->first_page))
-		atomic_inc(&page->_mapcount);
+	get_huge_page_tail(page);
 }
 
 /*
-- 
1.5.5.1


