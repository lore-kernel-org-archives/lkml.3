Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3EZNlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:41:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40379 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3EZNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:41:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8, part3 03/14] mm/ARM64: kill poison_init_mem()
Date: Sun, 26 May 2013 21:38:31 +0800
Message-Id: <1369575522-26405-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use free_reserved_area() to poison initmem memory pages and kill
poison_init_mem() on ARM64.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm64/mm/init.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 997c634..a398eb9 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -197,14 +197,6 @@ void __init bootmem_init(void)
 	max_pfn = max_low_pfn = max;
 }
 
-/*
- * Poison init memory with an undefined instruction (0x0).
- */
-static inline void poison_init_mem(void *s, size_t count)
-{
-	memset(s, 0, count);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 static inline void free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -386,8 +378,7 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	poison_init_mem(__init_begin, __init_end - __init_begin);
-	free_initmem_default(-1);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -396,10 +387,8 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd) {
-		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area((void *)start, (void *)end, -1, "initrd");
-	}
+	if (!keep_initrd)
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 
 static int __init keepinitrd_setup(char *__unused)
-- 
1.8.1.2

