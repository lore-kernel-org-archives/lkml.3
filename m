Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaGITEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:04:09 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47307 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGITEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:04:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jean Delvare <jdelvare@suse.de>, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] firewire: IEEE 1394 (FireWire) support should depend on HAS_DMA
Date: Wed,  9 Jul 2014 21:04:00 +0200
Message-Id: <1404932640-9029-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b3d681a4fc108f9653bbb44e4f4e72db2b8a5734 ("firewire: Use
COMPILE_TEST for build testing") added COMPILE_TEST as an alternative
dependency for the purpose of build testing the firewire core.
However, this bypasses all other implicit dependencies assumed by PCI,
like HAS_DMA.

If NO_DMA=y:

    drivers/built-in.o: In function `fw_iso_buffer_destroy':
    (.text+0x36a096): undefined reference to `dma_unmap_page'
    drivers/built-in.o: In function `fw_iso_buffer_map_dma':
    (.text+0x36a164): undefined reference to `dma_map_page'
    drivers/built-in.o: In function `fw_iso_buffer_map_dma':
    (.text+0x36a172): undefined reference to `dma_mapping_error'
    drivers/built-in.o: In function `sbp2_send_management_orb':
    sbp2.c:(.text+0x36c6b4): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36c6c8): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36c772): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36c786): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36c854): undefined reference to `dma_unmap_single'
    sbp2.c:(.text+0x36c872): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sbp2_map_scatterlist':
    sbp2.c:(.text+0x36ccbc): undefined reference to `scsi_dma_map'
    sbp2.c:(.text+0x36cd36): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36cd4e): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36cd84): undefined reference to `scsi_dma_unmap'
    drivers/built-in.o: In function `sbp2_unmap_scatterlist':
    sbp2.c:(.text+0x36cda6): undefined reference to `scsi_dma_unmap'
    sbp2.c:(.text+0x36cdc6): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `complete_command_orb':
    sbp2.c:(.text+0x36d6ac): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sbp2_scsi_queuecommand':
    sbp2.c:(.text+0x36d8e0): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36d8f6): undefined reference to `dma_mapping_error'

Add an explicit dependency on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/firewire/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 4199849e3758..145974f9662b 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,4 +1,5 @@
 menu "IEEE 1394 (FireWire) support"
+	depends on HAS_DMA
 	depends on PCI || COMPILE_TEST
 	# firewire-core does not depend on PCI but is
 	# not useful without PCI controller driver
-- 
1.9.1

