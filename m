Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab3CEU4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:56:25 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:52401 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3CEUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:52:53 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v8 1/9] ARM: davinci: move private EDMA API to arm/common
Date: Tue,  5 Mar 2013 15:53:07 -0500
Message-Id: <1362516795-6346-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362516795-6346-1-git-send-email-mporter@ti.com>
References: <1362516795-6346-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mach-davinci/dma.c to common/edma.c so it can be used
by OMAP (specifically AM33xx) as well.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/Kconfig                                   |    1 +
 arch/arm/common/Kconfig                            |    3 +
 arch/arm/common/Makefile                           |    1 +
 arch/arm/{mach-davinci/dma.c => common/edma.c}     |    2 +-
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
 arch/arm/mach-davinci/davinci.h                    |    2 +-
 arch/arm/mach-davinci/devices-tnetv107x.c          |    2 +-
 arch/arm/mach-davinci/devices.c                    |    6 +-
 arch/arm/mach-davinci/dm355.c                      |    2 +-
 arch/arm/mach-davinci/dm365.c                      |    2 +-
 arch/arm/mach-davinci/dm644x.c                     |    2 +-
 arch/arm/mach-davinci/dm646x.c                     |    2 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +-
 drivers/dma/edma.c                                 |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |    1 +
 include/linux/mfd/davinci_voicecodec.h             |    3 +-
 .../mach => include/linux/platform_data}/edma.h    |   89 +-------------------
 include/linux/platform_data/spi-davinci.h          |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 sound/soc/davinci/davinci-sffsdr.c                 |    5 +-
 23 files changed, 33 insertions(+), 104 deletions(-)
 rename arch/arm/{mach-davinci/dma.c => common/edma.c} (99%)
 rename {arch/arm/mach-davinci/include/mach => include/linux/platform_data}/edma.h (59%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..cb80a4d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -956,6 +956,7 @@ config ARCH_DAVINCI
 	select GENERIC_IRQ_CHIP
 	select HAVE_IDE
 	select NEED_MACH_GPIO_H
+	select TI_PRIV_EDMA
 	select USE_OF
 	select ZONE_DMA
 	help
diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
index 9353184..c3a4e9c 100644
--- a/arch/arm/common/Kconfig
+++ b/arch/arm/common/Kconfig
@@ -17,3 +17,6 @@ config SHARP_PARAM
 
 config SHARP_SCOOP
 	bool
+
+config TI_PRIV_EDMA
+	bool
diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index dc8dd0d..9643c50 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_SHARP_PARAM)	+= sharpsl_param.o
 obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
+obj-$(CONFIG_TI_PRIV_EDMA)	+= edma.o
diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/common/edma.c
similarity index 99%
rename from arch/arm/mach-davinci/dma.c
rename to arch/arm/common/edma.c
index 45b7c71..dcaeb8e 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/common/edma.c
@@ -25,7 +25,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 /* Offsets matching "struct edmacc_param" */
 #define PARM_OPT		0x00
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index fb5c1aa..493a36b 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -5,7 +5,7 @@
 
 # Common objects
 obj-y 			:= time.o clock.o serial.o psc.o \
-			   dma.o usb.o common.o sram.o aemif.o
+			   usb.o common.o sram.o aemif.o
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 4f41602..10c9efd 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -26,12 +26,12 @@
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
 #include <mach/irqs.h>
-#include <mach/edma.h>
 #include <mach/mux.h>
 #include <mach/cp_intc.h>
 #include <mach/tnetv107x.h>
diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 12d544b..d26a6bc 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -23,9 +23,9 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/platform_data/davinci_asp.h>
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/keyscan-davinci.h>
 #include <mach/hardware.h>
-#include <mach/edma.h>
 
 #include <media/davinci/vpfe_capture.h>
 #include <media/davinci/vpif_types.h>
diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
index 773ab07..ba37760 100644
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ b/arch/arm/mach-davinci/devices-tnetv107x.c
@@ -18,10 +18,10 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/platform_data/edma.h>
 
 #include <mach/common.h>
 #include <mach/irqs.h>
-#include <mach/edma.h>
 #include <mach/tnetv107x.h>
 
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
index 4c48a36..ca0c7b3 100644
--- a/arch/arm/mach-davinci/devices.c
+++ b/arch/arm/mach-davinci/devices.c
@@ -19,9 +19,10 @@
 #include <mach/irqs.h>
 #include <mach/cputype.h>
 #include <mach/mux.h>
-#include <mach/edma.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <mach/time.h>
+#include <linux/platform_data/edma.h>
+
 
 #include "davinci.h"
 #include "clock.h"
