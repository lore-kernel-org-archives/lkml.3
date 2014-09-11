Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaIKPz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:55:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47796 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757220AbaIKPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:54:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/7] ARM: at91: SAMA5D4 SoC detection code and low level routines
Date: Thu, 11 Sep 2014 17:54:09 +0200
Message-Id: <1410450852-1834-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410450852-1834-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

SoC identification code, kernel uncompress and low level
debugging routines update.
On SAMA5D4, DBGU is at another address AT91_BASE_DBGU2 so another
round of detection is needed. We also had to differentiate with
SAMA5D3 SoC family and rename some variables.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt-sama5.c           | 16 ++++-
 arch/arm/mach-at91/generic.h                  |  1 +
 arch/arm/mach-at91/include/mach/cpu.h         | 13 +++-
 arch/arm/mach-at91/include/mach/debug-macro.S |  5 +-
 arch/arm/mach-at91/include/mach/hardware.h    | 19 +++++-
 arch/arm/mach-at91/include/mach/uncompress.h  | 21 ++++--
 arch/arm/mach-at91/sama5d4.c                  | 28 ++++++++
 arch/arm/mach-at91/setup.c                    | 97 +++++++++++++++++++++++++--
 8 files changed, 188 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 3b43be41ddf8..e2f19233086f 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -59,7 +59,7 @@ static void __init sama5_dt_device_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *sama5_dt_board_compat[] __initdata = {
+static const char *sama5_dt_board_compat[] __initconst = {
 	"atmel,sama5",
 	NULL
 };
@@ -72,3 +72,17 @@ DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_dt_board_compat,
 MACHINE_END
+
+static const char *sama5_alt_dt_board_compat[] __initconst = {
+	"atmel,sama5d4",
+	NULL
+};
+
+DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
+	/* Maintainer: Atmel */
+	.init_time	= sama5_dt_timer_init,
+	.map_io		= at91_alt_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sama5_dt_device_init,
+	.dt_compat	= sama5_alt_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 733ac0eef839..ae67bf52654b 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -14,6 +14,7 @@
 
  /* Map io */
 extern void __init at91_map_io(void);
+extern void __init at91_alt_map_io(void);
 extern void __init at91_init_sram(int bank, unsigned long base,
 				  unsigned int length);
 
diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index d77572e8cb15..b27e9ca65653 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -36,7 +36,7 @@
 #define ARCH_ID_AT91M40807	0x14080745
 #define ARCH_ID_AT91R40008	0x44000840
 
-#define ARCH_ID_SAMA5D3		0x8A5C07C0
+#define ARCH_ID_SAMA5		0x8A5C07C0
 
 #define ARCH_EXID_AT91SAM9M11	0x00000001
 #define ARCH_EXID_AT91SAM9M10	0x00000002
@@ -49,12 +49,19 @@
 #define ARCH_EXID_AT91SAM9G25	0x00000003
 #define ARCH_EXID_AT91SAM9X25	0x00000004
 
+#define ARCH_EXID_SAMA5D3	0x00004300
 #define ARCH_EXID_SAMA5D31	0x00444300
 #define ARCH_EXID_SAMA5D33	0x00414300
 #define ARCH_EXID_SAMA5D34	0x00414301
 #define ARCH_EXID_SAMA5D35	0x00584300
 #define ARCH_EXID_SAMA5D36	0x00004301
 
+#define ARCH_EXID_SAMA5D4	0x00000007
+#define ARCH_EXID_SAMA5D41	0x00000001
+#define ARCH_EXID_SAMA5D42	0x00000002
+#define ARCH_EXID_SAMA5D43	0x00000003
+#define ARCH_EXID_SAMA5D44	0x00000004
+
 #define ARCH_FAMILY_AT91X92	0x09200000
 #define ARCH_FAMILY_AT91SAM9	0x01900000
 #define ARCH_FAMILY_AT91SAM9XE	0x02900000
@@ -111,6 +118,10 @@ enum at91_soc_subtype {
 	AT91_SOC_SAMA5D31, AT91_SOC_SAMA5D33, AT91_SOC_SAMA5D34,
 	AT91_SOC_SAMA5D35, AT91_SOC_SAMA5D36,
 
+	/* SAMA5D4 */
+	AT91_SOC_SAMA5D41, AT91_SOC_SAMA5D42, AT91_SOC_SAMA5D43,
+	AT91_SOC_SAMA5D44,
+
 	/* No subtype for this SoC */
 	AT91_SOC_SUBTYPE_NONE,
 
diff --git a/arch/arm/mach-at91/include/mach/debug-macro.S b/arch/arm/mach-at91/include/mach/debug-macro.S
index c6bb9e2d9baa..2103a90f2261 100644
--- a/arch/arm/mach-at91/include/mach/debug-macro.S
+++ b/arch/arm/mach-at91/include/mach/debug-macro.S
@@ -16,8 +16,11 @@
 
 #if defined(CONFIG_AT91_DEBUG_LL_DBGU0)
 #define AT91_DBGU AT91_BASE_DBGU0
-#else
+#elif defined(CONFIG_AT91_DEBUG_LL_DBGU1)
 #define AT91_DBGU AT91_BASE_DBGU1
+#else
+/* On sama5d4, use USART3 as low level serial console */
+#define AT91_DBGU SAMA5D4_BASE_USART3
 #endif
 
 	.macro	addruart, rp, rv, tmp
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index 56338245653a..d84776f6b8ac 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -19,8 +19,10 @@
 /* DBGU base */
 /* rm9200, 9260/9g20, 9261/9g10, 9rl */
 #define AT91_BASE_DBGU0	0xfffff200
-/* 9263, 9g45 */
+/* 9263, 9g45, sama5d3 */
 #define AT91_BASE_DBGU1	0xffffee00
+/* sama5d4 */
+#define AT91_BASE_DBGU2	0xfc069000
 
 #if defined(CONFIG_ARCH_AT91X40)
 #include <mach/at91x40.h>
@@ -34,6 +36,7 @@
 #include <mach/at91sam9x5.h>
 #include <mach/at91sam9n12.h>
 #include <mach/sama5d3.h>
+#include <mach/sama5d4.h>
 
 /*
  * On all at91 except rm9200 and x40 have the System Controller starts
@@ -47,6 +50,11 @@
  * and map the same memory space
  */
 #define AT91_BASE_SYS	0xffffc000
+
+/*
+ * On sama5d4 there is no system controller, we map some needed peripherals
+ */
+#define AT91_ALT_BASE_SYS	0xfc069000
 #endif
 
 /*
@@ -69,6 +77,13 @@
  */
 #define AT91_IO_PHYS_BASE	0xFFF78000
 #define AT91_IO_VIRT_BASE	IOMEM(0xFF000000 - AT91_IO_SIZE)
+
+/*
+ * On sama5d4, remap the peripherals from address 0xFC069000 .. 0xFC06F000
+ * to 0xFB069000 .. 0xFB06F000.  (24Kb)
+ */
+#define AT91_ALT_IO_PHYS_BASE	AT91_ALT_BASE_SYS
+#define AT91_ALT_IO_VIRT_BASE	IOMEM(0xFB069000)
 #else
 /*
  * Identity mapping for the non MMU case.
@@ -81,11 +96,13 @@
 
  /* Convert a physical IO address to virtual IO address */
 #define AT91_IO_P2V(x)		((x) - AT91_IO_PHYS_BASE + AT91_IO_VIRT_BASE)
+#define AT91_ALT_IO_P2V(x)	((x) - AT91_ALT_IO_PHYS_BASE + AT91_ALT_IO_VIRT_BASE)
 
 /*
  * Virtual to Physical Address mapping for IO devices.
  */
 #define AT91_VA_BASE_SYS	AT91_IO_P2V(AT91_BASE_SYS)
+#define AT91_ALT_VA_BASE_SYS	AT91_ALT_IO_P2V(AT91_ALT_BASE_SYS)
 
  /* Internal SRAM is mapped below the IO devices */
 #define AT91_SRAM_MAX		SZ_1M
diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
index 4bb644f8e87c..acb2d890ad7e 100644
--- a/arch/arm/mach-at91/include/mach/uncompress.h
+++ b/arch/arm/mach-at91/include/mach/uncompress.h
@@ -94,7 +94,7 @@ static const u32 uarts_sam9x5[] = {
 	0,
 };
 
-static const u32 uarts_sama5[] = {
+static const u32 uarts_sama5d3[] = {
 	AT91_BASE_DBGU1,
 	SAMA5D3_BASE_USART0,
 	SAMA5D3_BASE_USART1,
@@ -103,6 +103,12 @@ static const u32 uarts_sama5[] = {
 	0,
 };
 
+static const u32 uarts_sama5d4[] = {
+	AT91_BASE_DBGU2,
+	SAMA5D4_BASE_USART3,
+	0,
+};
+
 static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
 {
 	u32 cidr, socid;
@@ -134,8 +140,14 @@ static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
 	case ARCH_ID_AT91SAM9X5:
 		return uarts_sam9x5;
 
-	case ARCH_ID_SAMA5D3:
-		return uarts_sama5;
+	case ARCH_ID_SAMA5:
+		cidr = __raw_readl(dbgu_base + AT91_DBGU_EXID);
+		if (cidr & ARCH_EXID_SAMA5D3)
+			return uarts_sama5d3;
+		else if (cidr & ARCH_EXID_SAMA5D4)
+			return uarts_sama5d4;
+
+		break;
 	}
 
 	/* at91sam9g10 */
@@ -156,9 +168,10 @@ static inline void arch_decomp_setup(void)
 	const u32* usarts;
 
 	usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU0);
-
 	if (!usarts)
 		usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU1);
+	if (!usarts)
+		usarts = decomp_soc_detect((void __iomem *)AT91_BASE_DBGU2);
 	if (!usarts) {
 		at91_uart = NULL;
 		return;
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index f81f11ed8deb..7638509639f4 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -25,9 +25,37 @@
 /* --------------------------------------------------------------------
  *  Processor initialization
  * -------------------------------------------------------------------- */
+static struct map_desc at91_io_desc[] __initdata = {
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_MPDDRC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_PMC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_PMC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{ /* On sama5d4, we use USART3 as serial console */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_USART3),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_USART3),
+	.length         = SZ_256,
+	.type           = MT_DEVICE,
+	},
+	{ /* A bunch of peripheral with fine grained IO space */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_SYS2),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_SYS2),
+	.length         = SZ_2K,
+	.type           = MT_DEVICE,
+	},
+};
+
 
 static void __init sama5d4_map_io(void)
 {
+	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
 	at91_init_sram(0, SAMA5D4_NS_SRAM_BASE, SAMA5D4_NS_SRAM_SIZE);
 }
 
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index d2cade21ebd7..25e583b513bf 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -98,6 +98,13 @@ static struct map_desc at91_io_desc __initdata __maybe_unused = {
 	.type		= MT_DEVICE,
 };
 
