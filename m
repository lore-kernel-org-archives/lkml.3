Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3BDEE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:04:58 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33224 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3BDEE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:04:57 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kdump: do not drop entire e820 in crash kernel
Cc: mingo@elte.hu, hpa@zytor.com, venkatesh.pallipadi@intel.com,
        kexec@lists.infradead.org
Message-Id: <E1U2DId-0001E4-Df@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Sun, 03 Feb 2013 22:04:55 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The crash kernel is not able to find its root device if that device is not
on PCI 0.

This is because it is booted with the command line option memmap=exactmap
which currently clears the e820 table.  So ACPI processing does not
find reserved i/o spaces. 

This works for a device on PCI 0 because ACPI falls back to a legacy mode.
But the error message " [Firmware Bug]: PCI: MMCONFIG at
 [mem 0x80000000-0x80cfffff] not reserved in ACPI motherboard resources"
is written to the log even in this functioning case.

It fails for some devices on UV2, and only for UV2, because SGI seems to
be the only manufacturer currently using the extended PCI(>0).

The fix is to not drop the entire e820 table on a memmap=exactmap, but
to preserve all the non-E820_RAM reservations that the BIOS has made.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/e820.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linus.current/arch/x86/kernel/e820.c
===================================================================
--- linus.current.orig/arch/x86/kernel/e820.c
+++ linus.current/arch/x86/kernel/e820.c
@@ -839,6 +839,8 @@ static int __init parse_memmap_opt(char
 {
 	char *oldp;
 	u64 start_at, mem_size;
+	int i;
+	struct e820entry *curp, *availp;
 
 	if (!p)
 		return -EINVAL;
@@ -852,7 +854,17 @@ static int __init parse_memmap_opt(char
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
-		e820.nr_map = 0;
+		/* keep everything that was reserved by the BIOS */
+		for (i = 0, curp = &e820.map[0], availp = &e820.map[0];
+						i < e820.nr_map; i++, curp++) {
+			if (curp->type != E820_RAM) {
+				if (curp != availp) {
+					*availp = *curp;
+					availp++;
+				}
+			}
+		}
+		e820.nr_map = availp - &e820.map[0];
 		userdef = 1;
 		return 0;
 	}
