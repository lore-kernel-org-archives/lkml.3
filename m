Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaIKPt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:49:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61188 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbaIKPtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:49:51 -0400
From: mathieu.poirier@linaro.org
To: will.deacon@arm.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Cc: pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, kaixu.xia@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dsaxena@linaro.org, mathieu.poirier@linaro.org
Subject: [PATCH 07/11 v6] coresight-etm: add CoreSight ETM/PTM driver
Date: Thu, 11 Sep 2014 09:49:14 -0600
Message-Id: <1410450558-12358-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

This driver manages CoreSight ETM (Embedded Trace Macrocell) that
supports processor tracing. Currently supported version are ARM
ETMv3.x and PTM1.x.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/Kconfig.debug                 |    9 +
 arch/arm/include/asm/hardware/cp14.h   |  540 ++++++++++
 drivers/coresight/Makefile             |    1 +
 drivers/coresight/coresight-etm-cp14.c |  496 +++++++++
 drivers/coresight/coresight-etm.h      |  250 +++++
 drivers/coresight/coresight-etm3x.c    | 1722 ++++++++++++++++++++++++++++++++
 6 files changed, 3018 insertions(+)
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.h
 create mode 100644 drivers/coresight/coresight-etm3x.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5cb518c..70a49c4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1274,5 +1274,14 @@ config CORESIGHT_LINKS_AND_SINKS
 	  This enables support for CoreSight link and sink drivers that are
 	  responsible for transporting and collecting the trace data
 	  respectively.
+
+config CORESIGHT_SOURCE_ETM3X
+	bool "CoreSight Embedded Trace Macrocell 3.x driver"
+	select CORESIGHT_LINKS_AND_SINKS
+	help
+	  This driver provides support for processor ETM3.x and PTM1.x modules,
+	  which allows tracing the instructions that a processor is executing
+	  This is primarily useful for instruction level tracing.  Depending
+	  the ETM version data tracing may also be available.
 endif
 endmenu
