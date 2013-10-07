Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3JGPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:25:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16985 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JGPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:25:56 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c0-5252d2824c78
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Cc: Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] frontswap: enable call to invalidate area on swapoff
Date: Mon, 07 Oct 2013 17:25:41 +0200
Message-id: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xq7pNl4KCDFZc47aYs34Nm8XrF4YW
	yxY/ZbS4vGsOm8W9Nf9ZLZZ9fc9ucWo5hwO7x5Omn8wem1Z1snls+jSJ3ePEjN8sHh+f3mLx
	6NuyitHj8ya5APYoLpuU1JzMstQifbsErozf1/ayFMzlrHj3oYW1gfEZexcjJ4eEgInEnsYW
	ZghbTOLCvfVsXYxcHEICSxkljj1dwwLh9DFJnPnRxQpSxSZgLLF5+RKwKhGBiYwS978/AWtn
	FiiVuNm3khHEFhZwlZh/eyeYzSKgKtG9GqKZV8BdYsWzTqCpHEDrFCTmTLKZwMi9gJFhFaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZI2HzZwbj4mNUhRgEORiUeXoHDQUFCrIllxZW5hxgl
	OJiVRHhvnQAK8aYkVlalFuXHF5XmpBYfYmTi4JRqYCxrjtO6NjGumLVt1qJpaVHB96f8Pf/I
	uDdGNFnom3946ka3YyfMfpzeeXvTySrhTPuicKVCrm2vT4tsEeri95S859h0WKym/WRogYZm
	4DyxpRPq13LzHTUsFZEw0vhWmscW2CUVm7z4tO79KayMPFsZJC+/C3wjNGfusWuPGfr2brzd
	3DTnvhJLcUaioRZzUXEiAC5OXej5AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During swapoff the frontswap_map was NULL-ified before calling
frontswap_invalidate_area(). However the frontswap_invalidate_area()
exits early if frontswap_map is NULL. Invalidate was never called during
swapoff.

This patch moves frontswap_map_set() in swapoff just after calling
frontswap_invalidate_area() so outside of locks
(swap_lock and swap_info_struct->lock). This shouldn't be a problem as
during swapon the frontswap_map_set() is called also outside of any
locks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3963fc2..3a4896b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1922,10 +1922,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->cluster_info = NULL;
 	p->flags = 0;
 	frontswap_map = frontswap_map_get(p);
-	frontswap_map_set(p, NULL);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	frontswap_invalidate_area(type);
+	frontswap_map_set(p, NULL);
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
-- 
1.7.9.5

