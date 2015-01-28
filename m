Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbbA1Bpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:45:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbbA1Bih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 65/77] mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()
Date: Tue, 27 Jan 2015 17:27:43 -0800
Message-Id: <20150128012747.919048398@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit c0d73261f5c1355a35b8b40e871d31578ce0c044 upstream.

Use ACCESS_ONCE() in handle_pte_fault() when getting the entry or
orig_pte upon which all subsequent decisions and pte_same() tests will
be made.

I have no evidence that its lack is responsible for the mm/filemap.c:202
BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by
trinity, and I am not optimistic that it will fix it.  But I have found
no other explanation, and ACCESS_ONCE() here will surely not hurt.

If gcc does re-access the pte before passing it down, then that would be
disastrous for correct page fault handling, and certainly could explain
the page_mapped() BUGs seen (concurrent fault causing page to be mapped
in a second time on top of itself: mapcount 2 for a single pte).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3646,7 +3646,7 @@ static int handle_pte_fault(struct mm_st
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {


