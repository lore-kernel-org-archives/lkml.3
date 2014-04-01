Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaDALSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaDALSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Magnus Damm <damm@opensource.se>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/144] ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t
Date: Tue,  1 Apr 2014 12:15:09 +0100
Message-Id: <1396350948-29910-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Damm <damm@opensource.se>

commit 6d7d5da7d75c6df676c8b72d32b02ff024438f0c upstream.

Use CONFIG_ARCH_PHYS_ADDR_T_64BIT to determine
if ignoring or truncating of memory banks is
neccessary. This may be needed in the case of
64-bit memory bank addresses but when phys_addr_t
is kept 32-bit.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/setup.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index afc2489..f58f646 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -622,6 +622,7 @@ void __init dump_machine_table(void)
 int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
+	u64 aligned_start;
 
 	if (meminfo.nr_banks >= NR_BANKS) {
 		printk(KERN_CRIT "NR_BANKS too low, "
@@ -634,10 +635,16 @@ int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 	 * Size is appropriately rounded down, start is rounded up.
 	 */
 	size -= start & ~PAGE_MASK;
-	bank->start = PAGE_ALIGN(start);
+	aligned_start = PAGE_ALIGN(start);
 
-#ifndef CONFIG_ARM_LPAE
-	if (bank->start + size < bank->start) {
+#ifndef CONFIG_ARCH_PHYS_ADDR_T_64BIT
+	if (aligned_start > ULONG_MAX) {
+		printk(KERN_CRIT "Ignoring memory at 0x%08llx outside "
+		       "32-bit physical address space\n", (long long)start);
+		return -EINVAL;
+	}
+
+	if (aligned_start + size > ULONG_MAX) {
 		printk(KERN_CRIT "Truncating memory at 0x%08llx to fit in "
 			"32-bit physical address space\n", (long long)start);
 		/*
@@ -645,10 +652,11 @@ int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 		 * 32 bits, we use ULONG_MAX as the upper limit rather than 4GB.
 		 * This means we lose a page after masking.
 		 */
-		size = ULONG_MAX - bank->start;
+		size = ULONG_MAX - aligned_start;
 	}
 #endif
 
+	bank->start = aligned_start;
 	bank->size = size & ~(phys_addr_t)(PAGE_SIZE - 1);
 
 	/*
-- 
1.9.1

