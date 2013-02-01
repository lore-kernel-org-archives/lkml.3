Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3BAGK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:10:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38962 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab3BAGKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:10:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: mlock: document scary-looking stack expansion mlock chain
Date: Fri,  1 Feb 2013 01:10:13 -0500
Message-Id: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that mlock calls get_user_pages, and get_user_pages might
call mlock when expanding a stack looks like a potential recursion.

However, mlock makes sure the requested range is already contained
within a vma, so no stack expansion will actually happen from mlock.

Should this ever change: the stack expansion mlocks only the newly
expanded range and so will not result in recursive expansion.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/mlock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mlock.c b/mm/mlock.c
index b1647fb..78c4924 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -185,6 +185,10 @@ long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
 		gup_flags |= FOLL_FORCE;
 
+	/*
+	 * We made sure addr is within a VMA, so the following will
+	 * not result in a stack expansion that recurses back here.
+	 */
 	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }
-- 
1.7.11.7

