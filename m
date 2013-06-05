Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3FEM1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:27:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:39597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab3FEM0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,806,1363158000"; 
   d="scan'208";a="345146344"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
Date: Wed,  5 Jun 2013 15:26:44 +0300
Message-Id: <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_dmac driver is going to be split into multiple files. To make this more
convenient move it to an own directory.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                         |  3 +--
 drivers/dma/Kconfig                 | 20 +-------------------
 drivers/dma/Makefile                |  2 +-
 drivers/dma/dw/Kconfig              | 23 +++++++++++++++++++++++
 drivers/dma/dw/Makefile             |  1 +
 drivers/dma/{ => dw}/dw_dmac.c      |  2 +-
 drivers/dma/{ => dw}/dw_dmac_regs.h |  0
 7 files changed, 28 insertions(+), 23 deletions(-)
 create mode 100644 drivers/dma/dw/Kconfig
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{ => dw}/dw_dmac.c (99%)
 rename drivers/dma/{ => dw}/dw_dmac_regs.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index f554c8b..e605ee1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7005,8 +7005,7 @@ SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
-F:	drivers/dma/dw_dmac_regs.h
-F:	drivers/dma/dw_dmac.c
+F:	drivers/dma/dw/
 
 SYNOPSYS DESIGNWARE MMC/SD/SDIO DRIVER
 M:	Seungwon Jeon <tgih.jun@samsung.com>
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e992489..146a1d8 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -79,25 +79,7 @@ config INTEL_IOP_ADMA
 	help
 	  Enable support for the Intel(R) IOP Series RAID engines.
 
-config DW_DMAC
-	tristate "Synopsys DesignWare AHB DMA support"
-	depends on GENERIC_HARDIRQS
-	select DMA_ENGINE
-	default y if CPU_AT32AP7000
-	help
-	  Support the Synopsys DesignWare AHB DMA controller.  This
-	  can be integrated in chips such as the Atmel AT32ap7000.
-
-config DW_DMAC_BIG_ENDIAN_IO
-	bool "Use big endian I/O register access"
-	default y if AVR32
-	depends on DW_DMAC
-	help
-	  Say yes here to use big endian I/O access when reading and writing
-	  to the DMA controller registers. This is needed on some platforms,
-	  like the Atmel AVR32 architecture.
-
-	  If unsure, use the default setting.
+source "drivers/dma/dw/Kconfig"
 
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index a2b0df5..ac44ca0 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
 obj-$(CONFIG_PPC_BESTCOMM) += bestcomm/
 obj-$(CONFIG_MV_XOR) += mv_xor.o
-obj-$(CONFIG_DW_DMAC) += dw_dmac.o
+obj-$(CONFIG_DW_DMAC) += dw/
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
new file mode 100644
index 0000000..38a215a
--- /dev/null
+++ b/drivers/dma/dw/Kconfig
@@ -0,0 +1,23 @@
+#
+# DMA engine configuration for dw
+#
+
+config DW_DMAC
+	tristate "Synopsys DesignWare AHB DMA support"
+	depends on GENERIC_HARDIRQS
+	select DMA_ENGINE
+	default y if CPU_AT32AP7000
+	help
+	  Support the Synopsys DesignWare AHB DMA controller. This
+	  can be integrated in chips such as the Atmel AT32ap7000.
+
+config DW_DMAC_BIG_ENDIAN_IO
+	bool "Use big endian I/O register access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes here to use big endian I/O access when reading and writing
+	  to the DMA controller registers. This is needed on some platforms,
+	  like the Atmel AVR32 architecture.
+
+	  If unsure, use the default setting.
diff --git a/drivers/dma/dw/Makefile b/drivers/dma/dw/Makefile
new file mode 100644
index 0000000..dd8d993
--- /dev/null
+++ b/drivers/dma/dw/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DW_DMAC) += dw_dmac.o
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw/dw_dmac.c
similarity index 99%
rename from drivers/dma/dw_dmac.c
rename to drivers/dma/dw/dw_dmac.c
index 2b65ba6..15f3f4f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw/dw_dmac.c
@@ -28,8 +28,8 @@
 #include <linux/acpi.h>
 #include <linux/acpi_dma.h>
 
+#include "../dmaengine.h"
 #include "dw_dmac_regs.h"
-#include "dmaengine.h"
 
 /*
  * This supports the Synopsys "DesignWare AHB Central DMA Controller",
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw/dw_dmac_regs.h
similarity index 100%
rename from drivers/dma/dw_dmac_regs.h
rename to drivers/dma/dw/dw_dmac_regs.h
-- 
1.8.2.rc0.22.gb3600c3

