Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaB0Ekk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:40:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbaB0Ej6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:39:58 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm/pagewalk.c: fix end address calculation in walk_page_range()
Date: Wed, 26 Feb 2014 23:39:35 -0500
Message-Id: <1393475977-3381-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to walk over inside a vma, walk_page_range() tries to walk
until vma->vm_end even if a given end is before that point.
So this patch takes the smaller one as an end address.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/pagewalk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git next-20140220.orig/mm/pagewalk.c next-20140220/mm/pagewalk.c
index 416e981243b1..b418407ff4da 100644
--- next-20140220.orig/mm/pagewalk.c
+++ next-20140220/mm/pagewalk.c
@@ -321,8 +321,9 @@ int walk_page_range(unsigned long start, unsigned long end,
 			next = vma->vm_start;
 		} else { /* inside the found vma */
 			walk->vma = vma;
-			next = vma->vm_end;
-			err = walk_page_test(start, end, walk);
+			next = min_t(unsigned long, end, vma->vm_end);
+
+			err = walk_page_test(start, next, walk);
 			if (skip_lower_level_walking(walk))
 				continue;
 			if (err)
-- 
1.8.5.3

