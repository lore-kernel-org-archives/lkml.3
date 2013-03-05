Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3CEG7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:59:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24884 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3CEG7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:59:03 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-f1-513597a59407
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC/PATCH 5/5] media: vb2: use FOLL_DURABLE and __get_user_pages() to
 avoid CMA migration issues
Date: Tue, 05 Mar 2013 07:57:59 +0100
Message-id: <1362466679-17111-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jQd1l000DDbruM1vMWb+GzeLvpGPs
	FhtnrGe1ONv0ht3iy5WHTBaXd81hs7i35j+rxdojd9ktfh/sZLdYcLyF1WLZ1/fsDtwev39N
	YvTo3fuV1WPTqk42j02fJrF7nJjxm8Xj9r/HzB7r/rxi8ujbsorR4/MmuQDOKC6blNSczLLU
	In27BK6MTTP3Mxd0c1cs/H2TqYFxOmcXIyeHhICJxInFTcwQtpjEhXvr2boYuTiEBKYzSpx9
	8pMVwmlnkthx8CQLSBWbgKFE19suNhBbRCBM4k/jNrAiZoHjTBJ/Lq4FSwgL5Ei0b/gG1sAi
	oCrxceJJsBW8Ah4SvZOWAdVwAK1TkJgzyQYkzCngKfFk+UewciGgknnbPjNNYORdwMiwilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4TJ9J72Bc1WBxiFGAg1GJh5fhqEmgEGtiWXFl7iFG
	CQ5mJRFesTrTQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8jKeeBAgJpCeWpGanphakFsFkmTg4
	pRoYSzLfZ9nudXz3hc/uRZOv/AyHczlBahOn/JL966LjPW217VQNrR/sSw9VStUpm3Fdbq70
	FL2fuPnYxJYZAW+X1i+NnmH05v5i/fdCm36U8+1L4X4+t6ZG++abBs05dt/faK4+8anpxrLo
	s5kl6cGOzIzHnSSVor73CNmsm3xMKKD3h7zFpy8dSizFGYmGWsxFxYkAWIRx2k8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4L2 devices usually grab additional references to user pages for a very
long period of time, what causes permanent migration failures if the given
page has been allocated from CMA pageblock. By setting FOLL_DURABLE flag,
videobuf2 will instruct __get_user_pages() to migrate user pages out of
CMA pageblocks before blocking them with an additional reference.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 10beaee..70649ab 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -443,9 +443,13 @@ static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
 		}
 	} else {
 		int n;
+		int flags = FOLL_TOUCH | FOLL_GET | FOLL_FORCE | FOLL_DURABLE;
 
-		n = get_user_pages(current, current->mm, start & PAGE_MASK,
-			n_pages, write, 1, pages, NULL);
+		if (write)
+			flags |= FOLL_WRITE;
+
+		n = __get_user_pages(current, current->mm, start & PAGE_MASK,
+			n_pages, flags, pages, NULL, NULL);
 		/* negative error means that no page was pinned */
 		n = max(n, 0);
 		if (n != n_pages) {
-- 
1.7.9.5

