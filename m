Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3EaMEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:04:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33356 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3EaMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:03:19 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: arnd@arndb.de, kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org
Subject: [PATCH 2/3] ARM: SAMSUNG: Consolidate uncompress subroutine
Date: Fri, 31 May 2013 17:19:03 +0530
Message-Id: <1370000944-19786-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For mach-exynos, uart_base is a pointer and the value is calculated
in the machine folder. For other machines, uart_base is defined as
a macro in platform directory. For symmetry, the uart_base macro
definition is removed and the uart_base calculation is moved to
specific machine folders.

This would help us consolidating uncompress subroutine for s5p64x0.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/mach-exynos/include/mach/uncompress.h  |    3 ---
 arch/arm/mach-s3c24xx/include/mach/uncompress.h |    7 +++++++
 arch/arm/mach-s3c64xx/include/mach/uncompress.h |    7 +++++++
 arch/arm/mach-s5pc100/include/mach/uncompress.h |    6 ++++++
 arch/arm/mach-s5pv210/include/mach/uncompress.h |    6 ++++++
 arch/arm/plat-samsung/include/plat/uncompress.h |    6 ++----
 6 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-exynos/include/mach/uncompress.h b/arch/arm/mach-exynos/include/mach/uncompress.h
index 730f69f..30592fd 100644
--- a/arch/arm/mach-exynos/include/mach/uncompress.h
+++ b/arch/arm/mach-exynos/include/mach/uncompress.h
@@ -15,9 +15,6 @@
 #include <asm/mach-types.h>
 
 #include <mach/map.h>
-
-volatile u8 *uart_base;
-
 #include <plat/uncompress.h>
 
 static unsigned int __raw_readl(unsigned int ptr)
diff --git a/arch/arm/mach-s3c24xx/include/mach/uncompress.h b/arch/arm/mach-s3c24xx/include/mach/uncompress.h
index 8b283f8..638893e 100644
--- a/arch/arm/mach-s3c24xx/include/mach/uncompress.h
+++ b/arch/arm/mach-s3c24xx/include/mach/uncompress.h
@@ -49,6 +49,13 @@ static void arch_detect_cpu(void)
 		fifo_mask = S3C2410_UFSTAT_TXMASK;
 		fifo_max = 15 << S3C2410_UFSTAT_TXSHIFT;
 	}
+
+#ifdef CONFIG_DEBUG_LL
+	uart_base = (volatile u8 *) S3C_PA_UART +
+		(S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
+#else
+	uart_base = NULL;
+#endif
 }
 
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-s3c64xx/include/mach/uncompress.h b/arch/arm/mach-s3c64xx/include/mach/uncompress.h
index c6a82a2..d6f9188 100644
--- a/arch/arm/mach-s3c64xx/include/mach/uncompress.h
+++ b/arch/arm/mach-s3c64xx/include/mach/uncompress.h
@@ -23,6 +23,13 @@ static void arch_detect_cpu(void)
 	/* we do not need to do any cpu detection here at the moment. */
 	fifo_mask = S3C2440_UFSTAT_TXMASK;
 	fifo_max = 63 << S3C2440_UFSTAT_TXSHIFT;
+
+#ifdef CONFIG_DEBUG_LL
+	uart_base = (volatile u8 *)S3C_PA_UART +
+		(S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT);
+#else
+	uart_base = NULL;
+#endif
 }
 
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-s5pc100/include/mach/uncompress.h b/arch/arm/mach-s5pc100/include/mach/uncompress.h
index 01ccf53..c1242df 100644
--- a/arch/arm/mach-s5pc100/include/mach/uncompress.h
+++ b/arch/arm/mach-s5pc100/include/mach/uncompress.h
@@ -23,6 +23,12 @@ static void arch_detect_cpu(void)
 	/* we do not need to do any cpu detection here at the moment. */
 	fifo_mask = S3C2440_UFSTAT_TXMASK;
 	fifo_max = 63 << S3C2440_UFSTAT_TXSHIFT;
+
+#ifdef CONFIG_DEBUG_LL
+	uart_base = (volatile u8 *)S5P_PA_UART(CONFIG_S3C_LOWLEVEL_UART_PORT);
+#else
+	uart_base = NULL;
+#endif
 }
 
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-s5pv210/include/mach/uncompress.h b/arch/arm/mach-s5pv210/include/mach/uncompress.h
index ef977ea..2193812 100644
--- a/arch/arm/mach-s5pv210/include/mach/uncompress.h
+++ b/arch/arm/mach-s5pv210/include/mach/uncompress.h
@@ -21,6 +21,12 @@ static void arch_detect_cpu(void)
 	/* we do not need to do any cpu detection here at the moment. */
 	fifo_mask = S5PV210_UFSTAT_TXMASK;
 	fifo_max = 63 << S5PV210_UFSTAT_TXSHIFT;
+
+#ifdef CONFIG_DEBUG_LL
+	uart_base = (volatile u8 *)S5P_PA_UART(CONFIG_S3C_LOWLEVEL_UART_PORT);
+#else
+	uart_base = NULL;
+#endif
 }
 
 #endif /* __ASM_ARCH_UNCOMPRESS_H */
diff --git a/arch/arm/plat-samsung/include/plat/uncompress.h b/arch/arm/plat-samsung/include/plat/uncompress.h
index 350032b..78274eb 100644
--- a/arch/arm/plat-samsung/include/plat/uncompress.h
+++ b/arch/arm/plat-samsung/include/plat/uncompress.h
@@ -21,6 +21,8 @@ typedef unsigned int upf_t;	/* cannot include linux/serial_core.h */
 unsigned int fifo_mask;
 unsigned int fifo_max;
 
+volatile u8 *uart_base;
+
 /* forward declerations */
 
 static void arch_detect_cpu(void);
@@ -37,10 +39,6 @@ static void arch_detect_cpu(void);
 /* how many bytes we allow into the FIFO at a time in FIFO mode */
 #define FIFO_MAX	 (14)
 
-#ifdef S3C_PA_UART
-#define uart_base S3C_PA_UART + (S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART_PORT)
-#endif
-
 static __inline__ void
 uart_wr(unsigned int reg, unsigned int val)
 {
-- 
1.7.9.5

