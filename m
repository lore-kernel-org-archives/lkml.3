Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3LQSOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60895 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3LQSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 040/103] ARM: footbridge: fix VGA initialisation
Date: Tue, 17 Dec 2013 18:12:29 +0000
Message-Id: <1387304012-23805-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 43659222e7a0113912ed02f6b2231550b3e471ac upstream.

It's no good setting vga_base after the VGA console has been
initialised, because if we do that we get this:

Unable to handle kernel paging request at virtual address 000b8000
pgd = c0004000
[000b8000] *pgd=07ffc831, *pte=00000000, *ppte=00000000
0Internal error: Oops: 5017 [#1] ARM
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0+ #49
task: c03e2974 ti: c03d8000 task.ti: c03d8000
PC is at vgacon_startup+0x258/0x39c
LR is at request_resource+0x10/0x1c
pc : [<c01725d0>]    lr : [<c0022b50>]    psr: 60000053
sp : c03d9f68  ip : 000b8000  fp : c03d9f8c
r10: 000055aa  r9 : 4401a103  r8 : ffffaa55
r7 : c03e357c  r6 : c051b460  r5 : 000000ff  r4 : 000c0000
r3 : 000b8000  r2 : c03e0514  r1 : 00000000  r0 : c0304971
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel

which is an access to the 0xb8000 without the PCI offset required to
make it work.

Fixes: cc22b4c18540 ("ARM: set vga memory base at run-time")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-footbridge/common.c  | 5 ++++-
 arch/arm/mach-footbridge/dc21285.c | 2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-footbridge/common.c b/arch/arm/mach-footbridge/common.c
index 3e6aaa6..e8cf2a1 100644
--- a/arch/arm/mach-footbridge/common.c
+++ b/arch/arm/mach-footbridge/common.c
@@ -15,7 +15,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
- 
+#include <video/vga.h>
+
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
@@ -198,6 +199,8 @@ void __init footbridge_map_io(void)
 	 */
 	if (footbridge_cfn_mode())
 		iotable_init(ebsa285_host_io_desc, ARRAY_SIZE(ebsa285_host_io_desc));
+
+	vga_base = PCIMEM_BASE;
 }
 
 void footbridge_restart(char mode, const char *cmd)
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 9d62e33..405d22b 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <video/vga.h>
 
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
@@ -293,7 +292,6 @@ void __init dc21285_preinit(void)
 	int cfn_mode;
 
 	pcibios_min_mem = 0x81000000;
-	vga_base = PCIMEM_BASE;
 
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)
-- 
1.8.3.2