@@ -34,6 +35,9 @@
 #define DM365_MMCSD0_BASE	     0x01D11000
 #define DM365_MMCSD1_BASE	     0x01D00000
 
+#define DAVINCI_DMA_MMCRXEVT	26
+#define DAVINCI_DMA_MMCTXEVT	27
+
 void __iomem  *davinci_sysmod_base;
 
 void davinci_map_sysmod(void)
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index b49c3b7..53998d8 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -19,7 +19,6 @@
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
 #include <mach/irqs.h>
@@ -28,6 +27,7 @@
 #include <mach/common.h>
 #include <linux/platform_data/spi-davinci.h>
 #include <mach/gpio-davinci.h>
+#include <linux/platform_data/edma.h>
 
 #include "davinci.h"
 #include "clock.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 6c39805..9b41d33 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -18,11 +18,11 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index db1dd92..e8bf21f 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -12,11 +12,11 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/irqs.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index ac7b431..6d52a32 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -13,11 +13,11 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 
 #include <asm/mach/map.h>
 
 #include <mach/cputype.h>
-#include <mach/edma.h>
 #include <mach/irqs.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index de439b7..311daec 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -20,8 +20,8 @@
 #include <linux/videodev2.h>
 
 #include <mach/serial.h>
-#include <mach/edma.h>
 #include <mach/pm.h>
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/i2c-davinci.h>
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/usb-davinci.h>
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index cd7e328..5f3e532 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 2063677..f5d46ea 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -35,6 +35,7 @@
 #include <linux/edma.h>
 #include <linux/mmc/mmc.h>
 
+#include <linux/platform_data/edma.h>
 #include <linux/platform_data/mmc-davinci.h>
 
 /*
diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
index 0ab6132..7dd6524 100644
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@ -26,8 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
-
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 /*
  * Register values.
diff --git a/arch/arm/mach-davinci/include/mach/edma.h b/include/linux/platform_data/edma.h
similarity index 59%
rename from arch/arm/mach-davinci/include/mach/edma.h
rename to include/linux/platform_data/edma.h
index 7e84c90..2344ea2 100644
--- a/arch/arm/mach-davinci/include/mach/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -1,28 +1,12 @@
 /*
- *  TI DAVINCI dma definitions
+ *  TI EDMA definitions
  *
- *  Copyright (C) 2006-2009 Texas Instruments.
+ *  Copyright (C) 2006-2013 Texas Instruments.
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 
 /*
@@ -69,11 +53,6 @@ struct edmacc_param {
 	unsigned int ccnt;
 };
 
-#define CCINT0_INTERRUPT     16
-#define CCERRINT_INTERRUPT   17
-#define TCERRINT0_INTERRUPT   18
-#define TCERRINT1_INTERRUPT   19
-
 /* fields in edmacc_param.opt */
 #define SAM		BIT(0)
 #define DAM		BIT(1)
