Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaAQIqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:46:55 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9423 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaAQIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:46:32 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-fe-52d8ede63e3d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, stable@vger.kernel.org
Subject: [PATCH] ARM: dma-mapping: fix GFP_ATOMIC macro usage
Date: Fri, 17 Jan 2014 09:46:16 +0100
Message-id: <1389948376-26298-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jAd1nb28EGezdYGrx8fJsZotNj6+x
	WlzeNYfNYu2Ru+wWCzY+YnRg9di8pN6jt/kdm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	9Oy+wFbQxF6xa0ULYwPjE9YuRk4OCQETibfHpjNB2GISF+6tZ+ti5OIQEljEKDHzz0N2kISQ
	QCuTRFNXJojNJmAo0fW2iw3EFhFwk/i37hCYzSyQJfF49ntGEFtYwFbi+tnbQHEODhYBVYm1
	J5JBTF4BD4nzrxRATAkBBYk5k2wmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRHs
	/2dSOxhXNlgcYhTgYFTi4ZUQvxEkxJpYVlyZe4hRgoNZSYR3602gEG9KYmVValF+fFFpTmrx
	IUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsalfwVfr5/vHHdZvzmc0VO+MMSpy6LT
	7e9J9jW8N7LffvQyY7jhXfDDt0iWfdWn5xZ1tnf3Kealry5++vx15TzRVXqXbH5sNTY+JJ52
	5mxi/g17swOMxpek+EXvS2g/n/bb/8yWzJ+yTeaWPOnNRmJhOvxW/b8atgce8GQ63MmmKSI4
	ec3qg0osxRmJhlrMRcWJALeh4Un7AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence. This patch
fixes the issue introduced in v3.6-rc5

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: stable@vger.kernel.org
---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index f61a570..5fe4d72 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1358,7 +1358,7 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (gfp & GFP_ATOMIC)
+	if (!(gfp & __GFP_WAIT))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	/*
-- 
1.7.9.5