+static struct map_desc at91_alt_io_desc __initdata __maybe_unused = {
+	.virtual	= (unsigned long)AT91_ALT_VA_BASE_SYS,
+	.pfn		= __phys_to_pfn(AT91_ALT_BASE_SYS),
+	.length		= 24 * SZ_1K,
+	.type		= MT_DEVICE,
+};
+
 static void __init soc_detect(u32 dbgu_base)
 {
 	u32 cidr, socid;
@@ -160,9 +167,12 @@ static void __init soc_detect(u32 dbgu_base)
 		at91_boot_soc = at91sam9n12_soc;
 		break;
 
-	case ARCH_ID_SAMA5D3:
-		at91_soc_initdata.type = AT91_SOC_SAMA5D3;
-		at91_boot_soc = sama5d3_soc;
+	case ARCH_ID_SAMA5:
+		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
+		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
+			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
+			at91_boot_soc = sama5d3_soc;
+		}
 		break;
 	}
 
@@ -185,7 +195,8 @@ static void __init soc_detect(u32 dbgu_base)
 	at91_soc_initdata.cidr = cidr;
 
 	/* sub version of soc */
-	at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
+	if (!at91_soc_initdata.exid)
+		at91_soc_initdata.exid = __raw_readl(AT91_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
 
 	if (at91_soc_initdata.type == AT91_SOC_SAM9G45) {
 		switch (at91_soc_initdata.exid) {
@@ -242,6 +253,54 @@ static void __init soc_detect(u32 dbgu_base)
 	}
 }
 
+static void __init alt_soc_detect(u32 dbgu_base)
+{
+	u32 cidr, socid;
+
+	/* SoC ID */
+	cidr = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_CIDR);
+	socid = cidr & ~AT91_CIDR_VERSION;
+
+	switch (socid) {
+	case ARCH_ID_SAMA5:
+		at91_soc_initdata.exid = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
+		if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D3) {
+			at91_soc_initdata.type = AT91_SOC_SAMA5D3;
+			at91_boot_soc = sama5d3_soc;
+		} else if (at91_soc_initdata.exid & ARCH_EXID_SAMA5D4) {
+			at91_soc_initdata.type = AT91_SOC_SAMA5D4;
+			at91_boot_soc = sama5d4_soc;
+		}
+		break;
+	}
+
+	if (!at91_soc_is_detected())
+		return;
+
+	at91_soc_initdata.cidr = cidr;
+
+	/* sub version of soc */
+	if (!at91_soc_initdata.exid)
+		at91_soc_initdata.exid = __raw_readl(AT91_ALT_IO_P2V(dbgu_base) + AT91_DBGU_EXID);
+
+	if (at91_soc_initdata.type == AT91_SOC_SAMA5D4) {
+		switch (at91_soc_initdata.exid) {
+		case ARCH_EXID_SAMA5D41:
+			at91_soc_initdata.subtype = AT91_SOC_SAMA5D41;
+			break;
+		case ARCH_EXID_SAMA5D42:
+			at91_soc_initdata.subtype = AT91_SOC_SAMA5D42;
+			break;
+		case ARCH_EXID_SAMA5D43:
+			at91_soc_initdata.subtype = AT91_SOC_SAMA5D43;
+			break;
+		case ARCH_EXID_SAMA5D44:
+			at91_soc_initdata.subtype = AT91_SOC_SAMA5D44;
+			break;
+		}
+	}
+}
+
 static const char *soc_name[] = {
 	[AT91_SOC_RM9200]	= "at91rm9200",
 	[AT91_SOC_SAM9260]	= "at91sam9260",
@@ -254,6 +313,7 @@ static const char *soc_name[] = {
 	[AT91_SOC_SAM9X5]	= "at91sam9x5",
 	[AT91_SOC_SAM9N12]	= "at91sam9n12",
 	[AT91_SOC_SAMA5D3]	= "sama5d3",
+	[AT91_SOC_SAMA5D4]	= "sama5d4",
 	[AT91_SOC_UNKNOWN]	= "Unknown",
 };
 
@@ -281,6 +341,10 @@ static const char *soc_subtype_name[] = {
 	[AT91_SOC_SAMA5D34]	= "sama5d34",
 	[AT91_SOC_SAMA5D35]	= "sama5d35",
 	[AT91_SOC_SAMA5D36]	= "sama5d36",
+	[AT91_SOC_SAMA5D41]	= "sama5d41",
+	[AT91_SOC_SAMA5D42]	= "sama5d42",
+	[AT91_SOC_SAMA5D43]	= "sama5d43",
+	[AT91_SOC_SAMA5D44]	= "sama5d44",
 	[AT91_SOC_SUBTYPE_NONE]	= "None",
 	[AT91_SOC_SUBTYPE_UNKNOWN] = "Unknown",
 };
@@ -319,6 +383,31 @@ void __init at91_map_io(void)
 		at91_boot_soc.map_io();
 }
 
+void __init at91_alt_map_io(void)
+{
+	/* Map peripherals */
+	iotable_init(&at91_alt_io_desc, 1);
+
+	at91_soc_initdata.type = AT91_SOC_UNKNOWN;
+	at91_soc_initdata.subtype = AT91_SOC_SUBTYPE_UNKNOWN;
+
+	alt_soc_detect(AT91_BASE_DBGU2);
+	if (!at91_soc_is_detected())
+		panic("AT91: Impossible to detect the SOC type");
+
+	pr_info("AT91: Detected soc type: %s\n",
+		at91_get_soc_type(&at91_soc_initdata));
+	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
+		pr_info("AT91: Detected soc subtype: %s\n",
+			at91_get_soc_subtype(&at91_soc_initdata));
+
+	if (!at91_soc_is_enabled())
+		panic("AT91: Soc not enabled");
+
+	if (at91_boot_soc.map_io)
+		at91_boot_soc.map_io();
+}
+
 void __iomem *at91_matrix_base;
 EXPORT_SYMBOL_GPL(at91_matrix_base);
 
-- 
1.9.1

