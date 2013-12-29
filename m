Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3L2DEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:04:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab3L2CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.715426909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 111/185] ARM: footbridge: fix VGA initialisation
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-footbridge/common.c  | 3 +++
 arch/arm/mach-footbridge/dc21285.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-footbridge/common.c
+++ b/arch/arm/mach-footbridge/common.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <video/vga.h>
  
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -197,6 +198,8 @@ void __init footbridge_map_io(void)
 	 */
 	if (footbridge_cfn_mode())
 		iotable_init(ebsa285_host_io_desc, ARRAY_SIZE(ebsa285_host_io_desc));
+
+	vga_base = PCIMEM_BASE;
 }
 
 #ifdef CONFIG_FOOTBRIDGE_ADDIN
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <video/vga.h>
 
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -297,7 +296,6 @@ void __init dc21285_preinit(void)
 	int cfn_mode;
 
 	pcibios_min_mem = 0x81000000;
-	vga_base = PCIMEM_BASE;
 
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)

