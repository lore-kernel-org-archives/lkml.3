Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3EGXCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:02:13 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36943 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3EGXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:02:11 -0400
From: j.glisse@gmail.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] mm: honor FOLL_GET flag in follow_hugetlb_page v2
Date: Tue,  7 May 2013 18:58:42 -0400
Message-Id: <1367967522-3934-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Glisse <jglisse@redhat.com>

Do not increase page count if FOLL_GET is not set. None of the
current user can trigger the issue because none of the current
user call __get_user_pages with both the pages array ptr non
NULL and the FOLL_GET flags non set in other word all caller
of __get_user_pages that don't set the FOLL_GET flags also call
with pages == NULL.

v2: Do not use get_page_foll. Improved comment.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ca9a7c6..32f323b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2981,7 +2981,9 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+			if (flags & FOLL_GET) {
+				get_page(pages[i]);
+			}
 		}
 
 		if (vmas)
-- 
1.7.11.7

