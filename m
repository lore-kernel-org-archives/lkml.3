Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3LIJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:10:58 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49911 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab3LIJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:08:04 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-b7-52a5886feb0e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/7] mm/mempolicy: correct putback method for isolate pages if failed
Date: Mon,  9 Dec 2013 18:10:44 +0900
Message-Id: <1386580248-22431-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_pages_range() isolates hugetlbfs pages and putback_lru_pages() can't
handle these. We should change it to putback_movable_pages().

Naoya said that it is worth going into stable, because it can break
in-use hugepage list.

Cc: <stable@vger.kernel.org> # 3.12
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eca4a31..6d04d37 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1318,7 +1318,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
-		putback_lru_pages(&pagelist);
+		putback_movable_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
  mpol_out:
-- 
1.7.9.5

