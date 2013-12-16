Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3LPUTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:19:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab3LPUTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:19:24 -0500
Date: Mon, 16 Dec 2013 21:19:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH -mm 2/2] mm: thp: turn compound_head() into
	BUG_ON(!PageTail) in get_huge_page_tail()
Message-ID: <20131216201952.GC6616@redhat.com>
References: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216201900.GA6616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216201900.GA6616@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_huge_page_tail()->compound_head() looks confusing. Every caller
must check PageTail(page), otherwise atomic_inc(&page->_mapcount) is
simply wrong if this page is compound-trans-head.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mm.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 13bae9e..13495bd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -431,13 +431,12 @@ static inline bool compound_tail_refcounted(struct page *page)
 static inline void get_huge_page_tail(struct page *page)
 {
 	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 * In turn no need of compound_trans_head here.
+	 * __split_huge_page_refcount() cannot run from under us.
 	 */
+	VM_BUG_ON(!PageTail(page));
 	VM_BUG_ON(page_mapcount(page) < 0);
 	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	if (compound_tail_refcounted(compound_head(page)))
+	if (compound_tail_refcounted(page->first_page))
 		atomic_inc(&page->_mapcount);
 }
 
-- 
1.5.5.1


