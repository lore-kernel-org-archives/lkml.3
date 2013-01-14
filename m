Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3ANCCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:02:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35316 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3ANCCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:02:30 -0500
From: Takahisa Tanaka <mc74hc00@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Takahisa Tanaka <mc74hc00@gmail.com>
Subject: [PATCH 2/2] sp5100_tco: Write back the original value to reserved bits, instead of zero
Date: Mon, 14 Jan 2013 11:01:58 +0900
Message-Id: <1358128918-4415-2-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
reserved bits. The module, however, shouldn't depend on specific default
value, and should perform a read-merge-write operation for the reserved
bits.

This patch makes the sp5100_tco module perform a read-merge-write operation
on all the chipset (sp5100, sb7x0, sb8x0 or later).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
---
 drivers/watchdog/sp5100_tco.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 5dfe86e..e3b8f75 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -361,7 +361,7 @@ static unsigned char sp5100_tco_setupdevice(void)
 {
 	struct pci_dev *dev = NULL;
 	const char *dev_name = NULL;
-	u32 val;
+	u32 val, tmp_val;
 	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
@@ -497,31 +497,19 @@ static unsigned char sp5100_tco_setupdevice(void)
 		pr_debug("Got 0x%04x from resource tree\n", val);
 	}
 
-	/* Restore to the low three bits, if chipset is SB8x0(or later) */
-	if (sp5100_tco_pci->revision >= 0x40) {
-		u8 reserved_bit;
-		outb(base_addr+0, index_reg);
-		reserved_bit = inb(data_reg) & 0x7;
-		val |= (u32)reserved_bit;
-	}
+	/* Restore to the low three bits */
+	outb(base_addr+0, index_reg);
+	tmp_val = val | (inb(data_reg) & 0x7);
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
-	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xff, data_reg);
+	outb((tmp_val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
-	outb((val >>  8) & 0xff, data_reg);
+	outb((tmp_val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-	outb((val >> 16) & 0xff, data_reg);
+	outb((tmp_val >> 16) & 0xff, data_reg);
 	outb(base_addr+3, index_reg);
-	outb((val >> 24) & 0xff, data_reg);
-
-	/*
-	 * Clear unnecessary the low three bits,
-	 * if chipset is SB8x0(or later)
-	 */
-	if (sp5100_tco_pci->revision >= 0x40)
-		val &= ~0x7;
+	outb((tmp_val >> 24) & 0xff, data_reg);
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								   dev_name)) {
-- 
1.7.11.7

