Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaJUSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:15:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaJUSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:15:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        a.ryabinin@samsung.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm, hugetlb: correct bit shift in hstate_sizelog
Date: Tue, 21 Oct 2014 14:15:07 -0400
Message-Id: <1413915307-20536-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hstate_sizelog() would shift left an int rather than long, triggering
undefined behaviour and passing an incorrect value when the requested
page size was more than 4GB, thus breaking >4GB pages.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65e12a2..57e0dfd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -312,7 +312,8 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
 {
 	if (!page_size_log)
 		return &default_hstate;
-	return size_to_hstate(1 << page_size_log);
+
+	return size_to_hstate(1UL << page_size_log);
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
-- 
1.7.10.4

