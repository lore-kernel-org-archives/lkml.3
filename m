Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaHEBez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:34:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42829 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaHEBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:26 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
Date: Mon,  4 Aug 2014 18:31:50 -0700
Message-Id: <1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectural changes in the ARM Linux kernel tree mandate
the eventual removal of the mach-* directories. Move the
scm driver to drivers/soc/qcom and the scm header to
include/soc/qcom to support that removal.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/Kconfig                     | 3 ---
 arch/arm/mach-qcom/Makefile                    | 4 +---
 arch/arm/mach-qcom/scm-boot.c                  | 2 +-
 drivers/soc/qcom/Kconfig                       | 2 ++
 drivers/soc/qcom/Makefile                      | 2 ++
 {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c | 3 ++-
 {arch/arm/mach-qcom => include/soc/qcom}/scm.h | 0
 7 files changed, 8 insertions(+), 8 deletions(-)
 rename {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c (99%)
 rename {arch/arm/mach-qcom => include/soc/qcom}/scm.h (100%)

diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
index ee5697ba05bc..57d112d62018 100644
--- a/arch/arm/mach-qcom/Kconfig
+++ b/arch/arm/mach-qcom/Kconfig
@@ -23,7 +23,4 @@ config ARCH_MSM8974
 	bool "Enable support for MSM8974"
 	select HAVE_ARM_ARCH_TIMER
 
-config QCOM_SCM
-	bool
-
 endif
diff --git a/arch/arm/mach-qcom/Makefile b/arch/arm/mach-qcom/Makefile
index 8f756ae1ae31..db41e8c27aec 100644
--- a/arch/arm/mach-qcom/Makefile
+++ b/arch/arm/mach-qcom/Makefile
@@ -1,5 +1,3 @@
 obj-y			:= board.o
 obj-$(CONFIG_SMP)	+= platsmp.o
-obj-$(CONFIG_QCOM_SCM)	+= scm.o scm-boot.o
-
-CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
+obj-$(CONFIG_QCOM_SCM)	+= scm-boot.o
diff --git a/arch/arm/mach-qcom/scm-boot.c b/arch/arm/mach-qcom/scm-boot.c
index 45cee3e469a5..5add20e64d99 100644
--- a/arch/arm/mach-qcom/scm-boot.c
+++ b/arch/arm/mach-qcom/scm-boot.c
@@ -17,8 +17,8 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <soc/qcom/scm.h>
 
-#include "scm.h"
 #include "scm-boot.h"
 
 /*
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 7bd2c94f54a4..7dcd554496c7 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -9,3 +9,5 @@ config QCOM_GSBI
           functions for connecting the underlying serial UART, SPI, and I2C
           devices to the output pins.
 
+config QCOM_SCM
+	bool
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 438901257ac1..a39446d08ac6 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_QCOM_GSBI)	+=	qcom_gsbi.o
+CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
+obj-$(CONFIG_QCOM_SCM) += scm.o
diff --git a/arch/arm/mach-qcom/scm.c b/drivers/soc/qcom/scm.c
similarity index 99%
rename from arch/arm/mach-qcom/scm.c
rename to drivers/soc/qcom/scm.c
index cfd4717aec78..2e98d80e2387 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/drivers/soc/qcom/scm.c
@@ -22,10 +22,11 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 
+#include <soc/qcom/scm.h>
+
 #include <asm/outercache.h>
 #include <asm/cacheflush.h>
 
-#include "scm.h"
 
 #define SCM_ENOMEM		-5
 #define SCM_EOPNOTSUPP		-4
diff --git a/arch/arm/mach-qcom/scm.h b/include/soc/qcom/scm.h
similarity index 100%
rename from arch/arm/mach-qcom/scm.h
rename to include/soc/qcom/scm.h
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

