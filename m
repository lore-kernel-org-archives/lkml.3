Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3FKPd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:33:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:2928 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab3FKPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="351755087"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 5/8] thp, mm: locking tail page is a bug
Date: Tue, 11 Jun 2013 18:35:16 +0300
Message-Id: <1370964919-16187-6-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Locking head page means locking entire compound page.
If we try to lock tail page, something went wrong.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index bb6ad8c..2bd1d24 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -639,6 +639,7 @@ void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_BUG_ON(PageTail(page));
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
@@ -648,6 +649,7 @@ int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_BUG_ON(PageTail(page));
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sleep_on_page_killable, TASK_KILLABLE);
 }
-- 
1.7.10.4

