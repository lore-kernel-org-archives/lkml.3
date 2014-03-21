Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966544AbaCUAXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:23:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778AbaCUAJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 3.10 81/85] ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t
Date: Thu, 20 Mar 2014 17:10:24 -0700
Message-Id: <20140321000610.341404134@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/setup.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -530,6 +530,7 @@ void __init dump_machine_table(void)
 int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 {
 	struct membank *bank = &meminfo.bank[meminfo.nr_banks];
+	u64 aligned_start;
 
 	if (meminfo.nr_banks >= NR_BANKS) {
 		printk(KERN_CRIT "NR_BANKS too low, "
@@ -542,10 +543,16 @@ int __init arm_add_memory(phys_addr_t st
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
@@ -553,10 +560,11 @@ int __init arm_add_memory(phys_addr_t st
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


