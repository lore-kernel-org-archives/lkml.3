Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaAVL3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:29:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:44592 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaAVL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:28:50 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <kexec@lists.infradead.org>
CC: Eric Biederman <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Wang Nan <wangnan0@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] ARM: Premit ioremap() to map reserved pages
Date: Wed, 22 Jan 2014 19:25:14 +0800
Message-ID: <1390389916-8711-2-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch relaxes the restriction set by commit 309caa9cc, which
prohibit ioremap() on all kernel managed pages.

Other architectures, such as x86 and (some specific platforms of) powerpc,
allow such mapping.

ioremap() pages is an efficient way to avoid arm's mysterious cache control.
This feature will be used for arm kexec support to ensure copied data goes into
RAM even without cache flushing, because we found that flush_cache_xxx can't
reliably flush code to memory.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: <stable@vger.kernel.org> # 3.4+
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geng Hui <hui.geng@huawei.com>
---
 arch/arm/mm/ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f123d6e..98b1c10 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -298,7 +298,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	/*
 	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
 	 */
-	if (WARN_ON(pfn_valid(pfn)))
+	if (WARN_ON(pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn))))
 		return NULL;
 
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
-- 
1.8.4

