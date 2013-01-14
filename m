Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3ANCCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:02:20 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40544 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3ANCCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:02:18 -0500
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
Subject: [PATCH 1/2] sp5100_tco: Fix wrong indirect I/O access for getting value of reserved bits
Date: Mon, 14 Jan 2013 11:01:57 +0900
Message-Id: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of SB800 or later chipset and re-programming MMIO address(*),
sp5100_tco module may read incorrect value of reserved bit, because the module
reads a value from an incorrect I/O address. However, this bug doesn't cause
a problem, because when re-programming MMIO address, by chance the module
writes zero (this is BIOS's default value) to the low three bits of register.
* In most cases, PC with SB8x0 or later chipset doesn't need to re-programming
  MMIO address, because such PC can enable AcpiMmio and can use 0xfed80b00 for
  watchdog register base address.

This patch fixes this bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
---
 drivers/watchdog/sp5100_tco.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 2b0e000..5dfe86e 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -500,14 +500,15 @@ static unsigned char sp5100_tco_setupdevice(void)
 	/* Restore to the low three bits, if chipset is SB8x0(or later) */
 	if (sp5100_tco_pci->revision >= 0x40) {
 		u8 reserved_bit;
-		reserved_bit = inb(base_addr) & 0x7;
+		outb(base_addr+0, index_reg);
+		reserved_bit = inb(data_reg) & 0x7;
 		val |= (u32)reserved_bit;
 	}
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
 	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xf8, data_reg);
+	outb((val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
 	outb((val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-- 
1.7.11.7

