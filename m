Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaGMDHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:07:03 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33329 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaGMDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:06:56 -0400
Message-ID: <53C1F7C4.2010901@gmail.com>
Date: Sun, 13 Jul 2014 11:06:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: stefanr@s5r6.in-berlin.de
CC: linux1394-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers: firewire: Let several sub-modules depend on HAS_DMA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several sub-modules of 'firewire' need HAS_DMA, so let them depend on it.
FIREWIRE_NET and FIREWIRE_OHCI use 'core-iso.c' which also needs HAS_DMA,
so need 'ifdef' the related function by CONFIG_HAS_DMA in 'core-iso.c'.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "dma_mapping_error" [drivers/firewire/firewire-sbp2.ko] undefined!
  ERROR: "dma_map_single" [drivers/firewire/firewire-sbp2.ko] undefined!
  ERROR: "dma_unmap_single" [drivers/firewire/firewire-sbp2.ko] undefined!
  ERROR: "scsi_dma_map" [drivers/firewire/firewire-sbp2.ko] undefined!
  ERROR: "scsi_dma_unmap" [drivers/firewire/firewire-sbp2.ko] undefined!
  ERROR: "dma_mapping_error" [drivers/firewire/firewire-core.ko] undefined!
  ERROR: "dma_map_page" [drivers/firewire/firewire-core.ko] undefined!
  ERROR: "dma_unmap_page" [drivers/firewire/firewire-core.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/firewire/Kconfig    |  6 +++---
 drivers/firewire/core-iso.c | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 4199849..fd75278 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -19,7 +19,7 @@ config FIREWIRE
 
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
-	depends on PCI && FIREWIRE && MMU
+	depends on PCI && FIREWIRE && MMU && HAS_DMA
 	help
 	  Enable this driver if you have a FireWire controller based
 	  on the OHCI specification.  For all practical purposes, this
@@ -30,7 +30,7 @@ config FIREWIRE_OHCI
 
 config FIREWIRE_SBP2
 	tristate "Storage devices (SBP-2 protocol)"
-	depends on FIREWIRE && SCSI
+	depends on FIREWIRE && SCSI && HAS_DMA
 	help
 	  This option enables you to use SBP-2 devices connected to a
 	  FireWire bus.  SBP-2 devices include storage devices like
@@ -45,7 +45,7 @@ config FIREWIRE_SBP2
 
 config FIREWIRE_NET
 	tristate "IP networking over 1394"
-	depends on FIREWIRE && INET
+	depends on FIREWIRE && INET && HAS_DMA
 	help
 	  This enables IPv4/IPv6 over IEEE 1394, providing IP connectivity
 	  with other implementations of RFC 2734/3146 as found on several
diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
index 38c0aa6..995f038 100644
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -64,6 +64,7 @@ int fw_iso_buffer_alloc(struct fw_iso_buffer *buffer, int page_count)
 	return 0;
 }
 
+#ifdef CONFIG_HAS_DMA
 int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
 			  enum dma_data_direction direction)
 {
@@ -86,6 +87,13 @@ int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
 
 	return 0;
 }
+#else
+int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
+			  enum dma_data_direction direction)
+{
+	return -ENXIO;
+}
+#endif
 
 int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 		       int page_count, enum dma_data_direction direction)
@@ -122,6 +130,7 @@ int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
 	return 0;
 }
 
+#ifdef CONFIG_HAS_DMA
 void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
 			   struct fw_card *card)
 {
@@ -141,6 +150,12 @@ void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
 	buffer->page_count = 0;
 	buffer->page_count_mapped = 0;
 }
+#else
+void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
+			   struct fw_card *card)
+{
+}
+#endif
 EXPORT_SYMBOL(fw_iso_buffer_destroy);
 
 /* Convert DMA address to offset into virtually contiguous buffer. */
-- 
1.7.11.7
