Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaHTPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:04:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17641 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHTPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:04:40 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a3-53f4b9053610
Subject: [PATCH 1/7] mm/balloon_compaction: ignore anonymous pages
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 19:04:35 +0400
Message-id: <20140820150435.4194.28003.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xa7qsO78EG0xoYrSYs34Nm8WMh79Y
	LH7s7GW1uLxrDpvFvTX/WS2Ob93CbLH4yG1mB3aPnbPusnts+jSJ3ePEjN8sHh+f3mLxeL/v
	KptH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZbTO+sJW8JqjYt+MLewNjFfZuxg5OSQETCQm
	XfsAZYtJXLi3ng3EFhJYyijxcQU3hN3IJLFofy2ILSzgJPFjWi8ziM0mYCaxbd9tRhBbRCBN
	4uuzLWC9zAJFEi9uzgKzWQRUJV6+3c0KYvMKGEl0TvgLtktUQE5i5eUWqLigxI/J91i6GDmA
	etUlpkzJhRgjL7F5zVvmCYx8s5BUzUKomoWkagEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT8
	3E2MkBD+uoNx6TGrQ4wCHIxKPLw3F30JFmJNLCuuzD3EKMHBrCTCe2IDUIg3JbGyKrUoP76o
	NCe1+BAjEwenVANj3qbZXFOPPznU/7JX69uE/cdTeltuhlgX5GbMeejjN3n2i76y5umTeGtu
	v079fLgmUG5Oz8EXX300m2wOuU9qmffuzQvlCapV9zi9Upq31mT/ii38FVCmf1H06KOn+1WS
	MtepT7Tq+r3Cy2655YJ6TjGVwIzFvlmPM54yrkq6vft2nvTc/p/GSizFGYmGWsxFxYkAY4ni
	Tz8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin reported KASAN splash inside isolate_migratepages_range().
Problem is in function __is_movable_balloon_page() which tests AS_BALLOON_MAP
in page->mapping->flags. This function has no protection against anonymous
pages. As result it tried to check address space flags in inside anon-vma.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/p/53E6CEAA.9020105@oracle.com
Cc: stable <stable@vger.kernel.org> # v3.8
---
 include/linux/balloon_compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 089743a..53d482e 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -128,7 +128,7 @@ static inline bool page_flags_cleared(struct page *page)
 static inline bool __is_movable_balloon_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	return mapping_balloon(mapping);
+	return !PageAnon(page) && mapping_balloon(mapping);
 }
 
 /*