diff --git a/arch/arm/include/asm/hardware/cp14.h b/arch/arm/include/asm/hardware/cp14.h
new file mode 100644
index 0000000..2e7a299
--- /dev/null
+++ b/arch/arm/include/asm/hardware/cp14.h
@@ -0,0 +1,540 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ASM_HARDWARE_CP14_H
+#define __ASM_HARDWARE_CP14_H
+
+#include <linux/types.h>
+
+/* Accessors for CP14 registers */
+#define dbg_read(reg)			RCP14_##reg()
+#define dbg_write(val, reg)		WCP14_##reg(val)
+#define etm_read(reg)			RCP14_##reg()
+#define etm_write(val, reg)		WCP14_##reg(val)
+
+/* MRC14 and MCR14 */
+#define MRC14(op1, crn, crm, op2)					\
+({									\
+u32 val;								\
+asm volatile("mrc p14, "#op1", %0, "#crn", "#crm", "#op2 : "=r" (val));	\
+val;									\
+})
+
+#define MCR14(val, op1, crn, crm, op2)					\
+({									\
+asm volatile("mcr p14, "#op1", %0, "#crn", "#crm", "#op2 : : "r" (val));\
+})
+
+/* Debug Registers
+ *
+ * Available only in DBGv7
+ * DBGECR, DBGDSCCR, DBGDSMCR, DBGDRCR
+ *
+ * Available only in DBGv7.1
+ * DBGBXVRm, DBGOSDLR, DBGDEVID2, DBGDEVID1
+ *
+ * Read only
+ * DBGDIDR, DBGDSCRint, DBGDTRRXint, DBGDRAR, DBGOSLSR, DBGOSSRR, DBGPRSR,
+ * DBGPRSR, DBGDSAR, DBGAUTHSTATUS, DBGDEVID2, DBGDEVID1, DBGDEVID
+ *
+ * Write only
+ * DBGDTRTXint, DBGOSLAR
+ */
+#define RCP14_DBGDIDR()			MRC14(0, c0, c0, 0)
+#define RCP14_DBGDSCRint()		MRC14(0, c0, c1, 0)
+#define RCP14_DBGDTRRXint()		MRC14(0, c0, c5, 0)
+#define RCP14_DBGWFAR()			MRC14(0, c0, c6, 0)
+#define RCP14_DBGVCR()			MRC14(0, c0, c7, 0)
+#define RCP14_DBGECR()			MRC14(0, c0, c9, 0)
+#define RCP14_DBGDSCCR()		MRC14(0, c0, c10, 0)
+#define RCP14_DBGDSMCR()		MRC14(0, c0, c11, 0)
+#define RCP14_DBGDTRRXext()		MRC14(0, c0, c0, 2)
+#define RCP14_DBGDSCRext()		MRC14(0, c0, c2, 2)
+#define RCP14_DBGDTRTXext()		MRC14(0, c0, c3, 2)
+#define RCP14_DBGDRCR()			MRC14(0, c0, c4, 2)
+#define RCP14_DBGBVR0()			MRC14(0, c0, c0, 4)
+#define RCP14_DBGBVR1()			MRC14(0, c0, c1, 4)
+#define RCP14_DBGBVR2()			MRC14(0, c0, c2, 4)
+#define RCP14_DBGBVR3()			MRC14(0, c0, c3, 4)
+#define RCP14_DBGBVR4()			MRC14(0, c0, c4, 4)
+#define RCP14_DBGBVR5()			MRC14(0, c0, c5, 4)
+#define RCP14_DBGBVR6()			MRC14(0, c0, c6, 4)
+#define RCP14_DBGBVR7()			MRC14(0, c0, c7, 4)
+#define RCP14_DBGBVR8()			MRC14(0, c0, c8, 4)
+#define RCP14_DBGBVR9()			MRC14(0, c0, c9, 4)
+#define RCP14_DBGBVR10()		MRC14(0, c0, c10, 4)
+#define RCP14_DBGBVR11()		MRC14(0, c0, c11, 4)
+#define RCP14_DBGBVR12()		MRC14(0, c0, c12, 4)
+#define RCP14_DBGBVR13()		MRC14(0, c0, c13, 4)
+#define RCP14_DBGBVR14()		MRC14(0, c0, c14, 4)
+#define RCP14_DBGBVR15()		MRC14(0, c0, c15, 4)
+#define RCP14_DBGBCR0()			MRC14(0, c0, c0, 5)
+#define RCP14_DBGBCR1()			MRC14(0, c0, c1, 5)
+#define RCP14_DBGBCR2()			MRC14(0, c0, c2, 5)
+#define RCP14_DBGBCR3()			MRC14(0, c0, c3, 5)
+#define RCP14_DBGBCR4()			MRC14(0, c0, c4, 5)
+#define RCP14_DBGBCR5()			MRC14(0, c0, c5, 5)
+#define RCP14_DBGBCR6()			MRC14(0, c0, c6, 5)
+#define RCP14_DBGBCR7()			MRC14(0, c0, c7, 5)
+#define RCP14_DBGBCR8()			MRC14(0, c0, c8, 5)
+#define RCP14_DBGBCR9()			MRC14(0, c0, c9, 5)
+#define RCP14_DBGBCR10()		MRC14(0, c0, c10, 5)
+#define RCP14_DBGBCR11()		MRC14(0, c0, c11, 5)
+#define RCP14_DBGBCR12()		MRC14(0, c0, c12, 5)
+#define RCP14_DBGBCR13()		MRC14(0, c0, c13, 5)
+#define RCP14_DBGBCR14()		MRC14(0, c0, c14, 5)
+#define RCP14_DBGBCR15()		MRC14(0, c0, c15, 5)
+#define RCP14_DBGWVR0()			MRC14(0, c0, c0, 6)
+#define RCP14_DBGWVR1()			MRC14(0, c0, c1, 6)
+#define RCP14_DBGWVR2()			MRC14(0, c0, c2, 6)
+#define RCP14_DBGWVR3()			MRC14(0, c0, c3, 6)
+#define RCP14_DBGWVR4()			MRC14(0, c0, c4, 6)
+#define RCP14_DBGWVR5()			MRC14(0, c0, c5, 6)
+#define RCP14_DBGWVR6()			MRC14(0, c0, c6, 6)
+#define RCP14_DBGWVR7()			MRC14(0, c0, c7, 6)
+#define RCP14_DBGWVR8()			MRC14(0, c0, c8, 6)
+#define RCP14_DBGWVR9()			MRC14(0, c0, c9, 6)
+#define RCP14_DBGWVR10()		MRC14(0, c0, c10, 6)
+#define RCP14_DBGWVR11()		MRC14(0, c0, c11, 6)
+#define RCP14_DBGWVR12()		MRC14(0, c0, c12, 6)
+#define RCP14_DBGWVR13()		MRC14(0, c0, c13, 6)
+#define RCP14_DBGWVR14()		MRC14(0, c0, c14, 6)
+#define RCP14_DBGWVR15()		MRC14(0, c0, c15, 6)
+#define RCP14_DBGWCR0()			MRC14(0, c0, c0, 7)
+#define RCP14_DBGWCR1()			MRC14(0, c0, c1, 7)
+#define RCP14_DBGWCR2()			MRC14(0, c0, c2, 7)
+#define RCP14_DBGWCR3()			MRC14(0, c0, c3, 7)
+#define RCP14_DBGWCR4()			MRC14(0, c0, c4, 7)
+#define RCP14_DBGWCR5()			MRC14(0, c0, c5, 7)
+#define RCP14_DBGWCR6()			MRC14(0, c0, c6, 7)
+#define RCP14_DBGWCR7()			MRC14(0, c0, c7, 7)
+#define RCP14_DBGWCR8()			MRC14(0, c0, c8, 7)
+#define RCP14_DBGWCR9()			MRC14(0, c0, c9, 7)
+#define RCP14_DBGWCR10()		MRC14(0, c0, c10, 7)
+#define RCP14_DBGWCR11()		MRC14(0, c0, c11, 7)
+#define RCP14_DBGWCR12()		MRC14(0, c0, c12, 7)
+#define RCP14_DBGWCR13()		MRC14(0, c0, c13, 7)
+#define RCP14_DBGWCR14()		MRC14(0, c0, c14, 7)
+#define RCP14_DBGWCR15()		MRC14(0, c0, c15, 7)
+#define RCP14_DBGDRAR()			MRC14(0, c1, c0, 0)
+#define RCP14_DBGBXVR0()		MRC14(0, c1, c0, 1)
+#define RCP14_DBGBXVR1()		MRC14(0, c1, c1, 1)
+#define RCP14_DBGBXVR2()		MRC14(0, c1, c2, 1)
+#define RCP14_DBGBXVR3()		MRC14(0, c1, c3, 1)
+#define RCP14_DBGBXVR4()		MRC14(0, c1, c4, 1)
+#define RCP14_DBGBXVR5()		MRC14(0, c1, c5, 1)
+#define RCP14_DBGBXVR6()		MRC14(0, c1, c6, 1)
+#define RCP14_DBGBXVR7()		MRC14(0, c1, c7, 1)
+#define RCP14_DBGBXVR8()		MRC14(0, c1, c8, 1)
+#define RCP14_DBGBXVR9()		MRC14(0, c1, c9, 1)
+#define RCP14_DBGBXVR10()		MRC14(0, c1, c10, 1)
+#define RCP14_DBGBXVR11()		MRC14(0, c1, c11, 1)
+#define RCP14_DBGBXVR12()		MRC14(0, c1, c12, 1)
+#define RCP14_DBGBXVR13()		MRC14(0, c1, c13, 1)
+#define RCP14_DBGBXVR14()		MRC14(0, c1, c14, 1)
+#define RCP14_DBGBXVR15()		MRC14(0, c1, c15, 1)
+#define RCP14_DBGOSLSR()		MRC14(0, c1, c1, 4)
+#define RCP14_DBGOSSRR()		MRC14(0, c1, c2, 4)
+#define RCP14_DBGOSDLR()		MRC14(0, c1, c3, 4)
+#define RCP14_DBGPRCR()			MRC14(0, c1, c4, 4)
+#define RCP14_DBGPRSR()			MRC14(0, c1, c5, 4)
+#define RCP14_DBGDSAR()			MRC14(0, c2, c0, 0)
+#define RCP14_DBGITCTRL()		MRC14(0, c7, c0, 4)
+#define RCP14_DBGCLAIMSET()		MRC14(0, c7, c8, 6)
+#define RCP14_DBGCLAIMCLR()		MRC14(0, c7, c9, 6)
+#define RCP14_DBGAUTHSTATUS()		MRC14(0, c7, c14, 6)
+#define RCP14_DBGDEVID2()		MRC14(0, c7, c0, 7)
+#define RCP14_DBGDEVID1()		MRC14(0, c7, c1, 7)
+#define RCP14_DBGDEVID()		MRC14(0, c7, c2, 7)
+
+#define WCP14_DBGDTRTXint(val)		MCR14(val, 0, c0, c5, 0)
+#define WCP14_DBGWFAR(val)		MCR14(val, 0, c0, c6, 0)
+#define WCP14_DBGVCR(val)		MCR14(val, 0, c0, c7, 0)
+#define WCP14_DBGECR(val)		MCR14(val, 0, c0, c9, 0)
+#define WCP14_DBGDSCCR(val)		MCR14(val, 0, c0, c10, 0)
+#define WCP14_DBGDSMCR(val)		MCR14(val, 0, c0, c11, 0)
+#define WCP14_DBGDTRRXext(val)		MCR14(val, 0, c0, c0, 2)
+#define WCP14_DBGDSCRext(val)		MCR14(val, 0, c0, c2, 2)
+#define WCP14_DBGDTRTXext(val)		MCR14(val, 0, c0, c3, 2)
+#define WCP14_DBGDRCR(val)		MCR14(val, 0, c0, c4, 2)
+#define WCP14_DBGBVR0(val)		MCR14(val, 0, c0, c0, 4)
+#define WCP14_DBGBVR1(val)		MCR14(val, 0, c0, c1, 4)
+#define WCP14_DBGBVR2(val)		MCR14(val, 0, c0, c2, 4)
+#define WCP14_DBGBVR3(val)		MCR14(val, 0, c0, c3, 4)
+#define WCP14_DBGBVR4(val)		MCR14(val, 0, c0, c4, 4)
+#define WCP14_DBGBVR5(val)		MCR14(val, 0, c0, c5, 4)
+#define WCP14_DBGBVR6(val)		MCR14(val, 0, c0, c6, 4)
+#define WCP14_DBGBVR7(val)		MCR14(val, 0, c0, c7, 4)
+#define WCP14_DBGBVR8(val)		MCR14(val, 0, c0, c8, 4)
+#define WCP14_DBGBVR9(val)		MCR14(val, 0, c0, c9, 4)
+#define WCP14_DBGBVR10(val)		MCR14(val, 0, c0, c10, 4)
+#define WCP14_DBGBVR11(val)		MCR14(val, 0, c0, c11, 4)
+#define WCP14_DBGBVR12(val)		MCR14(val, 0, c0, c12, 4)
+#define WCP14_DBGBVR13(val)		MCR14(val, 0, c0, c13, 4)
+#define WCP14_DBGBVR14(val)		MCR14(val, 0, c0, c14, 4)
+#define WCP14_DBGBVR15(val)		MCR14(val, 0, c0, c15, 4)
+#define WCP14_DBGBCR0(val)		MCR14(val, 0, c0, c0, 5)
+#define WCP14_DBGBCR1(val)		MCR14(val, 0, c0, c1, 5)
+#define WCP14_DBGBCR2(val)		MCR14(val, 0, c0, c2, 5)
+#define WCP14_DBGBCR3(val)		MCR14(val, 0, c0, c3, 5)
+#define WCP14_DBGBCR4(val)		MCR14(val, 0, c0, c4, 5)
+#define WCP14_DBGBCR5(val)		MCR14(val, 0, c0, c5, 5)
+#define WCP14_DBGBCR6(val)		MCR14(val, 0, c0, c6, 5)
+#define WCP14_DBGBCR7(val)		MCR14(val, 0, c0, c7, 5)
+#define WCP14_DBGBCR8(val)		MCR14(val, 0, c0, c8, 5)
+#define WCP14_DBGBCR9(val)		MCR14(val, 0, c0, c9, 5)
+#define WCP14_DBGBCR10(val)		MCR14(val, 0, c0, c10, 5)
+#define WCP14_DBGBCR11(val)		MCR14(val, 0, c0, c11, 5)
+#define WCP14_DBGBCR12(val)		MCR14(val, 0, c0, c12, 5)
+#define WCP14_DBGBCR13(val)		MCR14(val, 0, c0, c13, 5)
+#define WCP14_DBGBCR14(val)		MCR14(val, 0, c0, c14, 5)
+#define WCP14_DBGBCR15(val)		MCR14(val, 0, c0, c15, 5)
+#define WCP14_DBGWVR0(val)		MCR14(val, 0, c0, c0, 6)
+#define WCP14_DBGWVR1(val)		MCR14(val, 0, c0, c1, 6)
+#define WCP14_DBGWVR2(val)		MCR14(val, 0, c0, c2, 6)
+#define WCP14_DBGWVR3(val)		MCR14(val, 0, c0, c3, 6)
+#define WCP14_DBGWVR4(val)		MCR14(val, 0, c0, c4, 6)
+#define WCP14_DBGWVR5(val)		MCR14(val, 0, c0, c5, 6)
+#define WCP14_DBGWVR6(val)		MCR14(val, 0, c0, c6, 6)
+#define WCP14_DBGWVR7(val)		MCR14(val, 0, c0, c7, 6)
+#define WCP14_DBGWVR8(val)		MCR14(val, 0, c0, c8, 6)
+#define WCP14_DBGWVR9(val)		MCR14(val, 0, c0, c9, 6)
+#define WCP14_DBGWVR10(val)		MCR14(val, 0, c0, c10, 6)
+#define WCP14_DBGWVR11(val)		MCR14(val, 0, c0, c11, 6)
+#define WCP14_DBGWVR12(val)		MCR14(val, 0, c0, c12, 6)
+#define WCP14_DBGWVR13(val)		MCR14(val, 0, c0, c13, 6)
+#define WCP14_DBGWVR14(val)		MCR14(val, 0, c0, c14, 6)
+#define WCP14_DBGWVR15(val)		MCR14(val, 0, c0, c15, 6)
+#define WCP14_DBGWCR0(val)		MCR14(val, 0, c0, c0, 7)
+#define WCP14_DBGWCR1(val)		MCR14(val, 0, c0, c1, 7)
+#define WCP14_DBGWCR2(val)		MCR14(val, 0, c0, c2, 7)
+#define WCP14_DBGWCR3(val)		MCR14(val, 0, c0, c3, 7)
+#define WCP14_DBGWCR4(val)		MCR14(val, 0, c0, c4, 7)
+#define WCP14_DBGWCR5(val)		MCR14(val, 0, c0, c5, 7)
+#define WCP14_DBGWCR6(val)		MCR14(val, 0, c0, c6, 7)
+#define WCP14_DBGWCR7(val)		MCR14(val, 0, c0, c7, 7)
+#define WCP14_DBGWCR8(val)		MCR14(val, 0, c0, c8, 7)
+#define WCP14_DBGWCR9(val)		MCR14(val, 0, c0, c9, 7)
+#define WCP14_DBGWCR10(val)		MCR14(val, 0, c0, c10, 7)
+#define WCP14_DBGWCR11(val)		MCR14(val, 0, c0, c11, 7)
+#define WCP14_DBGWCR12(val)		MCR14(val, 0, c0, c12, 7)
+#define WCP14_DBGWCR13(val)		MCR14(val, 0, c0, c13, 7)
+#define WCP14_DBGWCR14(val)		MCR14(val, 0, c0, c14, 7)
+#define WCP14_DBGWCR15(val)		MCR14(val, 0, c0, c15, 7)
+#define WCP14_DBGBXVR0(val)		MCR14(val, 0, c1, c0, 1)
+#define WCP14_DBGBXVR1(val)		MCR14(val, 0, c1, c1, 1)
+#define WCP14_DBGBXVR2(val)		MCR14(val, 0, c1, c2, 1)
+#define WCP14_DBGBXVR3(val)		MCR14(val, 0, c1, c3, 1)
+#define WCP14_DBGBXVR4(val)		MCR14(val, 0, c1, c4, 1)
+#define WCP14_DBGBXVR5(val)		MCR14(val, 0, c1, c5, 1)
+#define WCP14_DBGBXVR6(val)		MCR14(val, 0, c1, c6, 1)
+#define WCP14_DBGBXVR7(val)		MCR14(val, 0, c1, c7, 1)
+#define WCP14_DBGBXVR8(val)		MCR14(val, 0, c1, c8, 1)
+#define WCP14_DBGBXVR9(val)		MCR14(val, 0, c1, c9, 1)
+#define WCP14_DBGBXVR10(val)		MCR14(val, 0, c1, c10, 1)
+#define WCP14_DBGBXVR11(val)		MCR14(val, 0, c1, c11, 1)
+#define WCP14_DBGBXVR12(val)		MCR14(val, 0, c1, c12, 1)
+#define WCP14_DBGBXVR13(val)		MCR14(val, 0, c1, c13, 1)
+#define WCP14_DBGBXVR14(val)		MCR14(val, 0, c1, c14, 1)
+#define WCP14_DBGBXVR15(val)		MCR14(val, 0, c1, c15, 1)
+#define WCP14_DBGOSLAR(val)		MCR14(val, 0, c1, c0, 4)
+#define WCP14_DBGOSSRR(val)		MCR14(val, 0, c1, c2, 4)
+#define WCP14_DBGOSDLR(val)		MCR14(val, 0, c1, c3, 4)
+#define WCP14_DBGPRCR(val)		MCR14(val, 0, c1, c4, 4)
+#define WCP14_DBGITCTRL(val)		MCR14(val, 0, c7, c0, 4)
+#define WCP14_DBGCLAIMSET(val)		MCR14(val, 0, c7, c8, 6)
+#define WCP14_DBGCLAIMCLR(val)		MCR14(val, 0, c7, c9, 6)
+
+/* ETM Registers
+ *
+ * Available only in ETMv3.3, 3.4, 3.5
+ * ETMASICCR, ETMTECR2, ETMFFRR, ETMVDEVR, ETMVDCR1, ETMVDCR2, ETMVDCR3,
+ * ETMDCVRn, ETMDCMRn
+ *
+ * Available only in ETMv3.5 as read only
+ * ETMIDR2
+ *
+ * Available only in ETMv3.5, PFTv1.0, 1.1
+ * ETMTSEVR, ETMVMIDCVR, ETMPDCR
+ *
+ * Read only
+ * ETMCCR, ETMSCR, ETMIDR, ETMCCER, ETMOSLSR
+ * ETMLSR, ETMAUTHSTATUS, ETMDEVID, ETMDEVTYPE, ETMPIDR4, ETMPIDR5, ETMPIDR6,
+ * ETMPIDR7, ETMPIDR0, ETMPIDR1, ETMPIDR2, ETMPIDR2, ETMPIDR3, ETMCIDR0,
+ * ETMCIDR1, ETMCIDR2, ETMCIDR3
+ *
+ * Write only
+ * ETMOSLAR, ETMLAR
+ * Note: ETMCCER[11] controls WO nature of certain regs. Refer ETM arch spec.
+ */
+#define RCP14_ETMCR()			MRC14(1, c0, c0, 0)
+#define RCP14_ETMCCR()			MRC14(1, c0, c1, 0)
+#define RCP14_ETMTRIGGER()		MRC14(1, c0, c2, 0)
+#define RCP14_ETMASICCR()		MRC14(1, c0, c3, 0)
+#define RCP14_ETMSR()			MRC14(1, c0, c4, 0)
+#define RCP14_ETMSCR()			MRC14(1, c0, c5, 0)
+#define RCP14_ETMTSSCR()		MRC14(1, c0, c6, 0)
+#define RCP14_ETMTECR2()		MRC14(1, c0, c7, 0)
+#define RCP14_ETMTEEVR()		MRC14(1, c0, c8, 0)
+#define RCP14_ETMTECR1()		MRC14(1, c0, c9, 0)
+#define RCP14_ETMFFRR()			MRC14(1, c0, c10, 0)
+#define RCP14_ETMFFLR()			MRC14(1, c0, c11, 0)
+#define RCP14_ETMVDEVR()		MRC14(1, c0, c12, 0)
+#define RCP14_ETMVDCR1()		MRC14(1, c0, c13, 0)
+#define RCP14_ETMVDCR2()		MRC14(1, c0, c14, 0)
+#define RCP14_ETMVDCR3()		MRC14(1, c0, c15, 0)
+#define RCP14_ETMACVR0()		MRC14(1, c0, c0, 1)
+#define RCP14_ETMACVR1()		MRC14(1, c0, c1, 1)
+#define RCP14_ETMACVR2()		MRC14(1, c0, c2, 1)
+#define RCP14_ETMACVR3()		MRC14(1, c0, c3, 1)
+#define RCP14_ETMACVR4()		MRC14(1, c0, c4, 1)
+#define RCP14_ETMACVR5()		MRC14(1, c0, c5, 1)
+#define RCP14_ETMACVR6()		MRC14(1, c0, c6, 1)
+#define RCP14_ETMACVR7()		MRC14(1, c0, c7, 1)
+#define RCP14_ETMACVR8()		MRC14(1, c0, c8, 1)
+#define RCP14_ETMACVR9()		MRC14(1, c0, c9, 1)
+#define RCP14_ETMACVR10()		MRC14(1, c0, c10, 1)
+#define RCP14_ETMACVR11()		MRC14(1, c0, c11, 1)
+#define RCP14_ETMACVR12()		MRC14(1, c0, c12, 1)
+#define RCP14_ETMACVR13()		MRC14(1, c0, c13, 1)
+#define RCP14_ETMACVR14()		MRC14(1, c0, c14, 1)
+#define RCP14_ETMACVR15()		MRC14(1, c0, c15, 1)
+#define RCP14_ETMACTR0()		MRC14(1, c0, c0, 2)
+#define RCP14_ETMACTR1()		MRC14(1, c0, c1, 2)
+#define RCP14_ETMACTR2()		MRC14(1, c0, c2, 2)
+#define RCP14_ETMACTR3()		MRC14(1, c0, c3, 2)
+#define RCP14_ETMACTR4()		MRC14(1, c0, c4, 2)
+#define RCP14_ETMACTR5()		MRC14(1, c0, c5, 2)
+#define RCP14_ETMACTR6()		MRC14(1, c0, c6, 2)
+#define RCP14_ETMACTR7()		MRC14(1, c0, c7, 2)
+#define RCP14_ETMACTR8()		MRC14(1, c0, c8, 2)
+#define RCP14_ETMACTR9()		MRC14(1, c0, c9, 2)
+#define RCP14_ETMACTR10()		MRC14(1, c0, c10, 2)
+#define RCP14_ETMACTR11()		MRC14(1, c0, c11, 2)
+#define RCP14_ETMACTR12()		MRC14(1, c0, c12, 2)
+#define RCP14_ETMACTR13()		MRC14(1, c0, c13, 2)
+#define RCP14_ETMACTR14()		MRC14(1, c0, c14, 2)
+#define RCP14_ETMACTR15()		MRC14(1, c0, c15, 2)
+#define RCP14_ETMDCVR0()		MRC14(1, c0, c0, 3)
+#define RCP14_ETMDCVR2()		MRC14(1, c0, c2, 3)
+#define RCP14_ETMDCVR4()		MRC14(1, c0, c4, 3)
+#define RCP14_ETMDCVR6()		MRC14(1, c0, c6, 3)
+#define RCP14_ETMDCVR8()		MRC14(1, c0, c8, 3)
+#define RCP14_ETMDCVR10()		MRC14(1, c0, c10, 3)
+#define RCP14_ETMDCVR12()		MRC14(1, c0, c12, 3)
+#define RCP14_ETMDCVR14()		MRC14(1, c0, c14, 3)
+#define RCP14_ETMDCMR0()		MRC14(1, c0, c0, 4)
+#define RCP14_ETMDCMR2()		MRC14(1, c0, c2, 4)
+#define RCP14_ETMDCMR4()		MRC14(1, c0, c4, 4)
+#define RCP14_ETMDCMR6()		MRC14(1, c0, c6, 4)
+#define RCP14_ETMDCMR8()		MRC14(1, c0, c8, 4)
+#define RCP14_ETMDCMR10()		MRC14(1, c0, c10, 4)
+#define RCP14_ETMDCMR12()		MRC14(1, c0, c12, 4)
+#define RCP14_ETMDCMR14()		MRC14(1, c0, c14, 4)
+#define RCP14_ETMCNTRLDVR0()		MRC14(1, c0, c0, 5)
+#define RCP14_ETMCNTRLDVR1()		MRC14(1, c0, c1, 5)
+#define RCP14_ETMCNTRLDVR2()		MRC14(1, c0, c2, 5)
+#define RCP14_ETMCNTRLDVR3()		MRC14(1, c0, c3, 5)
+#define RCP14_ETMCNTENR0()		MRC14(1, c0, c4, 5)
+#define RCP14_ETMCNTENR1()		MRC14(1, c0, c5, 5)
+#define RCP14_ETMCNTENR2()		MRC14(1, c0, c6, 5)
+#define RCP14_ETMCNTENR3()		MRC14(1, c0, c7, 5)
+#define RCP14_ETMCNTRLDEVR0()		MRC14(1, c0, c8, 5)
+#define RCP14_ETMCNTRLDEVR1()		MRC14(1, c0, c9, 5)
+#define RCP14_ETMCNTRLDEVR2()		MRC14(1, c0, c10, 5)
+#define RCP14_ETMCNTRLDEVR3()		MRC14(1, c0, c11, 5)
+#define RCP14_ETMCNTVR0()		MRC14(1, c0, c12, 5)
+#define RCP14_ETMCNTVR1()		MRC14(1, c0, c13, 5)
+#define RCP14_ETMCNTVR2()		MRC14(1, c0, c14, 5)
+#define RCP14_ETMCNTVR3()		MRC14(1, c0, c15, 5)
+#define RCP14_ETMSQ12EVR()		MRC14(1, c0, c0, 6)
+#define RCP14_ETMSQ21EVR()		MRC14(1, c0, c1, 6)
+#define RCP14_ETMSQ23EVR()		MRC14(1, c0, c2, 6)
+#define RCP14_ETMSQ31EVR()		MRC14(1, c0, c3, 6)
+#define RCP14_ETMSQ32EVR()		MRC14(1, c0, c4, 6)
+#define RCP14_ETMSQ13EVR()		MRC14(1, c0, c5, 6)
+#define RCP14_ETMSQR()			MRC14(1, c0, c7, 6)
+#define RCP14_ETMEXTOUTEVR0()		MRC14(1, c0, c8, 6)
+#define RCP14_ETMEXTOUTEVR1()		MRC14(1, c0, c9, 6)
+#define RCP14_ETMEXTOUTEVR2()		MRC14(1, c0, c10, 6)
+#define RCP14_ETMEXTOUTEVR3()		MRC14(1, c0, c11, 6)
+#define RCP14_ETMCIDCVR0()		MRC14(1, c0, c12, 6)
+#define RCP14_ETMCIDCVR1()		MRC14(1, c0, c13, 6)
+#define RCP14_ETMCIDCVR2()		MRC14(1, c0, c14, 6)
+#define RCP14_ETMCIDCMR()		MRC14(1, c0, c15, 6)
+#define RCP14_ETMIMPSPEC0()		MRC14(1, c0, c0, 7)
+#define RCP14_ETMIMPSPEC1()		MRC14(1, c0, c1, 7)
+#define RCP14_ETMIMPSPEC2()		MRC14(1, c0, c2, 7)
+#define RCP14_ETMIMPSPEC3()		MRC14(1, c0, c3, 7)
+#define RCP14_ETMIMPSPEC4()		MRC14(1, c0, c4, 7)
+#define RCP14_ETMIMPSPEC5()		MRC14(1, c0, c5, 7)
+#define RCP14_ETMIMPSPEC6()		MRC14(1, c0, c6, 7)
+#define RCP14_ETMIMPSPEC7()		MRC14(1, c0, c7, 7)
+#define RCP14_ETMSYNCFR()		MRC14(1, c0, c8, 7)
+#define RCP14_ETMIDR()			MRC14(1, c0, c9, 7)
+#define RCP14_ETMCCER()			MRC14(1, c0, c10, 7)
+#define RCP14_ETMEXTINSELR()		MRC14(1, c0, c11, 7)
+#define RCP14_ETMTESSEICR()		MRC14(1, c0, c12, 7)
+#define RCP14_ETMEIBCR()		MRC14(1, c0, c13, 7)
+#define RCP14_ETMTSEVR()		MRC14(1, c0, c14, 7)
+#define RCP14_ETMAUXCR()		MRC14(1, c0, c15, 7)
+#define RCP14_ETMTRACEIDR()		MRC14(1, c1, c0, 0)
+#define RCP14_ETMIDR2()			MRC14(1, c1, c2, 0)
+#define RCP14_ETMVMIDCVR()		MRC14(1, c1, c0, 1)
+#define RCP14_ETMOSLSR()		MRC14(1, c1, c1, 4)
+/* not available in PFTv1.1 */
+#define RCP14_ETMOSSRR()		MRC14(1, c1, c2, 4)
+#define RCP14_ETMPDCR()			MRC14(1, c1, c4, 4)
+#define RCP14_ETMPDSR()			MRC14(1, c1, c5, 4)
+#define RCP14_ETMITCTRL()		MRC14(1, c7, c0, 4)
+#define RCP14_ETMCLAIMSET()		MRC14(1, c7, c8, 6)
+#define RCP14_ETMCLAIMCLR()		MRC14(1, c7, c9, 6)
+#define RCP14_ETMLSR()			MRC14(1, c7, c13, 6)
+#define RCP14_ETMAUTHSTATUS()		MRC14(1, c7, c14, 6)
+#define RCP14_ETMDEVID()		MRC14(1, c7, c2, 7)
+#define RCP14_ETMDEVTYPE()		MRC14(1, c7, c3, 7)
+#define RCP14_ETMPIDR4()		MRC14(1, c7, c4, 7)
+#define RCP14_ETMPIDR5()		MRC14(1, c7, c5, 7)
+#define RCP14_ETMPIDR6()		MRC14(1, c7, c6, 7)
+#define RCP14_ETMPIDR7()		MRC14(1, c7, c7, 7)
+#define RCP14_ETMPIDR0()		MRC14(1, c7, c8, 7)
+#define RCP14_ETMPIDR1()		MRC14(1, c7, c9, 7)
+#define RCP14_ETMPIDR2()		MRC14(1, c7, c10, 7)
+#define RCP14_ETMPIDR3()		MRC14(1, c7, c11, 7)
+#define RCP14_ETMCIDR0()		MRC14(1, c7, c12, 7)
+#define RCP14_ETMCIDR1()		MRC14(1, c7, c13, 7)
+#define RCP14_ETMCIDR2()		MRC14(1, c7, c14, 7)
+#define RCP14_ETMCIDR3()		MRC14(1, c7, c15, 7)
+
+#define WCP14_ETMCR(val)		MCR14(val, 1, c0, c0, 0)
+#define WCP14_ETMTRIGGER(val)		MCR14(val, 1, c0, c2, 0)
+#define WCP14_ETMASICCR(val)		MCR14(val, 1, c0, c3, 0)
+#define WCP14_ETMSR(val)		MCR14(val, 1, c0, c4, 0)
+#define WCP14_ETMTSSCR(val)		MCR14(val, 1, c0, c6, 0)
+#define WCP14_ETMTECR2(val)		MCR14(val, 1, c0, c7, 0)
+#define WCP14_ETMTEEVR(val)		MCR14(val, 1, c0, c8, 0)
+#define WCP14_ETMTECR1(val)		MCR14(val, 1, c0, c9, 0)
+#define WCP14_ETMFFRR(val)		MCR14(val, 1, c0, c10, 0)
+#define WCP14_ETMFFLR(val)		MCR14(val, 1, c0, c11, 0)
+#define WCP14_ETMVDEVR(val)		MCR14(val, 1, c0, c12, 0)
+#define WCP14_ETMVDCR1(val)		MCR14(val, 1, c0, c13, 0)
+#define WCP14_ETMVDCR2(val)		MCR14(val, 1, c0, c14, 0)
+#define WCP14_ETMVDCR3(val)		MCR14(val, 1, c0, c15, 0)
+#define WCP14_ETMACVR0(val)		MCR14(val, 1, c0, c0, 1)
+#define WCP14_ETMACVR1(val)		MCR14(val, 1, c0, c1, 1)
+#define WCP14_ETMACVR2(val)		MCR14(val, 1, c0, c2, 1)
+#define WCP14_ETMACVR3(val)		MCR14(val, 1, c0, c3, 1)
+#define WCP14_ETMACVR4(val)		MCR14(val, 1, c0, c4, 1)
+#define WCP14_ETMACVR5(val)		MCR14(val, 1, c0, c5, 1)
+#define WCP14_ETMACVR6(val)		MCR14(val, 1, c0, c6, 1)
+#define WCP14_ETMACVR7(val)		MCR14(val, 1, c0, c7, 1)
+#define WCP14_ETMACVR8(val)		MCR14(val, 1, c0, c8, 1)
+#define WCP14_ETMACVR9(val)		MCR14(val, 1, c0, c9, 1)
+#define WCP14_ETMACVR10(val)		MCR14(val, 1, c0, c10, 1)
+#define WCP14_ETMACVR11(val)		MCR14(val, 1, c0, c11, 1)
+#define WCP14_ETMACVR12(val)		MCR14(val, 1, c0, c12, 1)
+#define WCP14_ETMACVR13(val)		MCR14(val, 1, c0, c13, 1)
+#define WCP14_ETMACVR14(val)		MCR14(val, 1, c0, c14, 1)
+#define WCP14_ETMACVR15(val)		MCR14(val, 1, c0, c15, 1)
+#define WCP14_ETMACTR0(val)		MCR14(val, 1, c0, c0, 2)
+#define WCP14_ETMACTR1(val)		MCR14(val, 1, c0, c1, 2)
+#define WCP14_ETMACTR2(val)		MCR14(val, 1, c0, c2, 2)
+#define WCP14_ETMACTR3(val)		MCR14(val, 1, c0, c3, 2)
+#define WCP14_ETMACTR4(val)		MCR14(val, 1, c0, c4, 2)
+#define WCP14_ETMACTR5(val)		MCR14(val, 1, c0, c5, 2)
+#define WCP14_ETMACTR6(val)		MCR14(val, 1, c0, c6, 2)
+#define WCP14_ETMACTR7(val)		MCR14(val, 1, c0, c7, 2)
+#define WCP14_ETMACTR8(val)		MCR14(val, 1, c0, c8, 2)
+#define WCP14_ETMACTR9(val)		MCR14(val, 1, c0, c9, 2)
+#define WCP14_ETMACTR10(val)		MCR14(val, 1, c0, c10, 2)
+#define WCP14_ETMACTR11(val)		MCR14(val, 1, c0, c11, 2)
+#define WCP14_ETMACTR12(val)		MCR14(val, 1, c0, c12, 2)
+#define WCP14_ETMACTR13(val)		MCR14(val, 1, c0, c13, 2)
+#define WCP14_ETMACTR14(val)		MCR14(val, 1, c0, c14, 2)
+#define WCP14_ETMACTR15(val)		MCR14(val, 1, c0, c15, 2)
+#define WCP14_ETMDCVR0(val)		MCR14(val, 1, c0, c0, 3)
+#define WCP14_ETMDCVR2(val)		MCR14(val, 1, c0, c2, 3)
+#define WCP14_ETMDCVR4(val)		MCR14(val, 1, c0, c4, 3)
+#define WCP14_ETMDCVR6(val)		MCR14(val, 1, c0, c6, 3)
+#define WCP14_ETMDCVR8(val)		MCR14(val, 1, c0, c8, 3)
+#define WCP14_ETMDCVR10(val)		MCR14(val, 1, c0, c10, 3)
+#define WCP14_ETMDCVR12(val)		MCR14(val, 1, c0, c12, 3)
+#define WCP14_ETMDCVR14(val)		MCR14(val, 1, c0, c14, 3)
+#define WCP14_ETMDCMR0(val)		MCR14(val, 1, c0, c0, 4)
+#define WCP14_ETMDCMR2(val)		MCR14(val, 1, c0, c2, 4)
+#define WCP14_ETMDCMR4(val)		MCR14(val, 1, c0, c4, 4)
+#define WCP14_ETMDCMR6(val)		MCR14(val, 1, c0, c6, 4)
+#define WCP14_ETMDCMR8(val)		MCR14(val, 1, c0, c8, 4)
+#define WCP14_ETMDCMR10(val)		MCR14(val, 1, c0, c10, 4)
+#define WCP14_ETMDCMR12(val)		MCR14(val, 1, c0, c12, 4)
+#define WCP14_ETMDCMR14(val)		MCR14(val, 1, c0, c14, 4)
+#define WCP14_ETMCNTRLDVR0(val)		MCR14(val, 1, c0, c0, 5)
+#define WCP14_ETMCNTRLDVR1(val)		MCR14(val, 1, c0, c1, 5)
+#define WCP14_ETMCNTRLDVR2(val)		MCR14(val, 1, c0, c2, 5)
+#define WCP14_ETMCNTRLDVR3(val)		MCR14(val, 1, c0, c3, 5)
+#define WCP14_ETMCNTENR0(val)		MCR14(val, 1, c0, c4, 5)
+#define WCP14_ETMCNTENR1(val)		MCR14(val, 1, c0, c5, 5)
+#define WCP14_ETMCNTENR2(val)		MCR14(val, 1, c0, c6, 5)
+#define WCP14_ETMCNTENR3(val)		MCR14(val, 1, c0, c7, 5)
+#define WCP14_ETMCNTRLDEVR0(val)	MCR14(val, 1, c0, c8, 5)
+#define WCP14_ETMCNTRLDEVR1(val)	MCR14(val, 1, c0, c9, 5)
+#define WCP14_ETMCNTRLDEVR2(val)	MCR14(val, 1, c0, c10, 5)
+#define WCP14_ETMCNTRLDEVR3(val)	MCR14(val, 1, c0, c11, 5)
+#define WCP14_ETMCNTVR0(val)		MCR14(val, 1, c0, c12, 5)
+#define WCP14_ETMCNTVR1(val)		MCR14(val, 1, c0, c13, 5)
+#define WCP14_ETMCNTVR2(val)		MCR14(val, 1, c0, c14, 5)
+#define WCP14_ETMCNTVR3(val)		MCR14(val, 1, c0, c15, 5)
+#define WCP14_ETMSQ12EVR(val)		MCR14(val, 1, c0, c0, 6)
+#define WCP14_ETMSQ21EVR(val)		MCR14(val, 1, c0, c1, 6)
+#define WCP14_ETMSQ23EVR(val)		MCR14(val, 1, c0, c2, 6)
+#define WCP14_ETMSQ31EVR(val)		MCR14(val, 1, c0, c3, 6)
+#define WCP14_ETMSQ32EVR(val)		MCR14(val, 1, c0, c4, 6)
+#define WCP14_ETMSQ13EVR(val)		MCR14(val, 1, c0, c5, 6)
+#define WCP14_ETMSQR(val)		MCR14(val, 1, c0, c7, 6)
+#define WCP14_ETMEXTOUTEVR0(val)	MCR14(val, 1, c0, c8, 6)
+#define WCP14_ETMEXTOUTEVR1(val)	MCR14(val, 1, c0, c9, 6)
+#define WCP14_ETMEXTOUTEVR2(val)	MCR14(val, 1, c0, c10, 6)
+#define WCP14_ETMEXTOUTEVR3(val)	MCR14(val, 1, c0, c11, 6)
+#define WCP14_ETMCIDCVR0(val)		MCR14(val, 1, c0, c12, 6)
+#define WCP14_ETMCIDCVR1(val)		MCR14(val, 1, c0, c13, 6)
+#define WCP14_ETMCIDCVR2(val)		MCR14(val, 1, c0, c14, 6)
+#define WCP14_ETMCIDCMR(val)		MCR14(val, 1, c0, c15, 6)
+#define WCP14_ETMIMPSPEC0(val)		MCR14(val, 1, c0, c0, 7)
+#define WCP14_ETMIMPSPEC1(val)		MCR14(val, 1, c0, c1, 7)
+#define WCP14_ETMIMPSPEC2(val)		MCR14(val, 1, c0, c2, 7)
+#define WCP14_ETMIMPSPEC3(val)		MCR14(val, 1, c0, c3, 7)
+#define WCP14_ETMIMPSPEC4(val)		MCR14(val, 1, c0, c4, 7)
+#define WCP14_ETMIMPSPEC5(val)		MCR14(val, 1, c0, c5, 7)
+#define WCP14_ETMIMPSPEC6(val)		MCR14(val, 1, c0, c6, 7)
+#define WCP14_ETMIMPSPEC7(val)		MCR14(val, 1, c0, c7, 7)
+/* can be read only in ETMv3.4, ETMv3.5 */
+#define WCP14_ETMSYNCFR(val)		MCR14(val, 1, c0, c8, 7)
+#define WCP14_ETMEXTINSELR(val)		MCR14(val, 1, c0, c11, 7)
+#define WCP14_ETMTESSEICR(val)		MCR14(val, 1, c0, c12, 7)
+#define WCP14_ETMEIBCR(val)		MCR14(val, 1, c0, c13, 7)
+#define WCP14_ETMTSEVR(val)		MCR14(val, 1, c0, c14, 7)
+#define WCP14_ETMAUXCR(val)		MCR14(val, 1, c0, c15, 7)
+#define WCP14_ETMTRACEIDR(val)		MCR14(val, 1, c1, c0, 0)
+#define WCP14_ETMIDR2(val)		MCR14(val, 1, c1, c2, 0)
+#define WCP14_ETMVMIDCVR(val)		MCR14(val, 1, c1, c0, 1)
+#define WCP14_ETMOSLAR(val)		MCR14(val, 1, c1, c0, 4)
+/* not available in PFTv1.1 */
+#define WCP14_ETMOSSRR(val)		MCR14(val, 1, c1, c2, 4)
+#define WCP14_ETMPDCR(val)		MCR14(val, 1, c1, c4, 4)
+#define WCP14_ETMPDSR(val)		MCR14(val, 1, c1, c5, 4)
+#define WCP14_ETMITCTRL(val)		MCR14(val, 1, c7, c0, 4)
+#define WCP14_ETMCLAIMSET(val)		MCR14(val, 1, c7, c8, 6)
+#define WCP14_ETMCLAIMCLR(val)		MCR14(val, 1, c7, c9, 6)
+/* writes to this from CP14 interface are ignored */
+#define WCP14_ETMLAR(val)		MCR14(val, 1, c7, c12, 6)
+
+#endif
diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
index 3a32c06..fef87bc 100644
--- a/drivers/coresight/Makefile
+++ b/drivers/coresight/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_OF) += of_coresight.o
 obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-tmc.o coresight-tpiu.o \
 					   coresight-etb10.o coresight-funnel.o \
 					   coresight-replicator.o
+obj-$(CONFIG_CORESIGHT_SOURCE_ETM3X) += coresight-etm3x.o coresight-etm-cp14.o
diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/coresight/coresight-etm-cp14.c
new file mode 100644
index 0000000..1bddd4e
--- /dev/null
+++ b/drivers/coresight/coresight-etm-cp14.c
@@ -0,0 +1,496 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+#include <asm/hardware/cp14.h>
+
+#include "coresight-etm.h"
+
+unsigned int etm_readl_cp14(u32 reg)
+{
+	switch (reg) {
+	case ETMCR:
+		return etm_read(ETMCR);
+	case ETMCCR:
+		return etm_read(ETMCCR);
+	case ETMTRIGGER:
+		return etm_read(ETMTRIGGER);
+	case ETMSR:
+		return etm_read(ETMSR);
+	case ETMSCR:
+		return etm_read(ETMSCR);
+	case ETMTSSCR:
+		return etm_read(ETMTSSCR);
+	case ETMTEEVR:
+		return etm_read(ETMTEEVR);
+	case ETMTECR1:
+		return etm_read(ETMTECR1);
+	case ETMFFLR:
+		return etm_read(ETMFFLR);
+	case ETMACVRn(0):
+		return etm_read(ETMACVR0);
+	case ETMACVRn(1):
+		return etm_read(ETMACVR1);
+	case ETMACVRn(2):
+		return etm_read(ETMACVR2);
+	case ETMACVRn(3):
+		return etm_read(ETMACVR3);
+	case ETMACVRn(4):
+		return etm_read(ETMACVR4);
+	case ETMACVRn(5):
+		return etm_read(ETMACVR5);
+	case ETMACVRn(6):
+		return etm_read(ETMACVR6);
+	case ETMACVRn(7):
+		return etm_read(ETMACVR7);
+	case ETMACVRn(8):
+		return etm_read(ETMACVR8);
+	case ETMACVRn(9):
+		return etm_read(ETMACVR9);
+	case ETMACVRn(10):
+		return etm_read(ETMACVR10);
+	case ETMACVRn(11):
+		return etm_read(ETMACVR11);
+	case ETMACVRn(12):
+		return etm_read(ETMACVR12);
+	case ETMACVRn(13):
+		return etm_read(ETMACVR13);
+	case ETMACVRn(14):
+		return etm_read(ETMACVR14);
+	case ETMACVRn(15):
+		return etm_read(ETMACVR15);
+	case ETMACTRn(0):
+		return etm_read(ETMACTR0);
+	case ETMACTRn(1):
+		return etm_read(ETMACTR1);
+	case ETMACTRn(2):
+		return etm_read(ETMACTR2);
+	case ETMACTRn(3):
+		return etm_read(ETMACTR3);
+	case ETMACTRn(4):
+		return etm_read(ETMACTR4);
+	case ETMACTRn(5):
+		return etm_read(ETMACTR5);
+	case ETMACTRn(6):
+		return etm_read(ETMACTR6);
+	case ETMACTRn(7):
+		return etm_read(ETMACTR7);
+	case ETMACTRn(8):
+		return etm_read(ETMACTR8);
+	case ETMACTRn(9):
+		return etm_read(ETMACTR9);
+	case ETMACTRn(10):
+		return etm_read(ETMACTR10);
+	case ETMACTRn(11):
+		return etm_read(ETMACTR11);
+	case ETMACTRn(12):
+		return etm_read(ETMACTR12);
+	case ETMACTRn(13):
+		return etm_read(ETMACTR13);
+	case ETMACTRn(14):
+		return etm_read(ETMACTR14);
+	case ETMACTRn(15):
+		return etm_read(ETMACTR15);
+	case ETMCNTRLDVRn(0):
+		return etm_read(ETMCNTRLDVR0);
+	case ETMCNTRLDVRn(1):
+		return etm_read(ETMCNTRLDVR1);
+	case ETMCNTRLDVRn(2):
+		return etm_read(ETMCNTRLDVR2);
+	case ETMCNTRLDVRn(3):
+		return etm_read(ETMCNTRLDVR3);
+	case ETMCNTENRn(0):
+		return etm_read(ETMCNTENR0);
+	case ETMCNTENRn(1):
+		return etm_read(ETMCNTENR1);
+	case ETMCNTENRn(2):
+		return etm_read(ETMCNTENR2);
+	case ETMCNTENRn(3):
+		return etm_read(ETMCNTENR3);
+	case ETMCNTRLDEVRn(0):
+		return etm_read(ETMCNTRLDEVR0);
+	case ETMCNTRLDEVRn(1):
+		return etm_read(ETMCNTRLDEVR1);
+	case ETMCNTRLDEVRn(2):
+		return etm_read(ETMCNTRLDEVR2);
+	case ETMCNTRLDEVRn(3):
+		return etm_read(ETMCNTRLDEVR3);
+	case ETMCNTVRn(0):
+		return etm_read(ETMCNTVR0);
+	case ETMCNTVRn(1):
+		return etm_read(ETMCNTVR1);
+	case ETMCNTVRn(2):
+		return etm_read(ETMCNTVR2);
+	case ETMCNTVRn(3):
+		return etm_read(ETMCNTVR3);
+	case ETMSQ12EVR:
+		return etm_read(ETMSQ12EVR);
+	case ETMSQ21EVR:
+		return etm_read(ETMSQ21EVR);
+	case ETMSQ23EVR:
+		return etm_read(ETMSQ23EVR);
+	case ETMSQ31EVR:
+		return etm_read(ETMSQ31EVR);
+	case ETMSQ32EVR:
+		return etm_read(ETMSQ32EVR);
+	case ETMSQ13EVR:
+		return etm_read(ETMSQ13EVR);
+	case ETMSQR:
+		return etm_read(ETMSQR);
+	case ETMEXTOUTEVRn(0):
+		return etm_read(ETMEXTOUTEVR0);
+	case ETMEXTOUTEVRn(1):
+		return etm_read(ETMEXTOUTEVR1);
+	case ETMEXTOUTEVRn(2):
+		return etm_read(ETMEXTOUTEVR2);
+	case ETMEXTOUTEVRn(3):
+		return etm_read(ETMEXTOUTEVR3);
+	case ETMCIDCVRn(0):
+		return etm_read(ETMCIDCVR0);
+	case ETMCIDCVRn(1):
+		return etm_read(ETMCIDCVR1);
+	case ETMCIDCVRn(2):
+		return etm_read(ETMCIDCVR2);
+	case ETMCIDCMR:
+		return etm_read(ETMCIDCMR);
+	case ETMIMPSPEC0:
+		return etm_read(ETMIMPSPEC0);
+	case ETMIMPSPEC1:
+		return etm_read(ETMIMPSPEC1);
+	case ETMIMPSPEC2:
+		return etm_read(ETMIMPSPEC2);
+	case ETMIMPSPEC3:
+		return etm_read(ETMIMPSPEC3);
+	case ETMIMPSPEC4:
+		return etm_read(ETMIMPSPEC4);
+	case ETMIMPSPEC5:
+		return etm_read(ETMIMPSPEC5);
+	case ETMIMPSPEC6:
+		return etm_read(ETMIMPSPEC6);
+	case ETMIMPSPEC7:
+		return etm_read(ETMIMPSPEC7);
+	case ETMSYNCFR:
+		return etm_read(ETMSYNCFR);
+	case ETMIDR:
+		return etm_read(ETMIDR);
+	case ETMCCER:
+		return etm_read(ETMCCER);
+	case ETMEXTINSELR:
+		return etm_read(ETMEXTINSELR);
+	case ETMTESSEICR:
+		return etm_read(ETMTESSEICR);
+	case ETMEIBCR:
+		return etm_read(ETMEIBCR);
+	case ETMTSEVR:
+		return etm_read(ETMTSEVR);
+	case ETMAUXCR:
+		return etm_read(ETMAUXCR);
+	case ETMTRACEIDR:
+		return etm_read(ETMTRACEIDR);
+	case ETMVMIDCVR:
+		return etm_read(ETMVMIDCVR);
+	case ETMOSLSR:
+		return etm_read(ETMOSLSR);
+	case ETMOSSRR:
+		return etm_read(ETMOSSRR);
+	case ETMPDCR:
+		return etm_read(ETMPDCR);
+	case ETMPDSR:
+		return etm_read(ETMPDSR);
+	default:
+		WARN(1, "invalid CP14 access to ETM reg: %lx",
+							(unsigned long)reg);
+		return 0;
+	}
+}
+
+void etm_writel_cp14(u32 val, u32 reg)
+{
+	switch (reg) {
+	case ETMCR:
+		etm_write(val, ETMCR);
+		return;
+	case ETMTRIGGER:
+		etm_write(val, ETMTRIGGER);
+		return;
+	case ETMSR:
+		etm_write(val, ETMSR);
+		return;
+	case ETMTSSCR:
+		etm_write(val, ETMTSSCR);
+		return;
+	case ETMTEEVR:
+		etm_write(val, ETMTEEVR);
+		return;
+	case ETMTECR1:
+		etm_write(val, ETMTECR1);
+		return;
+	case ETMFFLR:
+		etm_write(val, ETMFFLR);
+		return;
+	case ETMACVRn(0):
+		etm_write(val, ETMACVR0);
+		return;
+	case ETMACVRn(1):
+		etm_write(val, ETMACVR1);
+		return;
+	case ETMACVRn(2):
+		etm_write(val, ETMACVR2);
+		return;
+	case ETMACVRn(3):
+		etm_write(val, ETMACVR3);
+		return;
+	case ETMACVRn(4):
+		etm_write(val, ETMACVR4);
+		return;
+	case ETMACVRn(5):
+		etm_write(val, ETMACVR5);
+		return;
+	case ETMACVRn(6):
+		etm_write(val, ETMACVR6);
+		return;
+	case ETMACVRn(7):
+		etm_write(val, ETMACVR7);
+		return;
+	case ETMACVRn(8):
+		etm_write(val, ETMACVR8);
+		return;
+	case ETMACVRn(9):
+		etm_write(val, ETMACVR9);
+		return;
+	case ETMACVRn(10):
+		etm_write(val, ETMACVR10);
+		return;
+	case ETMACVRn(11):
+		etm_write(val, ETMACVR11);
+		return;
+	case ETMACVRn(12):
+		etm_write(val, ETMACVR12);
+		return;
+	case ETMACVRn(13):
+		etm_write(val, ETMACVR13);
+		return;
+	case ETMACVRn(14):
+		etm_write(val, ETMACVR14);
+		return;
+	case ETMACVRn(15):
+		etm_write(val, ETMACVR15);
+		return;
+	case ETMACTRn(0):
+		etm_write(val, ETMACTR0);
+		return;
+	case ETMACTRn(1):
+		etm_write(val, ETMACTR1);
+		return;
+	case ETMACTRn(2):
+		etm_write(val, ETMACTR2);
+		return;
+	case ETMACTRn(3):
+		etm_write(val, ETMACTR3);
+		return;
+	case ETMACTRn(4):
+		etm_write(val, ETMACTR4);
+		return;
+	case ETMACTRn(5):
+		etm_write(val, ETMACTR5);
+		return;
+	case ETMACTRn(6):
+		etm_write(val, ETMACTR6);
+		return;
+	case ETMACTRn(7):
+		etm_write(val, ETMACTR7);
+		return;
+	case ETMACTRn(8):
+		etm_write(val, ETMACTR8);
+		return;
+	case ETMACTRn(9):
+		etm_write(val, ETMACTR9);
+		return;
+	case ETMACTRn(10):
+		etm_write(val, ETMACTR10);
+		return;
+	case ETMACTRn(11):
+		etm_write(val, ETMACTR11);
+		return;
+	case ETMACTRn(12):
+		etm_write(val, ETMACTR12);
+		return;
+	case ETMACTRn(13):
+		etm_write(val, ETMACTR13);
+		return;
+	case ETMACTRn(14):
+		etm_write(val, ETMACTR14);
+		return;
+	case ETMACTRn(15):
+		etm_write(val, ETMACTR15);
+		return;
+	case ETMCNTRLDVRn(0):
+		etm_write(val, ETMCNTRLDVR0);
+		return;
+	case ETMCNTRLDVRn(1):
+		etm_write(val, ETMCNTRLDVR1);
+		return;
+	case ETMCNTRLDVRn(2):
+		etm_write(val, ETMCNTRLDVR2);
+		return;
+	case ETMCNTRLDVRn(3):
+		etm_write(val, ETMCNTRLDVR3);
+		return;
+	case ETMCNTENRn(0):
+		etm_write(val, ETMCNTENR0);
+		return;
+	case ETMCNTENRn(1):
+		etm_write(val, ETMCNTENR1);
+		return;
+	case ETMCNTENRn(2):
+		etm_write(val, ETMCNTENR2);
+		return;
+	case ETMCNTENRn(3):
+		etm_write(val, ETMCNTENR3);
+		return;
+	case ETMCNTRLDEVRn(0):
+		etm_write(val, ETMCNTRLDEVR0);
+		return;
+	case ETMCNTRLDEVRn(1):
+		etm_write(val, ETMCNTRLDEVR1);
+		return;
+	case ETMCNTRLDEVRn(2):
+		etm_write(val, ETMCNTRLDEVR2);
+		return;
+	case ETMCNTRLDEVRn(3):
+		etm_write(val, ETMCNTRLDEVR3);
+		return;
+	case ETMCNTVRn(0):
+		etm_write(val, ETMCNTVR0);
+		return;
+	case ETMCNTVRn(1):
+		etm_write(val, ETMCNTVR1);
+		return;
+	case ETMCNTVRn(2):
+		etm_write(val, ETMCNTVR2);
+		return;
+	case ETMCNTVRn(3):
+		etm_write(val, ETMCNTVR3);
+		return;
+	case ETMSQ12EVR:
+		etm_write(val, ETMSQ12EVR);
+		return;
+	case ETMSQ21EVR:
+		etm_write(val, ETMSQ21EVR);
+		return;
+	case ETMSQ23EVR:
+		etm_write(val, ETMSQ23EVR);
+		return;
+	case ETMSQ31EVR:
+		etm_write(val, ETMSQ31EVR);
+		return;
+	case ETMSQ32EVR:
+		etm_write(val, ETMSQ32EVR);
+		return;
+	case ETMSQ13EVR:
+		etm_write(val, ETMSQ13EVR);
+		return;
+	case ETMSQR:
+		etm_write(val, ETMSQR);
+		return;
+	case ETMEXTOUTEVRn(0):
+		etm_write(val, ETMEXTOUTEVR0);
+		return;
+	case ETMEXTOUTEVRn(1):
+		etm_write(val, ETMEXTOUTEVR1);
+		return;
+	case ETMEXTOUTEVRn(2):
+		etm_write(val, ETMEXTOUTEVR2);
+		return;
+	case ETMEXTOUTEVRn(3):
+		etm_write(val, ETMEXTOUTEVR3);
+		return;
+	case ETMCIDCVRn(0):
+		etm_write(val, ETMCIDCVR0);
+		return;
+	case ETMCIDCVRn(1):
+		etm_write(val, ETMCIDCVR1);
+		return;
+	case ETMCIDCVRn(2):
+		etm_write(val, ETMCIDCVR2);
+		return;
+	case ETMCIDCMR:
+		etm_write(val, ETMCIDCMR);
+		return;
+	case ETMIMPSPEC0:
+		etm_write(val, ETMIMPSPEC0);
+		return;
+	case ETMIMPSPEC1:
+		etm_write(val, ETMIMPSPEC1);
+		return;
+	case ETMIMPSPEC2:
+		etm_write(val, ETMIMPSPEC2);
+		return;
+	case ETMIMPSPEC3:
+		etm_write(val, ETMIMPSPEC3);
+		return;
+	case ETMIMPSPEC4:
+		etm_write(val, ETMIMPSPEC4);
+		return;
+	case ETMIMPSPEC5:
+		etm_write(val, ETMIMPSPEC5);
+		return;
+	case ETMIMPSPEC6:
+		etm_write(val, ETMIMPSPEC6);
+		return;
+	case ETMIMPSPEC7:
+		etm_write(val, ETMIMPSPEC7);
+		return;
+	case ETMSYNCFR:
+		etm_write(val, ETMSYNCFR);
+		return;
+	case ETMEXTINSELR:
+		etm_write(val, ETMEXTINSELR);
+		return;
+	case ETMTESSEICR:
+		etm_write(val, ETMTESSEICR);
+		return;
+	case ETMEIBCR:
+		etm_write(val, ETMEIBCR);
+		return;
+	case ETMTSEVR:
+		etm_write(val, ETMTSEVR);
+		return;
+	case ETMAUXCR:
+		etm_write(val, ETMAUXCR);
+		return;
+	case ETMTRACEIDR:
+		etm_write(val, ETMTRACEIDR);
+		return;
+	case ETMVMIDCVR:
+		etm_write(val, ETMVMIDCVR);
+		return;
+	case ETMOSLAR:
+		etm_write(val, ETMOSLAR);
+		return;
+	case ETMOSSRR:
+		etm_write(val, ETMOSSRR);
+		return;
+	case ETMPDCR:
+		etm_write(val, ETMPDCR);
+		return;
+	case ETMPDSR:
+		etm_write(val, ETMPDSR);
+		return;
+	default:
+		WARN(1, "invalid CP14 access to ETM reg: %lx",
+							(unsigned long)reg);
+		return;
+	}
+}
diff --git a/drivers/coresight/coresight-etm.h b/drivers/coresight/coresight-etm.h
new file mode 100644
index 0000000..a88ddf4
--- /dev/null
+++ b/drivers/coresight/coresight-etm.h
@@ -0,0 +1,250 @@
+/* Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CORESIGHT_CORESIGHT_ETM_H
+#define _CORESIGHT_CORESIGHT_ETM_H
+
+#include <linux/spinlock.h>
+#include "coresight-priv.h"
+
+/*
+ * Device registers:
+ * 0x000 - 0x2FC: Trace         registers
+ * 0x300 - 0x314: Management    registers
+ * 0x318 - 0xEFC: Trace         registers
+ *
+ * Coresight registers
+ * 0xF00 - 0xF9C: Management    registers
+ * 0xFA0 - 0xFA4: Management    registers in PFTv1.0
+ *                Trace         registers in PFTv1.1
+ * 0xFA8 - 0xFFC: Management    registers
+ */
+
+/* Trace registers (0x000-0x2FC) */
+#define ETMCR			0x000
+#define ETMCCR			0x004
+#define ETMTRIGGER		0x008
+#define ETMSR			0x010
+#define ETMSCR			0x014
+#define ETMTSSCR		0x018
+#define ETMTECR2		0x01c
+#define ETMTEEVR		0x020
+#define ETMTECR1		0x024
+#define ETMFFLR			0x02c
+#define ETMACVRn(n)		(0x040 + (n * 4))
+#define ETMACTRn(n)		(0x080 + (n * 4))
+#define ETMCNTRLDVRn(n)		(0x140 + (n * 4))
+#define ETMCNTENRn(n)		(0x150 + (n * 4))
+#define ETMCNTRLDEVRn(n)	(0x160 + (n * 4))
+#define ETMCNTVRn(n)		(0x170 + (n * 4))
+#define ETMSQ12EVR		0x180
+#define ETMSQ21EVR		0x184
+#define ETMSQ23EVR		0x188
+#define ETMSQ31EVR		0x18c
+#define ETMSQ32EVR		0x190
+#define ETMSQ13EVR		0x194
+#define ETMSQR			0x19c
+#define ETMEXTOUTEVRn(n)	(0x1a0 + (n * 4))
+#define ETMCIDCVRn(n)		(0x1b0 + (n * 4))
+#define ETMCIDCMR		0x1bc
+#define ETMIMPSPEC0		0x1c0
+#define ETMIMPSPEC1		0x1c4
+#define ETMIMPSPEC2		0x1c8
+#define ETMIMPSPEC3		0x1cc
+#define ETMIMPSPEC4		0x1d0
+#define ETMIMPSPEC5		0x1d4
+#define ETMIMPSPEC6		0x1d8
+#define ETMIMPSPEC7		0x1dc
+#define ETMSYNCFR		0x1e0
+#define ETMIDR			0x1e4
+#define ETMCCER			0x1e8
+#define ETMEXTINSELR		0x1ec
+#define ETMTESSEICR		0x1f0
+#define ETMEIBCR		0x1f4
+#define ETMTSEVR		0x1f8
+#define ETMAUXCR		0x1fc
+#define ETMTRACEIDR		0x200
+#define ETMVMIDCVR		0x240
+/* Management registers (0x300-0x314) */
+#define ETMOSLAR		0x300
+#define ETMOSLSR		0x304
+#define ETMOSSRR		0x308
+#define ETMPDCR			0x310
+#define ETMPDSR			0x314
+#define ETM_MAX_ADDR_CMP	16
+#define ETM_MAX_CNTR		4
+#define ETM_MAX_CTXID_CMP	3
+
+/** register definition **/
+/* ETMCR - 0x00 */
+#define ETMCR_PWD_DWN		BIT(0)
+#define ETMCR_STALL_MODE	BIT(7)
+#define ETMCR_ETM_PRG		BIT(10)
+#define ETMCR_ETM_EN		BIT(11)
+#define ETMCR_CYC_ACC		BIT(12)
+#define ETMCR_CTXID_SIZE	(BIT(14)|BIT(15))
+#define ETMCR_TIMESTAMP_EN	BIT(28)
+/* ETMCCR - 0x04 */
+#define ETMCCR_FIFOFULL		BIT(23)
+/* ETMPDCR - 0x310 */
+#define ETMPDCR_PWD_UP		BIT(3)
+/* ETMTECR1 - 0x024 */
+#define ETMTECR1_ADDR_COMP_1	BIT(0)
+#define ETMTECR1_INC_EXC	BIT(24)
+#define ETMTECR1_START_STOP	BIT(25)
+/* ETMCCER - 0x1E8 */
+#define ETMCCER_TIMESTAMP	BIT(22)
+
+#define ETM_MODE_EXCLUDE	BIT(0)
+#define ETM_MODE_CYCACC		BIT(1)
+#define ETM_MODE_STALL		BIT(2)
+#define ETM_MODE_TIMESTAMP	BIT(3)
+#define ETM_MODE_CTXID		BIT(4)
+#define ETM_MODE_ALL		0x1f
+
+#define ETM_SQR_MASK		0x3
+#define ETM_TRACEID_MASK	0x3f
+#define ETM_EVENT_MASK		0x1ffff
+#define ETM_SYNC_MASK		0xfff
+#define ETM_ALL_MASK		0xffffffff
+
+#define ETMSR_PROG_BIT		1
+#define ETM_SEQ_STATE_MAX_VAL	(0x2)
+#define PORT_SIZE_MASK		(GENMASK(21, 21) | GENMASK(6, 4))
+
+#define ETM_HARD_WIRE_RES_A	/* Hard wired, always true */	\
+				((0x0f << 0)	|		\
+				/* Resource index A */		\
+				(0x06 << 4))
+
+#define ETM_ADD_COMP_0		/* single addr comparator 1 */	\
+				((0x00 << 7)	|		\
+				/* Resource index B */		\
+				(0x00 << 11))
+
+#define ETM_EVENT_NOT_A		BIT(14) /* NOT(A) */
+
+#define ETM_DEFAULT_EVENT_VAL	(ETM_HARD_WIRE_RES_A	|	\
+				 ETM_ADD_COMP_0		|	\
+				 ETM_EVENT_NOT_A)
+/**
+ * @base:	memory mapped base address for this component.
+ * @dev:	the device entity associated to this component.
+ * @csdev:	component vitals needed by the framework.
+ * @clk:	the clock this component is associated to.
+ * @spinlock:	only one at a time pls.
+ * @cpu:	the cpu this component is affined to.
+ * @port_size:	port size as reported by ETMCR bit 4-6 and 21.
+ * @arch:	ETM/PTM version number.
+ * @use_cpu14:	true if management registers need to be accessed via CP14.
+ * @enable:	is this ETM/PTM currently tracing.
+ * @sticky_enable: true if ETM base configuration has been done.
+ * @boot_enable:true if we should start tracing at boot time.
+ * @os_unlock:	true if access to management registers is allowed.
+ * @nr_addr_cmp:Number of pairs of address comparators as found in ETMCCR.
+ * @nr_cntr:	Number of counters as found in ETMCCR bit 13-15.
+ * @nr_ext_inp:	Number of external input as found in ETMCCR bit 17-19.
+ * @nr_ext_out:	Number of external output as found in ETMCCR bit 20-22.
+ * @nr_ctxid_cmp: Number of contextID comparators as found in ETMCCR bit 24-25.
+ * @etmccr:	value of register ETMCCR.
+ * @etmccer:	value of register ETMCCER.
+ * @traceid:	value of the current ID for this component.
+ * @mode:	controls various modes supported by this ETM/PTM.
+ * @ctrl:	used in conjuction with @mode.
+ * @trigger_event: setting for register ETMTRIGGER.
+ * @startstop_ctrl: setting for register ETMTSSCR.
+ * @enable_event: setting for register ETMTEEVR.
+ * @enable_ctrl1: setting for register ETMTECR1.
+ * @fifofull_level: setting for register ETMFFLR.
+ * @addr_idx:	index for the address comparator selection.
+ * @addr_val:	value for address comparator register.
+ * @addr_acctype: access type for address comparator register.
+ * @addr_type:	current status of the comparator register.
+ * @cntr_idx:	index for the counter register selection.
+ * @cntr_rld_val: reload value of a counter register.
+ * @cntr_event:	control for counter enable register.
+ * @cntr_rld_event: value for counter reload event register.
+ * @cntr_val:	counter value register.
+ * @seq_12_event: event causing the transition from 1 to 2.
+ * @seq_21_event: event causing the transition from 2 to 1.
+ * @seq_23_event: event causing the transition from 2 to 3.
+ * @seq_31_event: event causing the transition from 3 to 1.
+ * @seq_32_event: event causing the transition from 3 to 2.
+ * @seq_13_event: event causing the transition from 1 to 3.
+ * @seq_curr_state: current value of the sequencer register.
+ * @ctxid_idx: index for the context ID registers.
+ * @ctxid_val: value for the context ID to trigger on.
+ * @ctxid_mask: mask applicable to all the context IDs.
+ * @sync_freq:	Synchronisation frequency.
+ * @timestamp_event: Defines an event that requests the insertion
+		 of a timestamp into the trace stream.
+ */
+struct etm_drvdata {
+	void __iomem			*base;
+	struct device			*dev;
+	struct coresight_device		*csdev;
+	struct clk			*clk;
+	spinlock_t			spinlock;
+	int				cpu;
+	int				port_size;
+	u8				arch;
+	bool				use_cp14;
+	bool				enable;
+	bool				sticky_enable;
+	bool				boot_enable;
+	bool				os_unlock;
+	u8				nr_addr_cmp;
+	u8				nr_cntr;
+	u8				nr_ext_inp;
+	u8				nr_ext_out;
+	u8				nr_ctxid_cmp;
+	u32				etmccr;
+	u32				etmccer;
+	u32				traceid;
+	u32				mode;
+	u32				ctrl;
+	u32				trigger_event;
+	u32				startstop_ctrl;
+	u32				enable_event;
+	u32				enable_ctrl1;
+	u32				fifofull_level;
+	u8				addr_idx;
+	u32				addr_val[ETM_MAX_ADDR_CMP];
+	u32				addr_acctype[ETM_MAX_ADDR_CMP];
+	u32				addr_type[ETM_MAX_ADDR_CMP];
+	u8				cntr_idx;
+	u32				cntr_rld_val[ETM_MAX_CNTR];
+	u32				cntr_event[ETM_MAX_CNTR];
+	u32				cntr_rld_event[ETM_MAX_CNTR];
+	u32				cntr_val[ETM_MAX_CNTR];
+	u32				seq_12_event;
+	u32				seq_21_event;
+	u32				seq_23_event;
+	u32				seq_31_event;
+	u32				seq_32_event;
+	u32				seq_13_event;
+	u32				seq_curr_state;
+	u8				ctxid_idx;
+	u32				ctxid_val[ETM_MAX_CTXID_CMP];
+	u32				ctxid_mask;
+	u32				sync_freq;
+	u32				timestamp_event;
+};
+
+enum etm_addr_type {
+	ETM_ADDR_TYPE_NONE,
+	ETM_ADDR_TYPE_SINGLE,
+	ETM_ADDR_TYPE_RANGE,
+	ETM_ADDR_TYPE_START,
+	ETM_ADDR_TYPE_STOP,
+};
+#endif
diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
new file mode 100644
index 0000000..5a929ff
--- /dev/null
+++ b/drivers/coresight/coresight-etm3x.c
@@ -0,0 +1,1722 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "coresight: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/sysfs.h>
+#include <linux/stat.h>
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/of.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <asm/sections.h>
+
+#include "coresight-etm.h"
+
+#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
+static int boot_enable = 1;
+#else
+static int boot_enable;
+#endif
+module_param_named(
+	boot_enable, boot_enable, int, S_IRUGO
+);
+
+static int etm_count; /* the number of ETM/PTM currently registered */
+static struct etm_drvdata *etmdrvdata[NR_CPUS];
+
+static inline void etm_writel(struct etm_drvdata *drvdata,
+			      u32 val, u32 off)
+{
+	if (drvdata->use_cp14)
+		etm_writel_cp14(val, off);
+	else
+		writel_relaxed(val, drvdata->base + off);
+}
+
+static inline unsigned int etm_readl(struct etm_drvdata *drvdata, u32 off)
+{
+	u32 val;
+
+	if (drvdata->use_cp14)
+		val = etm_readl_cp14(off);
+	else
+		val = readl_relaxed(drvdata->base + off);
+	return val;
+}
+
+/*
+ * Memory mapped writes to clear os lock are not supported on some processors
+ * and OS lock must be unlocked before any memory mapped access on such
+ * processors, otherwise memory mapped reads/writes will be invalid.
+ */
+static void etm_os_unlock(void *info)
+{
+	struct etm_drvdata *drvdata = (struct etm_drvdata *)info;
+	/* writing any value to ETMOSLAR unlocks the trace registers */
+	etm_writel(drvdata, 0x0, ETMOSLAR);
+	isb();
+}
+
+static void etm_set_pwrdwn(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	/* Ensure pending cp14 accesses complete before setting pwrdwn */
+	mb();
+	isb();
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= ETMCR_PWD_DWN;
+	etm_writel(drvdata, etmcr, ETMCR);
+}
+
+static void etm_clr_pwrdwn(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~ETMCR_PWD_DWN;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_set_pwrup(struct etm_drvdata *drvdata)
+{
+	u32 etmpdcr;
+
+	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
+	etmpdcr |= ETMPDCR_PWD_UP;
+	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_clr_pwrup(struct etm_drvdata *drvdata)
+{
+	u32 etmpdcr;
+
+	/* Ensure pending cp14 accesses complete before clearing pwrup */
+	mb();
+	isb();
+	etmpdcr = readl_relaxed(drvdata->base + ETMPDCR);
+	etmpdcr &= ~ETMPDCR_PWD_UP;
+	writel_relaxed(etmpdcr, drvdata->base + ETMPDCR);
+}
+
+/**
+ * coresight_timeout_etm - loop until a bit has changed to a specific state.
+ * @drvdata: etm's private data structure.
+ * @offset: address of a register, starting from @addr.
+ * @position: the position of the bit of interest.
+ * @value: the value the bit should have.
+ *
+ * Returns as soon as the bit has taken the desired state or TIMEOU_US has
+ * elapsed, which ever happens first.  Basically the same as
+ * @coresight_timeout except for the register access methods where we have
+ * to account for CP14 configurations.
+ */
+
+static void coresight_timeout_etm(struct etm_drvdata *drvdata, u32 offset,
+				  int position, int value)
+{
+	int i;
+	u32 val;
+
+	for (i = TIMEOUT_US; i > 0; i--) {
+		val = etm_readl(drvdata, offset);
+		/* waiting on the bit to go from 0 to 1 */
+		if (value) {
+			if (val & BIT(position))
+				return;
+		/* waiting on the bit to go from 1 to 0 */
+		} else {
+			if (!(val & BIT(position)))
+				return;
+		}
+
+		/* The specification doesn't say how long we are expected
+		 * to wait.
+		 */
+		udelay(1);
+	}
+
+	WARN(1,
+	     "coresight: timeout observed when proving at offset %#x\n",
+	     offset);
+}
+
+
+static void etm_set_prog(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= ETMCR_ETM_PRG;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 1);
+}
+
+static void etm_clr_prog(struct etm_drvdata *drvdata)
+{
+	u32 etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~ETMCR_ETM_PRG;
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	coresight_timeout_etm(drvdata, ETMSR, ETMSR_PROG_BIT, 0);
+}
+
+static void etm_set_default(struct etm_drvdata *drvdata)
+{
+	int i;
+
+	drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->enable_event = ETM_HARD_WIRE_RES_A;
+
+	drvdata->seq_12_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_21_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_23_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_31_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_32_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->seq_13_event = ETM_DEFAULT_EVENT_VAL;
+	drvdata->timestamp_event = ETM_DEFAULT_EVENT_VAL;
+
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		drvdata->cntr_rld_val[i] = 0x0;
+		drvdata->cntr_event[i] = ETM_DEFAULT_EVENT_VAL;
+		drvdata->cntr_rld_event[i] = ETM_DEFAULT_EVENT_VAL;
+		drvdata->cntr_val[i] = 0x0;
+	}
+
+	drvdata->seq_curr_state = 0x0;
+	drvdata->ctxid_idx = 0x0;
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+		drvdata->ctxid_val[i] = 0x0;
+	drvdata->ctxid_mask = 0x0;
+}
+
+static void etm_enable_hw(void *info)
+{
+	int i;
+	u32 etmcr;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+
+	/* turn engine on */
+	etm_clr_pwrdwn(drvdata);
+	/* apply power to trace registers */
+	etm_set_pwrup(drvdata);
+	/* make sure all registers are accessible */
+	etm_os_unlock(drvdata);
+
+	etm_set_prog(drvdata);
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= (ETMCR_PWD_DWN | ETMCR_ETM_PRG);
+	etmcr |= drvdata->port_size;
+	etm_writel(drvdata, drvdata->ctrl | etmcr, ETMCR);
+	etm_writel(drvdata, drvdata->trigger_event, ETMTRIGGER);
+	etm_writel(drvdata, drvdata->startstop_ctrl, ETMTSSCR);
+	etm_writel(drvdata, drvdata->enable_event, ETMTEEVR);
+	etm_writel(drvdata, drvdata->enable_ctrl1, ETMTECR1);
+	etm_writel(drvdata, drvdata->fifofull_level, ETMFFLR);
+	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+		etm_writel(drvdata, drvdata->addr_val[i], ETMACVRn(i));
+		etm_writel(drvdata, drvdata->addr_acctype[i], ETMACTRn(i));
+	}
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		etm_writel(drvdata, drvdata->cntr_rld_val[i], ETMCNTRLDVRn(i));
+		etm_writel(drvdata, drvdata->cntr_event[i], ETMCNTENRn(i));
+		etm_writel(drvdata, drvdata->cntr_rld_event[i],
+			   ETMCNTRLDEVRn(i));
+		etm_writel(drvdata, drvdata->cntr_val[i], ETMCNTVRn(i));
+	}
+	etm_writel(drvdata, drvdata->seq_12_event, ETMSQ12EVR);
+	etm_writel(drvdata, drvdata->seq_21_event, ETMSQ21EVR);
+	etm_writel(drvdata, drvdata->seq_23_event, ETMSQ23EVR);
+	etm_writel(drvdata, drvdata->seq_31_event, ETMSQ31EVR);
+	etm_writel(drvdata, drvdata->seq_32_event, ETMSQ32EVR);
+	etm_writel(drvdata, drvdata->seq_13_event, ETMSQ13EVR);
+	etm_writel(drvdata, drvdata->seq_curr_state, ETMSQR);
+	for (i = 0; i < drvdata->nr_ext_out; i++)
+		etm_writel(drvdata, ETM_DEFAULT_EVENT_VAL, ETMEXTOUTEVRn(i));
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
+	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
+	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
+	/* no external input selected */
+	etm_writel(drvdata, 0x0, ETMEXTINSELR);
+	etm_writel(drvdata, drvdata->timestamp_event, ETMTSEVR);
+	/* no auxiliary control selected */
+	etm_writel(drvdata, 0x0, ETMAUXCR);
+	etm_writel(drvdata, drvdata->traceid, ETMTRACEIDR);
+	/* no VMID comparator value selected */
+	etm_writel(drvdata, 0x0, ETMVMIDCVR);
+
+	/* ensures trace output is enabled from this ETM */
+	etm_writel(drvdata, drvdata->ctrl | ETMCR_ETM_EN | etmcr, ETMCR);
+
+	etm_clr_prog(drvdata);
+	CS_LOCK(drvdata->base);
+
+	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
+}
+
+static int etm_trace_id_simple(struct etm_drvdata *drvdata)
+{
+	if (!drvdata->enable)
+		return drvdata->traceid;
+
+	return (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+}
+
+static int etm_trace_id(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	unsigned long flags;
+	int trace_id = -1;
+
+	if (!drvdata->enable)
+		return drvdata->traceid;
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	trace_id = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return trace_id;
+}
+
+static int etm_enable(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto err_clk;
+
+	spin_lock(&drvdata->spinlock);
+
+	/* Configure the ETM only if the CPU is online.  If it isn't online
+	 * hw configuration will take place when 'CPU_STARTING' is received
+	 * in @etm_cpu_callback.
+	 */
+	if (cpu_online(drvdata->cpu)) {
+		ret = smp_call_function_single(drvdata->cpu,
+					       etm_enable_hw, drvdata, 1);
+		if (ret)
+			goto err;
+	}
+
+	drvdata->enable = true;
+	drvdata->sticky_enable = true;
+
+	spin_unlock(&drvdata->spinlock);
+
+	dev_info(drvdata->dev, "ETM tracing enabled\n");
+	return 0;
+err:
+	spin_unlock(&drvdata->spinlock);
+	clk_disable_unprepare(drvdata->clk);
+err_clk:
+	return ret;
+}
+
+static void etm_disable_hw(void *info)
+{
+	int i;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+	etm_set_prog(drvdata);
+
+	/* Program trace enable to low by using always false event */
+	etm_writel(drvdata, ETM_HARD_WIRE_RES_A | ETM_EVENT_NOT_A, ETMTEEVR);
+
+	/* read back sequencer and counters for post trace analysis */
+	drvdata->seq_curr_state = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
+
+	for (i = 0; i < drvdata->nr_cntr; i++)
+		drvdata->cntr_val[i] = etm_readl(drvdata, ETMCNTVRn(i));
+
+	etm_set_pwrdwn(drvdata);
+	CS_LOCK(drvdata->base);
+
+	dev_dbg(drvdata->dev, "cpu: %d disable smp call done\n", drvdata->cpu);
+}
+
+static void etm_disable(struct coresight_device *csdev)
+{
+	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	/*
+	 * Taking hotplug lock here protects from clocks getting disabled
+	 * with tracing being left on (crash scenario) if user disable occurs
+	 * after cpu online mask indicates the cpu is offline but before the
+	 * DYING hotplug callback is serviced by the ETM driver.
+	 */
+	get_online_cpus();
+	spin_lock(&drvdata->spinlock);
+
+	/*
+	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
+	 * ensures that register writes occur when cpu is powered.
+	 */
+	smp_call_function_single(drvdata->cpu, etm_disable_hw, drvdata, 1);
+	drvdata->enable = false;
+
+	spin_unlock(&drvdata->spinlock);
+	put_online_cpus();
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "ETM tracing disabled\n");
+}
+
+static const struct coresight_ops_source etm_source_ops = {
+	.trace_id	= etm_trace_id,
+	.enable		= etm_enable,
+	.disable	= etm_disable,
+};
+
+static const struct coresight_ops etm_cs_ops = {
+	.source_ops	= &etm_source_ops,
+};
+
+static ssize_t debugfs_nr_addr_cmp_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->nr_addr_cmp;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_nr_addr_cmp, "nr_addr_cmp",
+			S_IRUGO, debugfs_nr_addr_cmp_get,
+			NULL, "%llx\n");
+
+static ssize_t debugfs_nr_cntr_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->nr_cntr;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_nr_cntr, "nr_cntr",
+			S_IRUGO, debugfs_nr_cntr_get,
+			NULL, "%llx\n");
+
+static ssize_t debugfs_nr_ctxid_cmp_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->nr_ctxid_cmp;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_nr_ctxid_cmp, "nr_ctxid_cmp",
+			S_IRUGO, debugfs_nr_ctxid_cmp_get,
+			NULL, "%llx\n");
+
+
+static ssize_t debugfs_etmsr_get(void *data, u64 *val)
+{
+	unsigned long flags;
+	struct etm_drvdata *drvdata = data;
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	*val = etm_readl(drvdata, ETMSR);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_etmsr, "etmsr",
+			S_IRUGO, debugfs_etmsr_get,
+			NULL, "%llx\n");
+
+/* Reset to trace everything i.e. exclude nothing. */
+static ssize_t debugfs_reset_set(void *data, u64 val)
+{
+	int i;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	if (val) {
+		drvdata->mode = ETM_MODE_EXCLUDE;
+		drvdata->ctrl = 0x0;
+		drvdata->trigger_event = ETM_DEFAULT_EVENT_VAL;
+		drvdata->startstop_ctrl = 0x0;
+		drvdata->addr_idx = 0x0;
+		for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+			drvdata->addr_val[i] = 0x0;
+			drvdata->addr_acctype[i] = 0x0;
+			drvdata->addr_type[i] = ETM_ADDR_TYPE_NONE;
+		}
+		drvdata->cntr_idx = 0x0;
+
+		etm_set_default(drvdata);
+	}
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_reset, "reset",
+			S_IWUSR, NULL,
+			debugfs_reset_set, "%llx\n");
+
+static ssize_t debugfs_mode_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->mode;
+	return 0;
+}
+
+static ssize_t debugfs_mode_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->mode = val & ETM_MODE_ALL;
+
+	if (drvdata->mode & ETM_MODE_EXCLUDE)
+		drvdata->enable_ctrl1 |= ETMTECR1_INC_EXC;
+	else
+		drvdata->enable_ctrl1 &= ~ETMTECR1_INC_EXC;
+
+	if (drvdata->mode & ETM_MODE_CYCACC)
+		drvdata->ctrl |= ETMCR_CYC_ACC;
+	else
+		drvdata->ctrl &= ~ETMCR_CYC_ACC;
+
+	if (drvdata->mode & ETM_MODE_STALL) {
+		if (!(drvdata->etmccr & ETMCCR_FIFOFULL)) {
+			pr_warn("stall mode not supported\n");
+			return -EINVAL;
+		}
+		drvdata->ctrl |= ETMCR_STALL_MODE;
+	 } else
+		drvdata->ctrl &= ~ETMCR_STALL_MODE;
+
+	if (drvdata->mode & ETM_MODE_TIMESTAMP) {
+		if (!(drvdata->etmccer & ETMCCER_TIMESTAMP)) {
+			pr_warn("timestamp not supported\n");
+			return -EINVAL;
+		}
+		drvdata->ctrl |= ETMCR_TIMESTAMP_EN;
+	} else
+		drvdata->ctrl &= ~ETMCR_TIMESTAMP_EN;
+
+	if (drvdata->mode & ETM_MODE_CTXID)
+		drvdata->ctrl |= ETMCR_CTXID_SIZE;
+	else
+		drvdata->ctrl &= ~ETMCR_CTXID_SIZE;
+	spin_unlock(&drvdata->spinlock);
+
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_mode, "mode",
+			 S_IRUGO | S_IWUSR, debugfs_mode_get,
+			 debugfs_mode_set, "%llx\n");
+
+static ssize_t debugfs_trigger_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->trigger_event;
+	return 0;
+}
+
+static ssize_t debugfs_trigger_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->trigger_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_trigger_event, "trigger_event",
+			S_IRUGO | S_IWUSR, debugfs_trigger_event_get,
+			debugfs_trigger_event_set, "%llx\n");
+
+static ssize_t debugfs_enable_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->enable_event;
+	return 0;
+}
+
+static ssize_t debugfs_enable_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->enable_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_enable_event, "enable_event",
+			S_IRUGO | S_IWUSR, debugfs_enable_event_get,
+			debugfs_enable_event_set, "%llx\n");
+
+static ssize_t debugfs_fifofull_level_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->fifofull_level;
+	return 0;
+}
+
+static ssize_t debugfs_fifofull_level_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->fifofull_level = val;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_fifofull_level, "fifofull_level",
+			S_IRUGO | S_IWUSR, debugfs_fifofull_level_get,
+			debugfs_fifofull_level_set, "%llx\n");
+
+static ssize_t debugfs_addr_idx_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->addr_idx;
+	return 0;
+}
+
+static ssize_t debugfs_addr_idx_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	if (val >= drvdata->nr_addr_cmp)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->addr_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_addr_idx, "addr_idx",
+			S_IRUGO | S_IWUSR, debugfs_addr_idx_get,
+			debugfs_addr_idx_set, "%llx\n");
+
+static ssize_t debugfs_addr_single_get(void *data, u64 *val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	*val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_addr_single_set(void *data, u64 val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_SINGLE;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_addr_single, "addr_single",
+			S_IRUGO | S_IWUSR, debugfs_addr_single_get,
+			debugfs_addr_single_set, "%llx\n");
+
+
+static ssize_t debugfs_get_addr_range(struct seq_file *f, void *ptr)
+{
+	u8 idx;
+	unsigned long val1, val2;
+	struct etm_drvdata *drvdata = f->private;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (idx % 2 != 0) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	val1 = drvdata->addr_val[idx];
+	val2 = drvdata->addr_val[idx + 1];
+	spin_unlock(&drvdata->spinlock);
+	seq_printf(f, "%#lx %#lx\n", val1, val2);
+
+	return 0;
+}
+
+static int debugfs_get_addr_range_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debugfs_get_addr_range, inode->i_private);
+}
+
+static ssize_t debugfs_set_addr_range(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	u8 idx;
+	unsigned long val1, val2;
+	struct seq_file *s = file->private_data;
+	struct etm_drvdata *drvdata = s->private;
+
+	if (sscanf(user_buf, "%lx %lx", &val1, &val2) != 2)
+		return -EINVAL;
+	/* Lower address comparator cannot have a higher address value */
+	if (val1 > val2)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (idx % 2 != 0) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	drvdata->addr_val[idx] = val1;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_RANGE;
+	drvdata->addr_val[idx + 1] = val2;
+	drvdata->addr_type[idx + 1] = ETM_ADDR_TYPE_RANGE;
+	drvdata->enable_ctrl1 |= (1 << (idx/2));
+	spin_unlock(&drvdata->spinlock);
+
+	return count;
+}
+
+static const struct file_operations debugfs_addr_range_ops = {
+	.open = debugfs_get_addr_range_open,
+	.read = seq_read,
+	.write = debugfs_set_addr_range,
+};
+
+static const struct coresight_ops_entry debugfs_addr_range_entry = {
+	.name = "addr_range",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_range_ops,
+};
+
+static ssize_t debugfs_addr_start_get(void *data, u64 *val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	*val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_addr_start_set(void *data, u64 val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_START;
+	drvdata->startstop_ctrl |= (1 << idx);
+	drvdata->enable_ctrl1 |= ETMTECR1_START_STOP;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_addr_start, "addr_start",
+			S_IRUGO | S_IWUSR, debugfs_addr_start_get,
+			debugfs_addr_start_set, "%llx\n");
+
+static ssize_t debugfs_addr_stop_get(void *data, u64 *val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	*val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_addr_stop_set(void *data, u64 val)
+{
+	u8 idx;
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EINVAL;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_STOP;
+	drvdata->startstop_ctrl |= (1 << (idx + 16));
+	drvdata->enable_ctrl1 |= ETMTECR1_START_STOP;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_addr_stop, "addr_stop",
+			S_IRUGO | S_IWUSR, debugfs_addr_stop_get,
+			debugfs_addr_stop_set, "%llx\n");
+
+static ssize_t debugfs_addr_acctype_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	*val = drvdata->addr_acctype[drvdata->addr_idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_addr_acctype_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->addr_acctype[drvdata->addr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_addr_acctype, "addr_acctype",
+			S_IRUGO | S_IWUSR, debugfs_addr_acctype_get,
+			debugfs_addr_acctype_set, "%llx\n");
+
+static ssize_t debugfs_cntr_idx_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata =  data;
+
+	*val = drvdata->cntr_idx;
+	return 0;
+}
+
+static ssize_t debugfs_cntr_idx_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata =  data;
+
+	if (val >= drvdata->nr_cntr)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_cntr_idx, "cntr_idx",
+			 S_IRUGO | S_IWUSR, debugfs_cntr_idx_get,
+			 debugfs_cntr_idx_set, "%llx\n");
+
+static ssize_t debugfs_cntr_rld_val_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	*val = drvdata->cntr_rld_val[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_cntr_rld_val_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_cntr_rld_val, "cntr_rld_val",
+			S_IRUGO | S_IWUSR, debugfs_cntr_rld_val_get,
+			debugfs_cntr_rld_val_set, "%llx\n");
+
+static ssize_t debugfs_cntr_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	*val = drvdata->cntr_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_cntr_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_cntr_event, "cntr_event",
+			S_IRUGO | S_IWUSR, debugfs_cntr_event_get,
+			debugfs_cntr_event_set, "%llx\n");
+
+static ssize_t debugfs_cntr_rld_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	*val = drvdata->cntr_rld_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+
+static ssize_t debugfs_cntr_rld_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_cntr_rld_event, "cntr_rld_event",
+			S_IRUGO | S_IWUSR, debugfs_cntr_rld_event_get,
+			debugfs_cntr_rld_event_set, "%llx\n");
+
+static ssize_t debugfs_cntr_val_get(struct seq_file *f, void *ptr)
+{
+	int i;
+	u32 val;
+	struct etm_drvdata *drvdata = f->private;
+
+	if (!drvdata->enable) {
+		spin_lock(&drvdata->spinlock);
+		for (i = 0; i < drvdata->nr_cntr; i++)
+			seq_printf(f, "counter %d: %x\n",
+				   i, drvdata->cntr_val[i]);
+		spin_unlock(&drvdata->spinlock);
+		return 0;
+	}
+
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		val = etm_readl(drvdata, ETMCNTVRn(i));
+		seq_printf(f, "counter %d: %x\n", i, val);
+	}
+
+	return 0;
+}
+
+static int debugfs_cntr_val_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debugfs_cntr_val_get, inode->i_private);
+}
+
+static ssize_t debugfs_cntr_val_set(struct file *file,
+				    const char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	unsigned int val;
+	char kernel_buf[20];
+	struct seq_file *s = file->private_data;
+	struct etm_drvdata *drvdata = s->private;
+
+	if (copy_from_user(kernel_buf, user_buf, count))
+		return -EINVAL;
+	if (kstrtouint(kernel_buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_val_ops = {
+	.open = debugfs_cntr_val_open,
+	.read = seq_read,
+	.write = debugfs_cntr_val_set,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_val_entry = {
+	.name = "cntr_val",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_val_ops,
+};
+
+static ssize_t debugfs_12_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_12_event;
+	return 0;
+}
+
+static ssize_t debugfs_12_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_12_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_12_event, "seq_12_event",
+			 S_IRUGO | S_IWUSR, debugfs_12_event_get,
+			 debugfs_12_event_set, "%llx\n");
+
+static ssize_t debugfs_21_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_21_event;
+	return 0;
+}
+
+static ssize_t debugfs_21_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_21_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_21_event, "seq_21_event",
+			 S_IRUGO | S_IWUSR, debugfs_21_event_get,
+			 debugfs_21_event_set, "%llx\n");
+
+static ssize_t debugfs_23_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_23_event;
+	return 0;
+}
+
+static ssize_t debugfs_23_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_23_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_23_event, "seq_23_event",
+			 S_IRUGO | S_IWUSR, debugfs_23_event_get,
+			 debugfs_23_event_set, "%llx\n");
+
+static ssize_t debugfs_31_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_31_event;
+	return 0;
+}
+
+static ssize_t debugfs_31_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_31_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_31_event, "seq_31_event",
+			S_IRUGO | S_IWUSR, debugfs_31_event_get,
+			debugfs_31_event_set, "%llx\n");
+
+static ssize_t debugfs_32_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_32_event;
+	return 0;
+}
+
+static ssize_t debugfs_32_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_32_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_32_event, "seq_32_event",
+			S_IRUGO | S_IWUSR, debugfs_32_event_get,
+			debugfs_32_event_set, "%llx\n");
+
+static ssize_t debugfs_13_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->seq_13_event;
+	return 0;
+}
+
+static ssize_t debugfs_13_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->seq_13_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_13_event, "seq_13_event",
+			S_IRUGO | S_IWUSR, debugfs_13_event_get,
+			debugfs_13_event_set, "%llx\n");
+
+static ssize_t debugfs_seq_curr_state_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+	unsigned long flags;
+
+	if (!drvdata->enable) {
+		*val = drvdata->seq_curr_state;
+		return 0;
+	}
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	*val = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return 0;
+}
+
+static ssize_t debugfs_seq_curr_state_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	if (val > ETM_SEQ_STATE_MAX_VAL)
+		return -EINVAL;
+
+	drvdata->seq_curr_state = val;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_seq_curr_state, "seq_curr_state",
+			S_IRUGO | S_IWUSR, debugfs_seq_curr_state_get,
+			debugfs_seq_curr_state_set, "%llx\n");
+
+static ssize_t debugfs_ctxid_idx_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->ctxid_idx;
+	return 0;
+}
+
+static ssize_t debugfs_ctxid_idx_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	if (val >= drvdata->nr_ctxid_cmp)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_ctxid_idx, "ctxid_idx",
+			S_IRUGO | S_IWUSR, debugfs_ctxid_idx_get,
+			debugfs_ctxid_idx_set, "%llx\n");
+
+static ssize_t debugfs_ctxid_val_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	*val = drvdata->ctxid_val[drvdata->ctxid_idx];
+	spin_unlock(&drvdata->spinlock);
+
+	return 0;
+}
+
+static ssize_t debugfs_ctxid_val_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_val[drvdata->ctxid_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_ctxid_val, "ctxid_val",
+			S_IRUGO | S_IWUSR, debugfs_ctxid_val_get,
+			debugfs_ctxid_val_set, "%llx\n");
+
+static ssize_t debugfs_ctxid_mask_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->ctxid_mask;
+	return 0;
+}
+
+static ssize_t debugfs_ctxid_mask_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->ctxid_mask = val;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_ctxid_mask, "ctxid_mask",
+			S_IRUGO | S_IWUSR, debugfs_ctxid_mask_get,
+			debugfs_ctxid_mask_set, "%llx\n");
+
+static ssize_t debugfs_sync_freq_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->sync_freq;
+	return 0;
+}
+
+static ssize_t debugfs_sync_freq_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->sync_freq = val & ETM_SYNC_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_sync_freq, "sync_freq",
+			S_IRUGO | S_IWUSR, debugfs_sync_freq_get,
+			debugfs_sync_freq_set, "%llx\n");
+
+static ssize_t debugfs_timestamp_event_get(void *data, u64 *val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	*val = drvdata->timestamp_event;
+	return 0;
+}
+
+static ssize_t debugfs_timestamp_event_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->timestamp_event = val & ETM_EVENT_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_timestamp_event, "timestamp_event",
+			S_IRUGO | S_IWUSR, debugfs_timestamp_event_get,
+			debugfs_timestamp_event_set, "%llx\n");
+
+static ssize_t debugfs_status_get(struct seq_file *f, void *ptr)
+{
+	unsigned long flags;
+	struct etm_drvdata *drvdata = f->private;
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	CS_UNLOCK(drvdata->base);
+	seq_printf(f,
+		   "ETMCCR: 0x%08x\n"
+		   "ETMCCER: 0x%08x\n"
+		   "ETMSCR: 0x%08x\n"
+		   "ETMIDR: 0x%08x\n"
+		   "ETMCR: 0x%08x\n"
+		   "ETMTRACEIDR: 0x%08x\n"
+		   "Enable event: 0x%08x\n"
+		   "Enable start/stop: 0x%08x\n"
+		   "Enable control: CR1 0x%08x CR2 0x%08x\n"
+		   "CPU affinity: %d\n",
+		   drvdata->etmccr, drvdata->etmccer,
+		   etm_readl(drvdata, ETMSCR), etm_readl(drvdata, ETMIDR),
+		   etm_readl(drvdata, ETMCR), etm_trace_id_simple(drvdata),
+		   etm_readl(drvdata, ETMTEEVR), etm_readl(drvdata, ETMTSSCR),
+		   etm_readl(drvdata, ETMTECR1), etm_readl(drvdata, ETMTECR2),
+		   drvdata->cpu);
+	CS_LOCK(drvdata->base);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return 0;
+}
+static int debugfs_status_show_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debugfs_status_get, inode->i_private);
+}
+
+static const struct file_operations debugfs_status_ops = {
+	.open = debugfs_status_show_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+static const struct coresight_ops_entry debugfs_status_entry = {
+	.name = "status",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_status_ops,
+};
+
+static ssize_t debugfs_traceid_get(void *data, u64 *val)
+{
+	unsigned long flags;
+	struct etm_drvdata *drvdata = data;
+
+	if (!drvdata->enable) {
+		*val = drvdata->traceid;
+		return 0;
+	}
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+	CS_UNLOCK(drvdata->base);
+
+	*val = (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
+
+	CS_LOCK(drvdata->base);
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return 0;
+}
+
+static ssize_t debugfs_traceid_set(void *data, u64 val)
+{
+	struct etm_drvdata *drvdata = data;
+
+	drvdata->traceid = val & ETM_TRACEID_MASK;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_traceid, "traceid",
+			S_IRUGO | S_IWUSR, debugfs_traceid_get,
+			debugfs_traceid_set, "%llx\n");
+
+static const struct coresight_ops_entry *etm_attr_grps[] = {
+	&debugfs_nr_addr_cmp_entry,
+	&debugfs_nr_cntr_entry,
+	&debugfs_nr_ctxid_cmp_entry,
+	&debugfs_etmsr_entry,
+	&debugfs_reset_entry,
+	&debugfs_mode_entry,
+	&debugfs_trigger_event_entry,
+	&debugfs_enable_event_entry,
+	&debugfs_fifofull_level_entry,
+	&debugfs_addr_idx_entry,
+	&debugfs_addr_single_entry,
+	&debugfs_addr_range_entry,
+	&debugfs_addr_start_entry,
+	&debugfs_addr_stop_entry,
+	&debugfs_addr_acctype_entry,
+	&debugfs_cntr_idx_entry,
+	&debugfs_cntr_rld_val_entry,
+	&debugfs_cntr_event_entry,
+	&debugfs_cntr_rld_event_entry,
+	&debugfs_cntr_val_entry,
+	&debugfs_12_event_entry,
+	&debugfs_21_event_entry,
+	&debugfs_23_event_entry,
+	&debugfs_31_event_entry,
+	&debugfs_32_event_entry,
+	&debugfs_13_event_entry,
+	&debugfs_seq_curr_state_entry,
+	&debugfs_ctxid_idx_entry,
+	&debugfs_ctxid_val_entry,
+	&debugfs_ctxid_mask_entry,
+	&debugfs_sync_freq_entry,
+	&debugfs_timestamp_event_entry,
+	&debugfs_status_entry,
+	&debugfs_traceid_entry,
+	NULL,
+};
+
+static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
+			    void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	if (!etmdrvdata[cpu])
+		goto out;
+
+	switch (action & (~CPU_TASKS_FROZEN)) {
+	case CPU_STARTING:
+		spin_lock(&etmdrvdata[cpu]->spinlock);
+		if (!etmdrvdata[cpu]->os_unlock) {
+			etm_os_unlock(etmdrvdata[cpu]);
+			etmdrvdata[cpu]->os_unlock = true;
+		}
+
+		if (etmdrvdata[cpu]->enable)
+			etm_enable_hw(etmdrvdata[cpu]);
+		spin_unlock(&etmdrvdata[cpu]->spinlock);
+		break;
+
+	case CPU_ONLINE:
+		if (etmdrvdata[cpu]->boot_enable &&
+		    !etmdrvdata[cpu]->sticky_enable)
+			coresight_enable(etmdrvdata[cpu]->csdev);
+		break;
+
+	case CPU_DYING:
+		spin_lock(&etmdrvdata[cpu]->spinlock);
+		if (etmdrvdata[cpu]->enable)
+			etm_disable_hw(etmdrvdata[cpu]);
+		spin_unlock(&etmdrvdata[cpu]->spinlock);
+		break;
+	}
+out:
+	return NOTIFY_OK;
+}
+
+static struct notifier_block etm_cpu_notifier = {
+	.notifier_call = etm_cpu_callback,
+};
+
+static bool etm_arch_supported(u8 arch)
+{
+	switch (arch) {
+	case ETM_ARCH_V3_3:
+		break;
+	case ETM_ARCH_V3_5:
+		break;
+	case PFT_ARCH_V1_0:
+		break;
+	case PFT_ARCH_V1_1:
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+
+static void etm_init_arch_data(void *info)
+{
+	u32 etmidr;
+	u32 etmccr;
+	struct etm_drvdata *drvdata = info;
+
+	CS_UNLOCK(drvdata->base);
+
+	/* first dummy read */
+	(void)etm_readl(drvdata, ETMPDSR);
+	/* Provide power to ETM: ETMPDCR[3] == 1 */
+	etm_set_pwrup(drvdata);
+	/*
+	 * Clear power down bit since when this bit is set writes to
+	 * certain registers might be ignored.
+	 */
+	etm_clr_pwrdwn(drvdata);
+	/*
+	 * Set prog bit. It will be set from reset but this is included to
+	 * ensure it is set
+	 */
+	etm_set_prog(drvdata);
+
+	/* Find all capabilities */
+	etmidr = etm_readl(drvdata, ETMIDR);
+	drvdata->arch = BMVAL(etmidr, 4, 11);
+	drvdata->port_size = etm_readl(drvdata, ETMCR) & PORT_SIZE_MASK;
+
+	drvdata->etmccer = etm_readl(drvdata, ETMCCER);
+	etmccr = etm_readl(drvdata, ETMCCR);
+	drvdata->etmccr = etmccr;
+	drvdata->nr_addr_cmp = BMVAL(etmccr, 0, 3) * 2;
+	drvdata->nr_cntr = BMVAL(etmccr, 13, 15);
+	drvdata->nr_ext_inp = BMVAL(etmccr, 17, 19);
+	drvdata->nr_ext_out = BMVAL(etmccr, 20, 22);
+	drvdata->nr_ctxid_cmp = BMVAL(etmccr, 24, 25);
+
+	etm_set_pwrdwn(drvdata);
+	etm_clr_pwrup(drvdata);
+	CS_LOCK(drvdata->base);
+}
+
+static void etm_init_default_data(struct etm_drvdata *drvdata)
+{
+	static int etm3x_traceid;
+
+	u32 flags = (1 << 0 | /* instruction execute*/
+		     3 << 3 | /* ARM instruction */
+		     0 << 5 | /* No data value comparison */
+		     0 << 7 | /* No exact mach */
+		     0 << 8 | /* Ignore context ID */
+		     0 << 10); /* Security ignored */
+
+	/* Initial configuration only - guarantees sources handled by
+	 * this driver have a unique ID at startup time but not between
+	 * all other types of sources.  For that we lean on the core
+	 * framework.
+	 */
+	drvdata->traceid = etm3x_traceid++;
+	drvdata->ctrl = (ETMCR_CYC_ACC | ETMCR_TIMESTAMP_EN);
+	drvdata->enable_ctrl1 = ETMTECR1_ADDR_COMP_1;
+	if (drvdata->nr_addr_cmp >= 2) {
+		drvdata->addr_val[0] = (u32) _stext;
+		drvdata->addr_val[1] = (u32) _etext;
+		drvdata->addr_acctype[0] = flags;
+		drvdata->addr_acctype[1] = flags;
+		drvdata->addr_type[0] = ETM_ADDR_TYPE_RANGE;
+		drvdata->addr_type[1] = ETM_ADDR_TYPE_RANGE;
+	}
+
+	etm_set_default(drvdata);
+}
+
+static int etm_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	int ret;
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct etm_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+
+		adev->dev.platform_data = pdata;
+		drvdata->use_cp14 = of_property_read_bool(np, "arm,cp14");
+	}
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	spin_lock_init(&drvdata->spinlock);
+
+	drvdata->clk = adev->pclk;
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	drvdata->cpu = pdata ? pdata->cpu : 0;
+
+	get_online_cpus();
+	etmdrvdata[drvdata->cpu] = drvdata;
+
+	if (!smp_call_function_single(drvdata->cpu, etm_os_unlock, drvdata, 1))
+		drvdata->os_unlock = true;
+
+	if (smp_call_function_single(drvdata->cpu,
+				     etm_init_arch_data,  drvdata, 1))
+		dev_err(dev, "ETM arch init failed\n");
+
+	if (!etm_count++)
+		register_hotcpu_notifier(&etm_cpu_notifier);
+
+	put_online_cpus();
+
+	if (etm_arch_supported(drvdata->arch) == false) {
+		ret = -EINVAL;
+		goto err_arch_supported;
+	}
+	etm_init_default_data(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	desc->type = CORESIGHT_DEV_TYPE_SOURCE;
+	desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
+	desc->ops = &etm_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->debugfs_ops = etm_attr_grps;
+	desc->owner = THIS_MODULE;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev)) {
+		ret = PTR_ERR(drvdata->csdev);
+		goto err_arch_supported;
+	}
+
+	dev_info(dev, "ETM initialized\n");
+
+	if (boot_enable) {
+		coresight_enable(drvdata->csdev);
+		drvdata->boot_enable = true;
+	}
+
+	return 0;
+
+err_arch_supported:
+	clk_disable_unprepare(drvdata->clk);
+	if (--etm_count == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+	return ret;
+}
+
+static int etm_remove(struct amba_device *adev)
+{
+	struct etm_drvdata *drvdata = amba_get_drvdata(adev);
+
+	coresight_unregister(drvdata->csdev);
+	if (--etm_count == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+
+	return 0;
+}
+
+static struct amba_id etm_ids[] = {
+	{	/* ETM 3.3 */
+		.id	= 0x0003b921,
+		.mask	= 0x0003ffff,
+	},
+	{	/* ETM 3.5 */
+		.id	= 0x0003b956,
+		.mask	= 0x0003ffff,
+	},
+	{	/* PTM 1.0 */
+		.id	= 0x0003b950,
+		.mask	= 0x0003ffff,
+	},
+	{	/* PTM 1.1 */
+		.id	= 0x0003b95f,
+		.mask	= 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver etm_driver = {
+	.drv = {
+		.name	= "coresight-etm3x",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= etm_probe,
+	.remove		= etm_remove,
+	.id_table	= etm_ids,
+};
+
+int __init etm_init(void)
+{
+	return amba_driver_register(&etm_driver);
+}
+module_init(etm_init);
+
+void __exit etm_exit(void)
+{
+	amba_driver_unregister(&etm_driver);
+}
+module_exit(etm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Program Flow Trace driver");
-- 
1.9.1

