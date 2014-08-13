Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaHMRwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:52:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaHMRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:52:37 -0400
Message-ID: <53EBA5E3.4060104@infradead.org>
Date: Wed, 13 Aug 2014 10:52:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Holger Waechtler <holger@convergence.de>,
        Oliver Endriss <o.endriss@gmx.de>
Subject: [PATCH] media: ttpci: build av7110_ir.c only when allowed by CONFIG_INPUT_EVDEV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build when CONFIG_INPUT_EVDEV=m and DVB_AV7110=y.
Only build av7110_ir.c when CONFIG_INPUT_EVDEV is compatible with
CONFIG_DVB_AV7110.

Fixes these build errors:

drivers/built-in.o: In function `input_sync':
av7110_ir.c:(.text+0x1223ac): undefined reference to `input_event'
drivers/built-in.o: In function `av7110_emit_key':
av7110_ir.c:(.text+0x12247c): undefined reference to `input_event'
av7110_ir.c:(.text+0x122495): undefined reference to `input_event'
av7110_ir.c:(.text+0x122569): undefined reference to `input_event'
av7110_ir.c:(.text+0x1225a7): undefined reference to `input_event'
drivers/built-in.o:av7110_ir.c:(.text+0x122629): more undefined
references to `input_event' follow
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x1227e4): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x12298f): undefined reference to `input_register_device'
drivers/built-in.o: In function `av7110_ir_init':
(.text+0x12299e): undefined reference to `input_free_device'
drivers/built-in.o: In function `av7110_ir_exit':
(.text+0x122a94): undefined reference to `input_unregister_device'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Cc: Holger Waechtler <holger@convergence.de>
Cc: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/pci/ttpci/Kconfig  |    4 ++++
 drivers/media/pci/ttpci/Makefile |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-next-20140813/drivers/media/pci/ttpci/Kconfig
===================================================================
--- linux-next-20140813.orig/drivers/media/pci/ttpci/Kconfig
+++ linux-next-20140813/drivers/media/pci/ttpci/Kconfig
@@ -1,8 +1,12 @@
+config DVB_AV7110_IR
+	bool
+
 config DVB_AV7110
 	tristate "AV7110 cards"
 	depends on DVB_CORE && PCI && I2C
 	select TTPCI_EEPROM
 	select VIDEO_SAA7146_VV
+	select DVB_AV7110_IR if INPUT_EVDEV=y || INPUT_EVDEV=DVB_AV7110
 	depends on VIDEO_DEV	# dependencies of VIDEO_SAA7146_VV
 	select DVB_VES1820 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_VES1X93 if MEDIA_SUBDRV_AUTOSELECT
Index: linux-next-20140813/drivers/media/pci/ttpci/Makefile
===================================================================
--- linux-next-20140813.orig/drivers/media/pci/ttpci/Makefile
+++ linux-next-20140813/drivers/media/pci/ttpci/Makefile
@@ -5,7 +5,7 @@
 
 dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o
 
-ifdef CONFIG_INPUT_EVDEV
+ifdef CONFIG_DVB_AV7110_IR
 dvb-ttpci-objs += av7110_ir.o
 endif
 
