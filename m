Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaABROD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:14:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaABRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:10:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 80/91] ARM: footbridge: fix VGA initialisation
Date: Thu,  2 Jan 2014 09:04:55 -0800
Message-Id: <1388682306-30859-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-footbridge/common.c  | 3 +++
 arch/arm/mach-footbridge/dc21285.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-footbridge/common.c b/arch/arm/mach-footbridge/common.c
index a42b369..95d0b6e 100644
--- a/arch/arm/mach-footbridge/common.c
+++ b/arch/arm/mach-footbridge/common.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <video/vga.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -196,6 +197,8 @@ void __init footbridge_map_io(void)
 		iotable_init(ebsa285_host_io_desc, ARRAY_SIZE(ebsa285_host_io_desc));
 		pci_map_io_early(__phys_to_pfn(DC21285_PCI_IO));
 	}
+
+	vga_base = PCIMEM_BASE;
 }
 
 void footbridge_restart(char mode, const char *cmd)
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 3490a24..7c2fdae 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <video/vga.h>
 
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
@@ -291,7 +290,6 @@ void __init dc21285_preinit(void)
 	int cfn_mode;
 
 	pcibios_min_mem = 0x81000000;
-	vga_base = PCIMEM_BASE;
 
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)
-- 
1.8.3.2

