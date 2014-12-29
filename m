Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaL2Fkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 00:40:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34012 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaL2Fkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 00:40:42 -0500
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, mce: use mce_usable_address() for UCNA memory error recovery
Date: Mon, 29 Dec 2014 13:40:23 +0800
Message-Id: <1419831623-14078-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A machine-check address register (MCi_ADDR) that the processor uses
to report the address or location associated with the logged error.
The address field can hold a virtual (linear) address, a physical
address, or a value indicating an internal physical location, depending
on the type of error. For further information, see the documentation
for particular implementations of the architecture.
                                           -- AMD64 APM Volume 2

The IA32_MCi_ADDR MSR contains the address of the code or data memory
location that produced the machine-check error. The IA32_MCi_ADDR
register is either not implemented or contains no address if the ADDRV
flag in the IA32_MCi_STATUS register is clear. The address returned is
an offset into a segment, linear address, physical address, or memory
address. This depends on the error encountered.
                                           -- Intel SDM Volume 3B

As the comment of `mce_usable_address' suggests, we should check if the
address reported by the CPU is in a format we can parse. This patch aims
to use mce_usable_address() for UCNA/Deferred memory error recovery. For
Intel x86_64 platform mce_usable_address() can work fine, but it doesn't
even matter for AMD platform.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   48 ++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 800d423..c777626 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -607,6 +607,35 @@ static bool memory_error(struct mce *m)
 	return false;
 }
 
+/*
+ * Check if the address reported by the CPU is in a format we can parse.
+ * It would be possible to add code for most other cases, but all would
+ * be somewhat complicated (e.g. segment offset would require an instruction
+ * parser). So only support physical addresses up to page granuality for now.
+ */
+static int mce_usable_address(struct mce *m)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		if (!(m->status & MCI_STATUS_MISCV) ||
+					!(m->status & MCI_STATUS_ADDRV))
+			return 0;
+		if (MCI_MISC_ADDR_LSB(m->misc) > PAGE_SHIFT)
+			return 0;
+		if (MCI_MISC_ADDR_MODE(m->misc) != MCI_MISC_ADDR_PHYS)
+			return 0;
+		return 1;
+	} else if (c->x86_vendor == X86_VENDOR_AMD) {
+		/*
+		 * coming soon
+		 */
+		return 0;
+	}
+
+	return 0;
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -671,7 +700,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * do not add it into the ring buffer.
 		 */
 		if (severity == MCE_DEFERRED_SEVERITY && memory_error(&m)) {
-			if (m.status & MCI_STATUS_ADDRV) {
+			if (mce_usable_address(&m)) {
 				mce_ring_add(m.addr >> PAGE_SHIFT);
 				mce_schedule_work();
 			}
@@ -976,23 +1005,6 @@ reset:
 	return ret;
 }
 
-/*
- * Check if the address reported by the CPU is in a format we can parse.
- * It would be possible to add code for most other cases, but all would
- * be somewhat complicated (e.g. segment offset would require an instruction
- * parser). So only support physical addresses up to page granuality for now.
- */
-static int mce_usable_address(struct mce *m)
-{
-	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
-		return 0;
-	if (MCI_MISC_ADDR_LSB(m->misc) > PAGE_SHIFT)
-		return 0;
-	if (MCI_MISC_ADDR_MODE(m->misc) != MCI_MISC_ADDR_PHYS)
-		return 0;
-	return 1;
-}
-
 static void mce_clear_state(unsigned long *toclear)
 {
 	int i;
-- 
1.7.10.4