@@ -87,70 +66,6 @@ struct edmacc_param {
 #define TCCHEN		BIT(22)
 #define ITCCHEN		BIT(23)
 
-#define TRWORD (0x7<<2)
-#define PAENTRY (0x1ff<<5)
-
-/* Drivers should avoid using these symbolic names for dm644x
- * channels, and use platform_device IORESOURCE_DMA resources
- * instead.  (Other DaVinci chips have different peripherals
- * and thus have different DMA channel mappings.)
- */
-#define DAVINCI_DMA_MCBSP_TX              2
-#define DAVINCI_DMA_MCBSP_RX              3
-#define DAVINCI_DMA_VPSS_HIST             4
-#define DAVINCI_DMA_VPSS_H3A              5
-#define DAVINCI_DMA_VPSS_PRVU             6
-#define DAVINCI_DMA_VPSS_RSZ              7
-#define DAVINCI_DMA_IMCOP_IMXINT          8
-#define DAVINCI_DMA_IMCOP_VLCDINT         9
-#define DAVINCI_DMA_IMCO_PASQINT         10
-#define DAVINCI_DMA_IMCOP_DSQINT         11
-#define DAVINCI_DMA_SPI_SPIX             16
-#define DAVINCI_DMA_SPI_SPIR             17
-#define DAVINCI_DMA_UART0_URXEVT0        18
-#define DAVINCI_DMA_UART0_UTXEVT0        19
-#define DAVINCI_DMA_UART1_URXEVT1        20
-#define DAVINCI_DMA_UART1_UTXEVT1        21
-#define DAVINCI_DMA_UART2_URXEVT2        22
-#define DAVINCI_DMA_UART2_UTXEVT2        23
-#define DAVINCI_DMA_MEMSTK_MSEVT         24
-#define DAVINCI_DMA_MMCRXEVT             26
-#define DAVINCI_DMA_MMCTXEVT             27
-#define DAVINCI_DMA_I2C_ICREVT           28
-#define DAVINCI_DMA_I2C_ICXEVT           29
-#define DAVINCI_DMA_GPIO_GPINT0          32
-#define DAVINCI_DMA_GPIO_GPINT1          33
-#define DAVINCI_DMA_GPIO_GPINT2          34
-#define DAVINCI_DMA_GPIO_GPINT3          35
-#define DAVINCI_DMA_GPIO_GPINT4          36
-#define DAVINCI_DMA_GPIO_GPINT5          37
-#define DAVINCI_DMA_GPIO_GPINT6          38
-#define DAVINCI_DMA_GPIO_GPINT7          39
-#define DAVINCI_DMA_GPIO_GPBNKINT0       40
-#define DAVINCI_DMA_GPIO_GPBNKINT1       41
-#define DAVINCI_DMA_GPIO_GPBNKINT2       42
-#define DAVINCI_DMA_GPIO_GPBNKINT3       43
-#define DAVINCI_DMA_GPIO_GPBNKINT4       44
-#define DAVINCI_DMA_TIMER0_TINT0         48
-#define DAVINCI_DMA_TIMER1_TINT1         49
-#define DAVINCI_DMA_TIMER2_TINT2         50
-#define DAVINCI_DMA_TIMER3_TINT3         51
-#define DAVINCI_DMA_PWM0                 52
-#define DAVINCI_DMA_PWM1                 53
-#define DAVINCI_DMA_PWM2                 54
-
-/* DA830 specific EDMA3 information */
-#define EDMA_DA830_NUM_DMACH		32
-#define EDMA_DA830_NUM_TCC		32
-#define EDMA_DA830_NUM_PARAMENTRY	128
-#define EDMA_DA830_NUM_EVQUE		2
-#define EDMA_DA830_NUM_TC		2
-#define EDMA_DA830_CHMAP_EXIST		0
-#define EDMA_DA830_NUM_REGIONS		4
-#define DA830_DMACH2EVENT_MAP0		0x000FC03Fu
-#define DA830_DMACH2EVENT_MAP1		0x00000000u
-#define DA830_EDMA_ARM_OWN		0x30FFCCFFu
-
 /*ch_status paramater of callback function possible values*/
 #define DMA_COMPLETE 1
 #define DMA_CC_ERROR 2
diff --git a/include/linux/platform_data/spi-davinci.h b/include/linux/platform_data/spi-davinci.h
index 7af305b..8dc2fa47 100644
--- a/include/linux/platform_data/spi-davinci.h
+++ b/include/linux/platform_data/spi-davinci.h
@@ -19,7 +19,7 @@
 #ifndef __ARCH_ARM_DAVINCI_SPI_H
 #define __ARCH_ARM_DAVINCI_SPI_H
 
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 #define SPI_INTERN_CS	0xFF
 
diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index 484b22c..fd7c45b 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -14,6 +14,7 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 #include <linux/i2c.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index afab81f..9bdd71b 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -17,6 +17,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/genalloc.h>
+#include <linux/platform_data/edma.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-pcm.h
index b6ef703..fbb710c 100644
--- a/sound/soc/davinci/davinci-pcm.h
+++ b/sound/soc/davinci/davinci-pcm.h
@@ -14,7 +14,7 @@
 
 #include <linux/genalloc.h>
 #include <linux/platform_data/davinci_asp.h>
-#include <mach/edma.h>
+#include <linux/platform_data/edma.h>
 
 struct davinci_pcm_dma_params {
 	int channel;			/* sync dma channel ID */
diff --git a/sound/soc/davinci/davinci-sffsdr.c b/sound/soc/davinci/davinci-sffsdr.c
index 5be65aa..76ea586 100644
--- a/sound/soc/davinci/davinci-sffsdr.c
+++ b/sound/soc/davinci/davinci-sffsdr.c
@@ -17,6 +17,7 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/edma.h>
 #include <linux/gpio.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -28,12 +29,14 @@
 #include <asm/plat-sffsdr/sffsdr-fpga.h>
 #endif
 
-#include <mach/edma.h>
 
 #include "../codecs/pcm3008.h"
 #include "davinci-pcm.h"
 #include "davinci-i2s.h"
 
+#define DAVINCI_DMA_MCBSP_TX	2
+#define DAVINCI_DMA_MCBSP_RX	3
+
 /*
  * CLKX and CLKR are the inputs for the Sample Rate Generator.
  * FSX and FSR are outputs, driven by the sample Rate Generator.
-- 
1.7.9.5

