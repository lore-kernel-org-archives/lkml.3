Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3CYELK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:11:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44180 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3CYEKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:10:36 -0400
X-AuditID: 9c930197-b7c9dae000006959-6b-514fce3958a7
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 2/6] ARM, crashkernel: use ___alloc_bootmem_node_nopanic() for reserving memory
Date: Mon, 25 Mar 2013 13:11:10 +0900
Message-Id: <1364184674-13798-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For crashkernel, specific address should be reserved.
It can be achived by reserve_bootmem(), but this function is
only for bootmem.

Now, we try to enable nobootmem, therfore change it more general function,
___alloc_bootmem_node_nopanic(). It can be use for both,
bootmem and nobootmem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index b3990a3..99ffe87 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -674,15 +674,20 @@ static void __init reserve_crashkernel(void)
 {
 	unsigned long long crash_size, crash_base;
 	unsigned long long total_mem;
+	unsigned long limit = 0;
 	int ret;
 
 	total_mem = get_total_mem();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base);
-	if (ret)
+	if (ret != 0 || crash_size == 0)
 		return;
 
-	ret = reserve_bootmem(crash_base, crash_size, BOOTMEM_EXCLUSIVE);
+	if (crash_base != 0)
+		limit = crash_base + crash_size;
+
+	ret = ___alloc_bootmem_node_nopanic(NODE_DATA(0), crash_size,
+						PAGE_ALIGN, crash_base, limit);
 	if (ret < 0) {
 		printk(KERN_WARNING "crashkernel reservation failed - "
 		       "memory is in use (0x%lx)\n", (unsigned long)crash_base);
-- 
1.7.9.5

