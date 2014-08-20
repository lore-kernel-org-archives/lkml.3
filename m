Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaHTPEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:04:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29720 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHTPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:04:45 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f3-53f4b90ab1e9
Subject: [PATCH 2/7] mm/balloon_compaction: keep ballooned pages away from
 normal migration path
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 19:04:40 +0400
Message-id: <20140820150440.4194.70267.stgit@buzz>
In-reply-to: <20140820150435.4194.28003.stgit@buzz>
References: <20140820150435.4194.28003.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7pcO78EGzybb2oxZ/0aNosZD3+x
	WPzY2ctqcXnXHDaLe2v+s1oc37qF2WLxkdvMDuweO2fdZffY9GkSu8eJGb9ZPD4+vcXi8X7f
	VTaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyjh03qngMFfF0XtH2RsYH3J0MXJySAiYSExa
	OosZwhaTuHBvPVsXIxeHkMBSRom5N/axQDiNTBKH3nYxdTFycAgLJEl8PO8D0sAmYCaxbd9t
	RhBbRCBN4uuzLWwgNrNAkcSLm7PAbBYBVYmFezqYQGxeASOJK0++gNmcAsYSa46/BOsVAopf
	6/kNdoSogJzEysstrBD1ghI/Jt9jAVnLLKAuMWVKLsR4eYnNa94yT2AUmIWkahZC1SwkVQsY
	mVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihIT8lx2Mi49ZHWIU4GBU4uG9sehLsBBrYllx
	Ze4hRgkOZiUR3hMbgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYZ6ff42U0fvPRKvXFo6IpfKKr
	87Tyzij6vznfsOJGXfsuuWPxP3bsqeH28GzOt1L0ZfX6n7owzn2+w81NwQ+uvtyfr+xQ/VrM
	qP2Mc1/9+RIl08Zo3g1Wq6d9ZN2Udz/4i89Dt+gV33Stnps12++tO+jZ2ZLxa36exdbdXyIa
	51maHWdd0SKmxFKckWioxVxUnAgAvKglxFcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proper testing shows yet another problem in balloon migration: it works only
once for each page. balloon_page_movable() check page flags and page_count.
In __unmap_and_move page is locked, reference counter is elevated, so
balloon_page_movable() _always_ fails here. As result in __unmap_and_move()
migration goes to the normal migration path.

Balloon ->migratepage() is so special, it returns MIGRATEPAGE_BALLOON_SUCCESS
instead of MIGRATEPAGE_SUCCESS. After that in move_to_new_page() successfully
migrated page got NULL into its mapping pointer and loses connectivity with
balloon and ability for further migration.

It's safe to use __is_movable_balloon_page here: page is isolated and pinned.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: stable <stable@vger.kernel.org> # v3.8
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f78ec9b..161d044 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -873,7 +873,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		}
 	}
 
-	if (unlikely(balloon_page_movable(page))) {
+	if (unlikely(__is_movable_balloon_page(page))) {
 		/*
 		 * A ballooned page does not need any special attention from
 		 * physical to virtual reverse mapping procedures.

