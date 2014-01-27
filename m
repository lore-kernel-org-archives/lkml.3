Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaA0KEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:04:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16481 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaA0KEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:04:07 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-45-52e62f107c18
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, xfishcoder@gmail.com
Subject: [PATCH 8/8] mm/frontswap: add missing handle on a dup-store failure
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000701cf1b47$19c56ab0$4d504010$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRu73wB4O86FSTSadXcJOsuxN9A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAV0B/WdBBlt26VjMWb+GzaLr1FQW
	i4OzlzBZPP3Ux2JxedccNot7a/6zWiz7+p7dYsrDSYwWFw7dZ7JYsPERo8WTE/9ZLGa8OMDs
	wOOxc9Zddo8Fm0o9Nq3qZPPY9GkSu8eJGb9ZPD4+vcXi8X7fVTaPvi2rGD0+b5IL4IzisklJ
	zcksSy3St0vgypg66TtzwVT2iu+TprM3MD5i7WLk5JAQMJF4cOA/M4QtJnHh3nq2LkYuDiGB
	RYwSa6ffYoJw/jBKLPj2BqyKTUBb4m7/RrBuEQERiTV3FjKC2MwCT5gk9p6v7GLk4BAW8JF4
	8DgIJMwioCpx9NB0dhCbV8BOYvbbDcwQtqDEj8n3WEDKmQXUJaZMyYWYIi+xec1bZpCwBFD4
	0V9diEV6EtcufWWFKBGX2HjkFssERoFZSAbNQhg0C8mgWUg6FjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIjqdnUjsYVzZYHGIU4GBU4uHNuP40SIg1say4MvcQowQHs5IIb4XOsyAh
	3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjId2d7w25ZRY
	Ym56YYo5772YLM2Kpzvef+91+lLNc2rC51LD+hN6FpKTVx64YVP942zfx9XfGmPXvu/r9XvX
	w3nogrVB94Obbhr7VL8s7dJgbREWntvx2TsrQuF8jtvVe3tE4nc+s1+w1IZ1luuhfJPNc3Z3
	tgZfKFzJ9KMl+kjxupuz9fbMnafEUpyRaKjFXFScCADJz2EHowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a frontswap dup-store failed, it should invalidate the old page in
backend and return failure.

This patch add this missing handle. According to the comments of
__frontswap_store(), it should have been there.

Reported-by: changkun.li <xfishcoder@gmail.com>
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/frontswap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index df067f1..171c6c0 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -245,8 +245,10 @@ int __frontswap_store(struct page *page)
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
1.7.10.4


