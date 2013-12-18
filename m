Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3LRTTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3LRTTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:22 -0500
Date: Wed, 18 Dec 2013 20:19:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/7] mm: thp: change __get_page_tail() to use
	__put_nontail_page()
Message-ID: <20131218191952.GA8319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_page_tail() can use __put_nontail_page() instead of put_page()
if it races with split_huge_page(). This is what put_compound_page()
does, so this is equally safe. And this allows us to factor out this
code later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index f83de1f..aae24fe 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -289,7 +289,7 @@ bool __get_page_tail(struct page *page)
 		}
 		compound_unlock_irqrestore(page_head, flags);
 		if (unlikely(!got))
-			put_page(page_head);
+			__put_nontail_page(page_head);
 	}
 	return got;
 }
-- 
1.5.5.1

