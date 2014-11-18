Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaKRIwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:52:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34124 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaKRIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:52:48 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-fc-546b08dcea97
From: Weijie Yang <weijie.yang@samsung.com>
To: konrad.wilk@oracle.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Minchan Kim'" <minchan@kernel.org>, "'Bob Liu'" <bob.liu@oracle.com>,
        xfishcoder@gmail.com, "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: frontswap: invalidate expired data on a dup-store failure
Date: Tue, 18 Nov 2014 16:51:36 +0800
Message-id: <000001d0030d$0505aaa0$0f10ffe0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdADDNv43mHoldOFQiKfJi5nsexPFQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgO4djuwQg8tfTSzmrF/DZtF1aiqL
	xYW23SwWyxY/ZbS4vGsOm8W9Nf9ZLZZ9fc9u8enoIzaLJyf+s1jMeHGA2YHLY+esu+weTycc
	ZPLYtKqTzWPTp0nsHidm/Gbx+Pj0FovH9W9FHp83yQVwRHHZpKTmZJalFunbJXBl9LyYyVzw
	jbPi2c8z7A2MjRxdjJwcEgImEmsWdjNC2GISF+6tZ+ti5OIQEljEKHH94Tt2COcPo8TBW4dY
	QKrYBLQl7vZvZAWxRQSkJFZvvMcKUsQscIBJ4sG9RWAJYQE/iZ62y8xdjBwcLAKqEkuP6oKE
	eQXsJP4vmMgGYQtK/Jh8jwWkhFlAXWLKlFyQMLOAvMTmNW/BOiWAwo/+6kJs0pN4c+MiG0SJ
	uMTGI7dYJjAKzEIyaBbCoFlIBs1C0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDM
	PJPewbiqweIQowAHoxIPb+LUrBAh1sSy4srcQ4wSHMxKIrznuoFCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGKcz7V/h/+CX1C3+57kZWpl/D8n4blv0
	x3w587NVdbfiF/6UW2SXzOf5ROXlujev3ZjKZZPMvrxRPL/sYf5bh5K5nq/sr5+eI79yh8Kl
	Dx/+8T9MXpX8rv6jcaR9ZMSsJ9cKRGY2BX/ItJ7M7sbya6XW/fywhuZ7XyYeTDbeOnfL9XNS
	DrFqGwSVWIozEg21mIuKEwH3xORklQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a frontswap dup-store failed, it should invalidate the expired page
in the backend, or it could trigger some data corruption issue.
Such as:
1. use zswap as the frontswap backend with writeback feature
2. store a swap page(version_1) to entry A, success
3. dup-store a newer page(version_2) to the same entry A, fail
4. use __swap_writepage() write version_2 page to swapfile, success
5. zswap do shrink, writeback version_1 page to swapfile
6. version_2 page is overwrited by version_1, data corrupt.

This patch fixes this issue by invalidating expired data immediately
when meet a dup-store failure.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/frontswap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index c30eec5..f2a3571 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -244,8 +244,10 @@ int __frontswap_store(struct page *page)
 		  the (older) page from frontswap
 		 */
 		inc_frontswap_failed_stores();
-		if (dup)
+		if (dup) {
 			__frontswap_clear(sis, offset);
+			frontswap_ops->invalidate_page(type, offset);
+		}
 	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
-- 
1.7.0.4


