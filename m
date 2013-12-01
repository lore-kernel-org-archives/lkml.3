Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3LAIcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 03:32:20 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58632 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3LAIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 03:32:18 -0500
From: ivan lam <ivan.lam2014@gmail.com>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, ivan.lam2014@gmail.com
Subject: [PATCH] arm/crash_dump.c: fix Oops caused by overflow converted from pfn to phys
Date: Sun,  1 Dec 2013 16:32:09 +0800
Message-Id: <1385886729-27190-1-git-send-email-ivan.lam2014@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Cortex-A9 machine, with LPAE feature enabled and physical address space
larger than 4G, Capture kernel will Oops on reading the /proc/vmcore file.

In copy_oldmem_page function, it simply use "pfn << PAGE_SHIFT" to get
the physical address, but this will cause overflow when LPAE enabled and
physical address space is larger than 4G, thus get the result as 0 and
cause Oops.

Fix it to use __pfn_to_phys instead. __pfn_to_phys will first cast the pfn
to type phys_addr_t which is the type u64 when LPAE enabled, and left shifted
by PAGE_SHIFT to get the proper physical address.

Signed-off-by: ivan lam <ivan.lam2014@gmail.com>
---
 arch/arm/kernel/crash_dump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/crash_dump.c b/arch/arm/kernel/crash_dump.c
index 90c50d4..5d1286d 100644
--- a/arch/arm/kernel/crash_dump.c
+++ b/arch/arm/kernel/crash_dump.c
@@ -39,7 +39,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap(__pfn_to_phys(pfn), PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
-- 
1.7.9.5

