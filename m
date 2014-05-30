Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbaE3NoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:44:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59608 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbaE3Nn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:43:59 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: [RFC PATCH 07/11] coresight: add CoreSight ETM driver
Date: Fri, 30 May 2014 07:43:07 -0600
Message-Id: <1401457391-12242-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

This driver manages CoreSight ETM (Embedded Trace Macrocell) that
supports processor tracing. Currently it supports ARM PFT
(Program Flow Trace) v1.1 specification but can be extended to
support other ETM or PFT versions.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/include/asm/hardware/cp14.h   |  540 ++++++++
 drivers/coresight/Kconfig              |   17 +
 drivers/coresight/Makefile             |    3 +-
 drivers/coresight/coresight-etm-cp14.c |  511 +++++++
 drivers/coresight/coresight-etm.c      | 2360 ++++++++++++++++++++++++++++++++
 5 files changed, 3430 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.c

diff --git a/arch/arm/include/asm/hardware/cp14.h b/arch/arm/include/asm/hardware/cp14.h
new file mode 100644
index 0000000..8acf0c7
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
+uint32_t val;								\
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
diff --git a/drivers/coresight/Kconfig b/drivers/coresight/Kconfig
index 224903b..f91f3db 100644
--- a/drivers/coresight/Kconfig
+++ b/drivers/coresight/Kconfig
@@ -17,4 +17,21 @@ config CORESIGHT_LINKS_AND_SINKS
 	  responsible for transporting and collecting the trace data
 	  respectively.
 
+config CORESIGHT_SOURCE_ETM
+	bool "CoreSight Embedded Trace Macrocell driver"
+	select CORESIGHT_LINKS_AND_SINKS
+	help
+	  This driver provides support for processor tracing which allows
+	  tracing the instructions that the processor is executing. This is
+	  primarily useful for instruction level tracing.
+
+config CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
+	bool "Turn on CoreSight ETM tracing by default"
+	depends on CORESIGHT_SOURCE_ETM
+	help
+	  Turns on CoreSight ETM tracing (processor tracing) by default.
+	  Otherwise, tracing is disabled by default but can be enabled via
+	  debugfs.
+
+	  If unsure, say 'N' here to avoid unwanted power consumption.
 endif
diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
index 25296a2..2b4f005 100644
--- a/drivers/coresight/Makefile
+++ b/drivers/coresight/Makefile
@@ -4,4 +4,5 @@
 obj-$(CONFIG_CORESIGHT) += coresight.o
 obj-$(CONFIG_OF) += of_coresight.o
 obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-tmc.o coresight-tpiu.o \
-					   coresight-etb.o coresight-funnel.o \
+					   coresight-etb.o coresight-funnel.o
+obj-$(CONFIG_CORESIGHT_SOURCE_ETM) += coresight-etm.o coresight-etm-cp14.o
diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/coresight/coresight-etm-cp14.c
new file mode 100644
index 0000000..0088bbb
--- /dev/null
+++ b/drivers/coresight/coresight-etm-cp14.c
@@ -0,0 +1,511 @@
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
+static unsigned int etm_read_reg(uint32_t reg)
+{
+	switch (reg) {
+	case 0x0:
+		return etm_read(ETMCR);
+	case 0x1:
+		return etm_read(ETMCCR);
+	case 0x2:
+		return etm_read(ETMTRIGGER);
+	case 0x4:
+		return etm_read(ETMSR);
+	case 0x5:
+		return etm_read(ETMSCR);
+	case 0x6:
+		return etm_read(ETMTSSCR);
+	case 0x8:
+		return etm_read(ETMTEEVR);
+	case 0x9:
+		return etm_read(ETMTECR1);
+	case 0xB:
+		return etm_read(ETMFFLR);
+	case 0x10:
+		return etm_read(ETMACVR0);
+	case 0x11:
+		return etm_read(ETMACVR1);
+	case 0x12:
+		return etm_read(ETMACVR2);
+	case 0x13:
+		return etm_read(ETMACVR3);
+	case 0x14:
+		return etm_read(ETMACVR4);
+	case 0x15:
+		return etm_read(ETMACVR5);
+	case 0x16:
+		return etm_read(ETMACVR6);
+	case 0x17:
+		return etm_read(ETMACVR7);
+	case 0x18:
+		return etm_read(ETMACVR8);
+	case 0x19:
+		return etm_read(ETMACVR9);
+	case 0x1A:
+		return etm_read(ETMACVR10);
+	case 0x1B:
+		return etm_read(ETMACVR11);
+	case 0x1C:
+		return etm_read(ETMACVR12);
+	case 0x1D:
+		return etm_read(ETMACVR13);
+	case 0x1E:
+		return etm_read(ETMACVR14);
+	case 0x1F:
+		return etm_read(ETMACVR15);
+	case 0x20:
+		return etm_read(ETMACTR0);
+	case 0x21:
+		return etm_read(ETMACTR1);
+	case 0x22:
+		return etm_read(ETMACTR2);
+	case 0x23:
+		return etm_read(ETMACTR3);
+	case 0x24:
+		return etm_read(ETMACTR4);
+	case 0x25:
+		return etm_read(ETMACTR5);
+	case 0x26:
+		return etm_read(ETMACTR6);
+	case 0x27:
+		return etm_read(ETMACTR7);
+	case 0x28:
+		return etm_read(ETMACTR8);
+	case 0x29:
+		return etm_read(ETMACTR9);
+	case 0x2A:
+		return etm_read(ETMACTR10);
+	case 0x2B:
+		return etm_read(ETMACTR11);
+	case 0x2C:
+		return etm_read(ETMACTR12);
+	case 0x2D:
+		return etm_read(ETMACTR13);
+	case 0x2E:
+		return etm_read(ETMACTR14);
+	case 0x2F:
+		return etm_read(ETMACTR15);
+	case 0x50:
+		return etm_read(ETMCNTRLDVR0);
+	case 0x51:
+		return etm_read(ETMCNTRLDVR1);
+	case 0x52:
+		return etm_read(ETMCNTRLDVR2);
+	case 0x53:
+		return etm_read(ETMCNTRLDVR3);
+	case 0x54:
+		return etm_read(ETMCNTENR0);
+	case 0x55:
+		return etm_read(ETMCNTENR1);
+	case 0x56:
+		return etm_read(ETMCNTENR2);
+	case 0x57:
+		return etm_read(ETMCNTENR3);
+	case 0x58:
+		return etm_read(ETMCNTRLDEVR0);
+	case 0x59:
+		return etm_read(ETMCNTRLDEVR1);
+	case 0x5A:
+		return etm_read(ETMCNTRLDEVR2);
+	case 0x5B:
+		return etm_read(ETMCNTRLDEVR3);
+	case 0x5C:
+		return etm_read(ETMCNTVR0);
+	case 0x5D:
+		return etm_read(ETMCNTVR1);
+	case 0x5E:
+		return etm_read(ETMCNTVR2);
+	case 0x5F:
+		return etm_read(ETMCNTVR3);
+	case 0x60:
+		return etm_read(ETMSQ12EVR);
+	case 0x61:
+		return etm_read(ETMSQ21EVR);
+	case 0x62:
+		return etm_read(ETMSQ23EVR);
+	case 0x63:
+		return etm_read(ETMSQ31EVR);
+	case 0x64:
+		return etm_read(ETMSQ32EVR);
+	case 0x65:
+		return etm_read(ETMSQ13EVR);
+	case 0x67:
+		return etm_read(ETMSQR);
+	case 0x68:
+		return etm_read(ETMEXTOUTEVR0);
+	case 0x69:
+		return etm_read(ETMEXTOUTEVR1);
+	case 0x6A:
+		return etm_read(ETMEXTOUTEVR2);
+	case 0x6B:
+		return etm_read(ETMEXTOUTEVR3);
+	case 0x6C:
+		return etm_read(ETMCIDCVR0);
+	case 0x6D:
+		return etm_read(ETMCIDCVR1);
+	case 0x6E:
+		return etm_read(ETMCIDCVR2);
+	case 0x6F:
+		return etm_read(ETMCIDCMR);
+	case 0x70:
+		return etm_read(ETMIMPSPEC0);
+	case 0x71:
+		return etm_read(ETMIMPSPEC1);
+	case 0x72:
+		return etm_read(ETMIMPSPEC2);
+	case 0x73:
+		return etm_read(ETMIMPSPEC3);
+	case 0x74:
+		return etm_read(ETMIMPSPEC4);
+	case 0x75:
+		return etm_read(ETMIMPSPEC5);
+	case 0x76:
+		return etm_read(ETMIMPSPEC6);
+	case 0x77:
+		return etm_read(ETMIMPSPEC7);
+	case 0x78:
+		return etm_read(ETMSYNCFR);
+	case 0x79:
+		return etm_read(ETMIDR);
+	case 0x7A:
+		return etm_read(ETMCCER);
+	case 0x7B:
+		return etm_read(ETMEXTINSELR);
+	case 0x7C:
+		return etm_read(ETMTESSEICR);
+	case 0x7D:
+		return etm_read(ETMEIBCR);
+	case 0x7E:
+		return etm_read(ETMTSEVR);
+	case 0x7F:
+		return etm_read(ETMAUXCR);
+	case 0x80:
+		return etm_read(ETMTRACEIDR);
+	case 0x90:
+		return etm_read(ETMVMIDCVR);
+	case 0xC1:
+		return etm_read(ETMOSLSR);
+	case 0xC2:
+		return etm_read(ETMOSSRR);
+	case 0xC4:
+		return etm_read(ETMPDCR);
+	case 0xC5:
+		return etm_read(ETMPDSR);
+	default:
+		WARN(1, "invalid CP14 access to ETM reg: %lx",
+							(unsigned long)reg);
+		return 0;
+	}
+}
+
+static void etm_write_reg(uint32_t val, uint32_t reg)
+{
+	switch (reg) {
+	case 0x0:
+		etm_write(val, ETMCR);
+		return;
+	case 0x2:
+		etm_write(val, ETMTRIGGER);
+		return;
+	case 0x4:
+		etm_write(val, ETMSR);
+		return;
+	case 0x6:
+		etm_write(val, ETMTSSCR);
+		return;
+	case 0x8:
+		etm_write(val, ETMTEEVR);
+		return;
+	case 0x9:
+		etm_write(val, ETMTECR1);
+		return;
+	case 0xB:
+		etm_write(val, ETMFFLR);
+		return;
+	case 0x10:
+		etm_write(val, ETMACVR0);
+		return;
+	case 0x11:
+		etm_write(val, ETMACVR1);
+		return;
+	case 0x12:
+		etm_write(val, ETMACVR2);
+		return;
+	case 0x13:
+		etm_write(val, ETMACVR3);
+		return;
+	case 0x14:
+		etm_write(val, ETMACVR4);
+		return;
+	case 0x15:
+		etm_write(val, ETMACVR5);
+		return;
+	case 0x16:
+		etm_write(val, ETMACVR6);
+		return;
+	case 0x17:
+		etm_write(val, ETMACVR7);
+		return;
+	case 0x18:
+		etm_write(val, ETMACVR8);
+		return;
+	case 0x19:
+		etm_write(val, ETMACVR9);
+		return;
+	case 0x1A:
+		etm_write(val, ETMACVR10);
+		return;
+	case 0x1B:
+		etm_write(val, ETMACVR11);
+		return;
+	case 0x1C:
+		etm_write(val, ETMACVR12);
+		return;
+	case 0x1D:
+		etm_write(val, ETMACVR13);
+		return;
+	case 0x1E:
+		etm_write(val, ETMACVR14);
+		return;
+	case 0x1F:
+		etm_write(val, ETMACVR15);
+		return;
+	case 0x20:
+		etm_write(val, ETMACTR0);
+		return;
+	case 0x21:
+		etm_write(val, ETMACTR1);
+		return;
+	case 0x22:
+		etm_write(val, ETMACTR2);
+		return;
+	case 0x23:
+		etm_write(val, ETMACTR3);
+		return;
+	case 0x24:
+		etm_write(val, ETMACTR4);
+		return;
+	case 0x25:
+		etm_write(val, ETMACTR5);
+		return;
+	case 0x26:
+		etm_write(val, ETMACTR6);
+		return;
+	case 0x27:
+		etm_write(val, ETMACTR7);
+		return;
+	case 0x28:
+		etm_write(val, ETMACTR8);
+		return;
+	case 0x29:
+		etm_write(val, ETMACTR9);
+		return;
+	case 0x2A:
+		etm_write(val, ETMACTR10);
+		return;
+	case 0x2B:
+		etm_write(val, ETMACTR11);
+		return;
+	case 0x2C:
+		etm_write(val, ETMACTR12);
+		return;
+	case 0x2D:
+		etm_write(val, ETMACTR13);
+		return;
+	case 0x2E:
+		etm_write(val, ETMACTR14);
+		return;
+	case 0x2F:
+		etm_write(val, ETMACTR15);
+		return;
+	case 0x50:
+		etm_write(val, ETMCNTRLDVR0);
+		return;
+	case 0x51:
+		etm_write(val, ETMCNTRLDVR1);
+		return;
+	case 0x52:
+		etm_write(val, ETMCNTRLDVR2);
+		return;
+	case 0x53:
+		etm_write(val, ETMCNTRLDVR3);
+		return;
+	case 0x54:
+		etm_write(val, ETMCNTENR0);
+		return;
+	case 0x55:
+		etm_write(val, ETMCNTENR1);
+		return;
+	case 0x56:
+		etm_write(val, ETMCNTENR2);
+		return;
+	case 0x57:
+		etm_write(val, ETMCNTENR3);
+		return;
+	case 0x58:
+		etm_write(val, ETMCNTRLDEVR0);
+		return;
+	case 0x59:
+		etm_write(val, ETMCNTRLDEVR1);
+		return;
+	case 0x5A:
+		etm_write(val, ETMCNTRLDEVR2);
+		return;
+	case 0x5B:
+		etm_write(val, ETMCNTRLDEVR3);
+		return;
+	case 0x5C:
+		etm_write(val, ETMCNTVR0);
+		return;
+	case 0x5D:
+		etm_write(val, ETMCNTVR1);
+		return;
+	case 0x5E:
+		etm_write(val, ETMCNTVR2);
+		return;
+	case 0x5F:
+		etm_write(val, ETMCNTVR3);
+		return;
+	case 0x60:
+		etm_write(val, ETMSQ12EVR);
+		return;
+	case 0x61:
+		etm_write(val, ETMSQ21EVR);
+		return;
+	case 0x62:
+		etm_write(val, ETMSQ23EVR);
+		return;
+	case 0x63:
+		etm_write(val, ETMSQ31EVR);
+		return;
+	case 0x64:
+		etm_write(val, ETMSQ32EVR);
+		return;
+	case 0x65:
+		etm_write(val, ETMSQ13EVR);
+		return;
+	case 0x67:
+		etm_write(val, ETMSQR);
+		return;
+	case 0x68:
+		etm_write(val, ETMEXTOUTEVR0);
+		return;
+	case 0x69:
+		etm_write(val, ETMEXTOUTEVR1);
+		return;
+	case 0x6A:
+		etm_write(val, ETMEXTOUTEVR2);
+		return;
+	case 0x6B:
+		etm_write(val, ETMEXTOUTEVR3);
+		return;
+	case 0x6C:
+		etm_write(val, ETMCIDCVR0);
+		return;
+	case 0x6D:
+		etm_write(val, ETMCIDCVR1);
+		return;
+	case 0x6E:
+		etm_write(val, ETMCIDCVR2);
+		return;
+	case 0x6F:
+		etm_write(val, ETMCIDCMR);
+		return;
+	case 0x70:
+		etm_write(val, ETMIMPSPEC0);
+		return;
+	case 0x71:
+		etm_write(val, ETMIMPSPEC1);
+		return;
+	case 0x72:
+		etm_write(val, ETMIMPSPEC2);
+		return;
+	case 0x73:
+		etm_write(val, ETMIMPSPEC3);
+		return;
+	case 0x74:
+		etm_write(val, ETMIMPSPEC4);
+		return;
+	case 0x75:
+		etm_write(val, ETMIMPSPEC5);
+		return;
+	case 0x76:
+		etm_write(val, ETMIMPSPEC6);
+		return;
+	case 0x77:
+		etm_write(val, ETMIMPSPEC7);
+		return;
+	case 0x78:
+		etm_write(val, ETMSYNCFR);
+		return;
+	case 0x7B:
+		etm_write(val, ETMEXTINSELR);
+		return;
+	case 0x7C:
+		etm_write(val, ETMTESSEICR);
+		return;
+	case 0x7D:
+		etm_write(val, ETMEIBCR);
+		return;
+	case 0x7E:
+		etm_write(val, ETMTSEVR);
+		return;
+	case 0x7F:
+		etm_write(val, ETMAUXCR);
+		return;
+	case 0x80:
+		etm_write(val, ETMTRACEIDR);
+		return;
+	case 0x90:
+		etm_write(val, ETMVMIDCVR);
+		return;
+	case 0xC0:
+		etm_write(val, ETMOSLAR);
+		return;
+	case 0xC2:
+		etm_write(val, ETMOSSRR);
+		return;
+	case 0xC4:
+		etm_write(val, ETMPDCR);
+		return;
+	case 0xC5:
+		etm_write(val, ETMPDSR);
+		return;
+	default:
+		WARN(1, "invalid CP14 access to ETM reg: %lx",
+							(unsigned long)reg);
+		return;
+	}
+}
+
+static inline uint32_t offset_to_reg_num(uint32_t off)
+{
+	return off >> 2;
+}
+
+unsigned int etm_readl_cp14(uint32_t off)
+{
+	uint32_t reg = offset_to_reg_num(off);
+	return etm_read_reg(reg);
+}
+
+void etm_writel_cp14(uint32_t val, uint32_t off)
+{
+	uint32_t reg = offset_to_reg_num(off);
+	etm_write_reg(val, reg);
+}
diff --git a/drivers/coresight/coresight-etm.c b/drivers/coresight/coresight-etm.c
new file mode 100644
index 0000000..59589be
--- /dev/null
+++ b/drivers/coresight/coresight-etm.c
@@ -0,0 +1,2360 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/sysfs.h>
+#include <linux/stat.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/of.h>
+#include <linux/of_coresight.h>
+#include <linux/coresight.h>
+#include <asm/sections.h>
+
+#include "coresight-priv.h"
+
+#define etm_writel_mm(drvdata, val, off)  \
+			__raw_writel((val), drvdata->base + off)
+#define etm_readl_mm(drvdata, off)        \
+			__raw_readl(drvdata->base + off)
+
+#define etm_writel(drvdata, val, off)					\
+({									\
+	if (drvdata->use_cp14)						\
+		etm_writel_cp14(val, off);				\
+	else								\
+		etm_writel_mm(drvdata, val, off);			\
+})
+#define etm_readl(drvdata, off)						\
+({									\
+	uint32_t val;							\
+	if (drvdata->use_cp14)						\
+		val = etm_readl_cp14(off);				\
+	else								\
+		val = etm_readl_mm(drvdata, off);			\
+	val;								\
+})
+
+#define ETM_LOCK(drvdata)						\
+do {									\
+	/* Recommended by spec to ensure ETM writes are committed */	\
+	/* prior to resuming execution */				\
+	mb();								\
+	isb();								\
+	etm_writel_mm(drvdata, 0x0, CORESIGHT_LAR);			\
+} while (0)
+#define ETM_UNLOCK(drvdata)						\
+do {									\
+	etm_writel_mm(drvdata, CORESIGHT_UNLOCK, CORESIGHT_LAR);	\
+	/* Ensure unlock and any pending writes are committed prior */	\
+	/* to programming ETM registers */				\
+	mb();								\
+	isb();								\
+} while (0)
+
+#define PORT_SIZE_MASK		(BM(21, 21) | BM(4, 6))
+
+/*
+ * Device registers:
+ * 0x000 - 0x2FC: Trace		registers
+ * 0x300 - 0x314: Management	registers
+ * 0x318 - 0xEFC: Trace		registers
+ *
+ * Coresight registers
+ * 0xF00 - 0xF9C: Management	registers
+ * 0xFA0 - 0xFA4: Management	registers in PFTv1.0
+ *		  Trace		registers in PFTv1.1
+ * 0xFA8 - 0xFFC: Management	registers
+ */
+
+/* Trace registers (0x000-0x2FC) */
+#define ETMCR			(0x000)
+#define ETMCCR			(0x004)
+#define ETMTRIGGER		(0x008)
+#define ETMSR			(0x010)
+#define ETMSCR			(0x014)
+#define ETMTSSCR		(0x018)
+#define ETMTECR2		(0x01c)
+#define ETMTEEVR		(0x020)
+#define ETMTECR1		(0x024)
+#define ETMFFLR			(0x02C)
+#define ETMACVRn(n)		(0x040 + (n * 4))
+#define ETMACTRn(n)		(0x080 + (n * 4))
+#define ETMCNTRLDVRn(n)		(0x140 + (n * 4))
+#define ETMCNTENRn(n)		(0x150 + (n * 4))
+#define ETMCNTRLDEVRn(n)	(0x160 + (n * 4))
+#define ETMCNTVRn(n)		(0x170 + (n * 4))
+#define ETMSQ12EVR		(0x180)
+#define ETMSQ21EVR		(0x184)
+#define ETMSQ23EVR		(0x188)
+#define ETMSQ31EVR		(0x18C)
+#define ETMSQ32EVR		(0x190)
+#define ETMSQ13EVR		(0x194)
+#define ETMSQR			(0x19C)
+#define ETMEXTOUTEVRn(n)	(0x1A0 + (n * 4))
+#define ETMCIDCVRn(n)		(0x1B0 + (n * 4))
+#define ETMCIDCMR		(0x1BC)
+#define ETMIMPSPEC0		(0x1C0)
+#define ETMIMPSPEC1		(0x1C4)
+#define ETMIMPSPEC2		(0x1C8)
+#define ETMIMPSPEC3		(0x1CC)
+#define ETMIMPSPEC4		(0x1D0)
+#define ETMIMPSPEC5		(0x1D4)
+#define ETMIMPSPEC6		(0x1D8)
+#define ETMIMPSPEC7		(0x1DC)
+#define ETMSYNCFR		(0x1E0)
+#define ETMIDR			(0x1E4)
+#define ETMCCER			(0x1E8)
+#define ETMEXTINSELR		(0x1EC)
+#define ETMTESSEICR		(0x1F0)
+#define ETMEIBCR		(0x1F4)
+#define ETMTSEVR		(0x1F8)
+#define ETMAUXCR		(0x1FC)
+#define ETMTRACEIDR		(0x200)
+#define ETMVMIDCVR		(0x240)
+/* Management registers (0x300-0x314) */
+#define ETMOSLAR		(0x300)
+#define ETMOSLSR		(0x304)
+#define ETMOSSRR		(0x308)
+#define ETMPDCR			(0x310)
+#define ETMPDSR			(0x314)
+
+#define ETM_MAX_ADDR_CMP	(16)
+#define ETM_MAX_CNTR		(4)
+#define ETM_MAX_CTXID_CMP	(3)
+
+#define ETM_MODE_EXCLUDE	BIT(0)
+#define ETM_MODE_CYCACC		BIT(1)
+#define ETM_MODE_STALL		BIT(2)
+#define ETM_MODE_TIMESTAMP	BIT(3)
+#define ETM_MODE_CTXID		BIT(4)
+#define ETM_MODE_ALL		(0x1F)
+
+#define ETM_EVENT_MASK		(0x1FFFF)
+#define ETM_SYNC_MASK		(0xFFF)
+#define ETM_ALL_MASK		(0xFFFFFFFF)
+
+#define ETM_SEQ_STATE_MAX_VAL	(0x2)
+
+enum etm_addr_type {
+	ETM_ADDR_TYPE_NONE,
+	ETM_ADDR_TYPE_SINGLE,
+	ETM_ADDR_TYPE_RANGE,
+	ETM_ADDR_TYPE_START,
+	ETM_ADDR_TYPE_STOP,
+};
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
+struct etm_drvdata {
+	void __iomem			*base;
+	struct device			*dev;
+	struct coresight_device		*csdev;
+	struct clk			*clk;
+	spinlock_t			spinlock;
+	int				cpu;
+	int				port_size;
+	uint8_t				arch;
+	bool				use_cp14;
+	bool				enable;
+	bool				sticky_enable;
+	bool				boot_enable;
+	bool				os_unlock;
+	uint8_t				nr_addr_cmp;
+	uint8_t				nr_cntr;
+	uint8_t				nr_ext_inp;
+	uint8_t				nr_ext_out;
+	uint8_t				nr_ctxid_cmp;
+	uint8_t				reset;
+	uint32_t			mode;
+	uint32_t			ctrl;
+	uint32_t			trigger_event;
+	uint32_t			startstop_ctrl;
+	uint32_t			enable_event;
+	uint32_t			enable_ctrl1;
+	uint32_t			fifofull_level;
+	uint8_t				addr_idx;
+	uint32_t			addr_val[ETM_MAX_ADDR_CMP];
+	uint32_t			addr_acctype[ETM_MAX_ADDR_CMP];
+	uint32_t			addr_type[ETM_MAX_ADDR_CMP];
+	uint8_t				cntr_idx;
+	uint32_t			cntr_rld_val[ETM_MAX_CNTR];
+	uint32_t			cntr_event[ETM_MAX_CNTR];
+	uint32_t			cntr_rld_event[ETM_MAX_CNTR];
+	uint32_t			cntr_val[ETM_MAX_CNTR];
+	uint32_t			seq_12_event;
+	uint32_t			seq_21_event;
+	uint32_t			seq_23_event;
+	uint32_t			seq_31_event;
+	uint32_t			seq_32_event;
+	uint32_t			seq_13_event;
+	uint32_t			seq_curr_state;
+	uint8_t				ctxid_idx;
+	uint32_t			ctxid_val[ETM_MAX_CTXID_CMP];
+	uint32_t			ctxid_mask;
+	uint32_t			sync_freq;
+	uint32_t			timestamp_event;
+};
+
+static struct etm_drvdata *etmdrvdata[NR_CPUS];
+
+/*
+ * Memory mapped writes to clear os lock are not supported on some processors
+ * and OS lock must be unlocked before any memory mapped access on such
+ * processors, otherwise memory mapped reads/writes will be invalid.
+ */
+static void etm_os_unlock(void *info)
+{
+	struct etm_drvdata *drvdata = (struct etm_drvdata *)info;
+	etm_writel(drvdata, 0x0, ETMOSLAR);
+	isb();
+}
+
+static void etm_set_pwrdwn(struct etm_drvdata *drvdata)
+{
+	uint32_t etmcr;
+
+	/* Ensure pending cp14 accesses complete before setting pwrdwn */
+	mb();
+	isb();
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= BIT(0);
+	etm_writel(drvdata, etmcr, ETMCR);
+}
+
+static void etm_clr_pwrdwn(struct etm_drvdata *drvdata)
+{
+	uint32_t etmcr;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~BIT(0);
+	etm_writel(drvdata, etmcr, ETMCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_set_pwrup(struct etm_drvdata *drvdata)
+{
+	uint32_t etmpdcr;
+
+	etmpdcr = etm_readl_mm(drvdata, ETMPDCR);
+	etmpdcr |= BIT(3);
+	etm_writel_mm(drvdata, etmpdcr, ETMPDCR);
+	/* Ensure pwrup completes before subsequent cp14 accesses */
+	mb();
+	isb();
+}
+
+static void etm_clr_pwrup(struct etm_drvdata *drvdata)
+{
+	uint32_t etmpdcr;
+
+	/* Ensure pending cp14 accesses complete before clearing pwrup */
+	mb();
+	isb();
+	etmpdcr = etm_readl_mm(drvdata, ETMPDCR);
+	etmpdcr &= ~BIT(3);
+	etm_writel_mm(drvdata, etmpdcr, ETMPDCR);
+}
+
+static void etm_set_prog(struct etm_drvdata *drvdata)
+{
+	uint32_t etmcr;
+	int count;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr |= BIT(10);
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	for (count = TIMEOUT_US; BVAL(etm_readl(drvdata, ETMSR), 1) != 1
+				&& count > 0; count--)
+		udelay(1);
+	WARN(count == 0, "timeout while setting prog bit, ETMSR: %#x\n",
+	     etm_readl(drvdata, ETMSR));
+}
+
+static void etm_clr_prog(struct etm_drvdata *drvdata)
+{
+	uint32_t etmcr;
+	int count;
+
+	etmcr = etm_readl(drvdata, ETMCR);
+	etmcr &= ~BIT(10);
+	etm_writel(drvdata, etmcr, ETMCR);
+	/*
+	 * Recommended by spec for cp14 accesses to ensure etmcr write is
+	 * complete before polling etmsr
+	 */
+	isb();
+	for (count = TIMEOUT_US; BVAL(etm_readl(drvdata, ETMSR), 1) != 0
+				&& count > 0; count--)
+		udelay(1);
+	WARN(count == 0, "timeout while clearing prog bit, ETMSR: %#x\n",
+	     etm_readl(drvdata, ETMSR));
+}
+
+static void __etm_enable(void *info)
+{
+	int i;
+	uint32_t etmcr;
+	struct etm_drvdata *drvdata = info;
+
+	ETM_UNLOCK(drvdata);
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
+	etmcr &= (BIT(10) | BIT(0));
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
+		etm_writel(drvdata, 0x0000406F, ETMEXTOUTEVRn(i));
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
+	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
+	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
+	etm_writel(drvdata, 0x00000000, ETMEXTINSELR);
+	etm_writel(drvdata, drvdata->timestamp_event, ETMTSEVR);
+	etm_writel(drvdata, 0x00000000, ETMAUXCR);
+	etm_writel(drvdata, drvdata->cpu + 1, ETMTRACEIDR);
+	etm_writel(drvdata, 0x00000000, ETMVMIDCVR);
+
+	/* ensures trace output is enabled from this ETM */
+	etm_writel(drvdata, drvdata->ctrl | BIT(11) | etmcr, ETMCR);
+
+	etm_clr_prog(drvdata);
+	ETM_LOCK(drvdata);
+
+	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
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
+	/*
+	 * Executing __etm_enable on the cpu whose ETM is being enabled
+	 * ensures that register writes occur when cpu is powered.
+	 */
+	ret = smp_call_function_single(drvdata->cpu, __etm_enable, drvdata, 1);
+	if (ret)
+		goto err;
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
+static void __etm_disable(void *info)
+{
+	struct etm_drvdata *drvdata = info;
+
+	ETM_UNLOCK(drvdata);
+	etm_set_prog(drvdata);
+
+	/* Program trace enable to low by using always false event */
+	etm_writel(drvdata, 0x6F | BIT(14), ETMTEEVR);
+
+	etm_set_pwrdwn(drvdata);
+	ETM_LOCK(drvdata);
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
+	 * Executing __etm_disable on the cpu whose ETM is being disabled
+	 * ensures that register writes occur when cpu is powered.
+	 */
+	smp_call_function_single(drvdata->cpu, __etm_disable, drvdata, 1);
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
+	.enable		= etm_enable,
+	.disable	= etm_disable,
+};
+
+static const struct coresight_ops etm_cs_ops = {
+	.source_ops	= &etm_source_ops,
+};
+
+static ssize_t debugfs_show_nr_addr_cmp(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->nr_addr_cmp;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations debugfs_nr_addr_cmp_ops = {
+	.open = simple_open,
+	.read = debugfs_show_nr_addr_cmp,
+};
+
+static const struct coresight_ops_entry debugfs_nr_addr_cmp_entry = {
+	.name = "nr_addr_cmp",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_nr_addr_cmp_ops,
+};
+
+static ssize_t debugfs_show_nr_cntr(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->nr_cntr;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations debugfs_nr_cntr_ops = {
+	.open = simple_open,
+	.read = debugfs_show_nr_cntr,
+};
+
+static const struct coresight_ops_entry debugfs_nr_cntr_entry = {
+	.name = "nr_cntr",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_nr_cntr_ops,
+};
+
+static ssize_t debugfs_show_nr_ctxid_cmp(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->nr_ctxid_cmp;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations debugfs_nr_ctxid_cmp_ops = {
+	.open = simple_open,
+	.read = debugfs_show_nr_ctxid_cmp,
+};
+
+static const struct coresight_ops_entry debugfs_nr_ctxid_cmp_entry = {
+	.name = "nr_ctxid_cmp",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_nr_ctxid_cmp_ops,
+};
+
+static ssize_t debugfs_show_reset(struct file *file,
+				  char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->reset;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+/* Reset to trace everything i.e. exclude nothing. */
+static ssize_t debugfs_store_reset(struct file *file,
+				   const char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	int i;
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	if (val) {
+		drvdata->mode = ETM_MODE_EXCLUDE;
+		drvdata->ctrl = 0x0;
+		drvdata->trigger_event = 0x406F;
+		drvdata->startstop_ctrl = 0x0;
+		drvdata->enable_event = 0x6F;
+		drvdata->enable_ctrl1 = 0x1000000;
+		drvdata->fifofull_level = 0x28;
+		drvdata->addr_idx = 0x0;
+		for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+			drvdata->addr_val[i] = 0x0;
+			drvdata->addr_acctype[i] = 0x0;
+			drvdata->addr_type[i] = ETM_ADDR_TYPE_NONE;
+		}
+		drvdata->cntr_idx = 0x0;
+		for (i = 0; i < drvdata->nr_cntr; i++) {
+			drvdata->cntr_rld_val[i] = 0x0;
+			drvdata->cntr_event[i] = 0x406F;
+			drvdata->cntr_rld_event[i] = 0x406F;
+			drvdata->cntr_val[i] = 0x0;
+		}
+		drvdata->seq_12_event = 0x406F;
+		drvdata->seq_21_event = 0x406F;
+		drvdata->seq_23_event = 0x406F;
+		drvdata->seq_31_event = 0x406F;
+		drvdata->seq_32_event = 0x406F;
+		drvdata->seq_13_event = 0x406F;
+		drvdata->seq_curr_state = 0x0;
+		drvdata->ctxid_idx = 0x0;
+		for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+			drvdata->ctxid_val[i] = 0x0;
+		drvdata->ctxid_mask = 0x0;
+		drvdata->sync_freq = 0x100;
+		drvdata->timestamp_event = 0x406F;
+	}
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_reset_ops = {
+	.open = simple_open,
+	.read = debugfs_show_reset,
+	.write = debugfs_store_reset,
+};
+
+static const struct coresight_ops_entry debugfs_reset_entry = {
+	.name = "reset",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_reset_ops,
+};
+
+static ssize_t debugfs_show_mode(struct file *file,
+				 char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->mode;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_mode(struct file *file,
+				  const char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->mode = val & ETM_MODE_ALL;
+
+	if (drvdata->mode & ETM_MODE_EXCLUDE)
+		drvdata->enable_ctrl1 |= BIT(24);
+	else
+		drvdata->enable_ctrl1 &= ~BIT(24);
+
+	if (drvdata->mode & ETM_MODE_CYCACC)
+		drvdata->ctrl |= BIT(12);
+	else
+		drvdata->ctrl &= ~BIT(12);
+
+	if (drvdata->mode & ETM_MODE_STALL)
+		drvdata->ctrl |= BIT(7);
+	else
+		drvdata->ctrl &= ~BIT(7);
+
+	if (drvdata->mode & ETM_MODE_TIMESTAMP)
+		drvdata->ctrl |= BIT(28);
+	else
+		drvdata->ctrl &= ~BIT(28);
+
+	if (drvdata->mode & ETM_MODE_CTXID)
+		drvdata->ctrl |= (BIT(14) | BIT(15));
+	else
+		drvdata->ctrl &= ~(BIT(14) | BIT(15));
+	spin_unlock(&drvdata->spinlock);
+
+	return count;
+}
+
+static const struct file_operations debugfs_mode_ops = {
+	.open = simple_open,
+	.read = debugfs_show_mode,
+	.write = debugfs_store_mode,
+};
+
+static const struct coresight_ops_entry debugfs_mode_entry = {
+	.name = "mode",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_mode_ops,
+};
+
+static ssize_t debugfs_show_trigger_event(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->trigger_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_trigger_event(struct file *file,
+					   const char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->trigger_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_trigger_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_trigger_event,
+	.write = debugfs_store_trigger_event,
+};
+
+static const struct coresight_ops_entry debugfs_trigger_events_entry = {
+	.name = "trigger_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_trigger_event_ops,
+};
+
+static ssize_t debugfs_show_enable_event(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->enable_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_enable_event(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->enable_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_enable_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_enable_event,
+	.write = debugfs_store_enable_event,
+};
+
+static const struct coresight_ops_entry debugfs_enable_events_entry = {
+	.name = "enable_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_enable_event_ops,
+};
+
+static ssize_t debugfs_show_fifofull_level(struct file *file,
+					   char __user *user_buf,
+					   size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->fifofull_level;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_fifofull_level(struct file *file,
+					    const char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->fifofull_level = val;
+	return count;
+}
+
+static const struct file_operations debugfs_fifofull_level_ops = {
+	.open = simple_open,
+	.read = debugfs_show_fifofull_level,
+	.write = debugfs_store_fifofull_level,
+};
+
+static const struct coresight_ops_entry debugfs_fifofull_level_entry = {
+	.name = "fifofull_level",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_fifofull_level_ops,
+};
+
+static ssize_t debugfs_show_addr_idx(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->addr_idx;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_idx(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
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
+	return count;
+}
+
+static const struct file_operations debugfs_addr_idx_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_idx,
+	.write = debugfs_store_addr_idx,
+};
+
+static const struct coresight_ops_entry debugfs_addr_idx_entry = {
+	.name = "addr_idx",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_idx_ops,
+};
+
+static ssize_t debugfs_show_addr_single(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	int ret;
+	uint8_t idx;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_single(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	uint8_t idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_SINGLE)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_SINGLE;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_addr_single_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_single,
+	.write = debugfs_store_addr_single,
+};
+
+static const struct coresight_ops_entry debugfs_addr_single_entry = {
+	.name = "addr_single",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_single_ops,
+};
+
+static ssize_t debugfs_show_addr_range(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	int ret;
+	uint8_t idx;
+	unsigned long val1, val2;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (idx % 2 != 0) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val1 = drvdata->addr_val[idx];
+	val2 = drvdata->addr_val[idx + 1];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx %#lx\n", val1, val2);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_range(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	uint8_t idx;
+	unsigned long val1, val2;
+	struct etm_drvdata *drvdata = file->private_data;
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
+		return -EPERM;
+	}
+	if (!((drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_NONE) ||
+	      (drvdata->addr_type[idx] == ETM_ADDR_TYPE_RANGE &&
+	       drvdata->addr_type[idx + 1] == ETM_ADDR_TYPE_RANGE))) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val1;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_RANGE;
+	drvdata->addr_val[idx + 1] = val2;
+	drvdata->addr_type[idx + 1] = ETM_ADDR_TYPE_RANGE;
+	drvdata->enable_ctrl1 |= (1 << (idx/2));
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_addr_range_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_range,
+	.write = debugfs_store_addr_range,
+};
+
+static const struct coresight_ops_entry debugfs_addr_range_entry = {
+	.name = "addr_range",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_range_ops,
+};
+
+static ssize_t debugfs_show_addr_start(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	int ret;
+	uint8_t idx;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_start(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	uint8_t idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_START)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_START;
+	drvdata->startstop_ctrl |= (1 << idx);
+	drvdata->enable_ctrl1 |= BIT(25);
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_addr_start_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_start,
+	.write = debugfs_store_addr_start,
+};
+
+static const struct coresight_ops_entry debugfs_addr_start_entry = {
+	.name = "addr_start",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_start_ops,
+};
+
+static ssize_t debugfs_show_addr_stop(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	uint8_t idx;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	val = drvdata->addr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_stop(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	uint8_t idx;
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->addr_idx;
+	if (!(drvdata->addr_type[idx] == ETM_ADDR_TYPE_NONE ||
+	      drvdata->addr_type[idx] == ETM_ADDR_TYPE_STOP)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EPERM;
+	}
+
+	drvdata->addr_val[idx] = val;
+	drvdata->addr_type[idx] = ETM_ADDR_TYPE_STOP;
+	drvdata->startstop_ctrl |= (1 << (idx + 16));
+	drvdata->enable_ctrl1 |= BIT(25);
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_addr_stop_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_stop,
+	.write = debugfs_store_addr_stop,
+};
+
+static const struct coresight_ops_entry debugfs_addr_stop_entry = {
+	.name = "addr_stop",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_stop_ops,
+};
+
+static ssize_t debugfs_show_addr_acctype(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->addr_acctype[drvdata->addr_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_addr_acctype(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->addr_acctype[drvdata->addr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_addr_acctype_ops = {
+	.open = simple_open,
+	.read = debugfs_show_addr_acctype,
+	.write = debugfs_store_addr_acctype,
+};
+
+static const struct coresight_ops_entry debugfs_addr_acctype_entry = {
+	.name = "addr_acctype",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_addr_acctype_ops,
+};
+
+static ssize_t debugfs_show_cntr_idx(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->cntr_idx;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_cntr_idx(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
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
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_idx_ops = {
+	.open = simple_open,
+	.read = debugfs_show_cntr_idx,
+	.write = debugfs_store_cntr_idx,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_idx_entry = {
+	.name = "cntr_idx",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_idx_ops,
+};
+
+static ssize_t debugfs_show_cntr_rld_val(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_rld_val[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_cntr_rld_val(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_rld_val_ops = {
+	.open = simple_open,
+	.read = debugfs_show_cntr_rld_val,
+	.write = debugfs_store_cntr_rld_val,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_rld_val_entry = {
+	.name = "cntr_rld_val",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_rld_val_ops,
+};
+
+static ssize_t debugfs_show_cntr_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_cntr_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_cntr_event,
+	.write = debugfs_store_cntr_event,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_event_entry = {
+	.name = "cntr_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_event_ops,
+};
+
+static ssize_t debugfs_show_cntr_rld_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_rld_event[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_cntr_rld_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_rld_event[drvdata->cntr_idx] = val & ETM_EVENT_MASK;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_rld_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_cntr_rld_event,
+	.write = debugfs_store_cntr_rld_event,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_rld_event_entry = {
+	.name = "cntr_rld_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_rld_event_ops,
+};
+
+static ssize_t debugfs_show_cntr_val(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->cntr_val[drvdata->cntr_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_cntr_val(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_val[drvdata->cntr_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_cntr_val_ops = {
+	.open = simple_open,
+	.read = debugfs_show_cntr_val,
+	.write = debugfs_store_cntr_val,
+};
+
+static const struct coresight_ops_entry debugfs_cntr_val_entry = {
+	.name = "cntr_val",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_cntr_val_ops,
+};
+
+static ssize_t debugfs_show_12_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_12_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_12_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_12_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_12_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_12_event,
+	.write = debugfs_store_12_event,
+};
+
+static const struct coresight_ops_entry debugfs_12_event_entry = {
+	.name = "seq_12_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_12_event_ops,
+};
+
+static ssize_t debugfs_show_21_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_21_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_21_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_21_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_21_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_21_event,
+	.write = debugfs_store_21_event,
+};
+
+static const struct coresight_ops_entry debugfs_21_event_entry = {
+	.name = "seq_21_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_21_event_ops,
+};
+
+static ssize_t debugfs_show_23_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_23_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_23_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_23_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_23_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_23_event,
+	.write = debugfs_store_23_event,
+};
+
+static const struct coresight_ops_entry debugfs_23_event_entry = {
+	.name = "seq_23_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_23_event_ops,
+};
+
+static ssize_t debugfs_show_31_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_31_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_31_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_31_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_31_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_31_event,
+	.write = debugfs_store_31_event,
+};
+
+static const struct coresight_ops_entry debugfs_31_event_entry = {
+	.name = "seq_31_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_31_event_ops,
+};
+
+static ssize_t debugfs_show_32_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_32_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_32_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_32_event = val & ETM_EVENT_MASK;
+	return count;
+}
+static const struct file_operations debugfs_32_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_32_event,
+	.write = debugfs_store_32_event,
+};
+
+static const struct coresight_ops_entry debugfs_32_event_entry = {
+	.name = "seq_32_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_32_event_ops,
+};
+
+static ssize_t debugfs_show_13_event(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_13_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_13_event(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->seq_13_event = val & ETM_EVENT_MASK;
+	return count;
+}
+static const struct file_operations debugfs_13_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_13_event,
+	.write = debugfs_store_13_event,
+};
+
+static const struct coresight_ops_entry debugfs_13_event_entry = {
+	.name = "seq_13_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_13_event_ops,
+};
+
+static ssize_t debugfs_show_seq_curr_state(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->seq_curr_state;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_seq_curr_state(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+	if (val > ETM_SEQ_STATE_MAX_VAL)
+		return -EINVAL;
+
+	drvdata->seq_curr_state = val;
+	return count;
+}
+
+static const struct file_operations debugfs_seq_curr_state_ops = {
+	.open = simple_open,
+	.read = debugfs_show_seq_curr_state,
+	.write = debugfs_store_seq_curr_state,
+};
+
+static const struct coresight_ops_entry debugfs_seq_curr_state_entry = {
+	.name = "seq_curr_state",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_seq_curr_state_ops,
+};
+
+static ssize_t debugfs_show_ctxid_idx(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->ctxid_idx;
+
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_ctxid_idx(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
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
+	return count;
+}
+
+static const struct file_operations debugfs_ctxid_idx_ops = {
+	.open = simple_open,
+	.read = debugfs_show_ctxid_idx,
+	.write = debugfs_store_ctxid_idx,
+};
+
+static const struct coresight_ops_entry debugfs_ctxid_idx_entry = {
+	.name = "ctxid_idx",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_ctxid_idx_ops,
+};
+
+static ssize_t debugfs_show_ctxid_val(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	spin_lock(&drvdata->spinlock);
+	val = drvdata->ctxid_val[drvdata->ctxid_idx];
+	spin_unlock(&drvdata->spinlock);
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_ctxid_val(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_val[drvdata->ctxid_idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return count;
+}
+
+static const struct file_operations debugfs_ctxid_val_ops = {
+	.open = simple_open,
+	.read = debugfs_show_ctxid_val,
+	.write = debugfs_store_ctxid_val,
+};
+
+static const struct coresight_ops_entry debugfs_ctxid_val_entry = {
+	.name = "ctxid_val",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_ctxid_val_ops,
+};
+
+static ssize_t debugfs_show_ctxid_mask(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->ctxid_mask;
+
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_ctxid_mask(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->ctxid_mask = val;
+	return count;
+}
+
+static const struct file_operations debugfs_ctxid_mask_ops = {
+	.open = simple_open,
+	.read = debugfs_show_ctxid_mask,
+	.write = debugfs_store_ctxid_mask,
+};
+
+static const struct coresight_ops_entry debugfs_ctxid_mask_entry = {
+	.name = "ctxid_mask",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_ctxid_mask_ops,
+};
+
+static ssize_t debugfs_show_sync_freq(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->sync_freq;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_sync_freq(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->sync_freq = val & ETM_SYNC_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_sync_freq_ops = {
+	.open = simple_open,
+	.read = debugfs_show_sync_freq,
+	.write = debugfs_store_sync_freq,
+};
+
+static const struct coresight_ops_entry debugfs_sync_freq_entry = {
+	.name = "sync_freq",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_sync_freq_ops,
+};
+
+static ssize_t debugfs_show_timestamp_event(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	val = drvdata->timestamp_event;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_timestamp_event(struct file *file,
+					    const char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->timestamp_event = val & ETM_EVENT_MASK;
+	return count;
+}
+
+static const struct file_operations debugfs_timestamp_event_ops = {
+	.open = simple_open,
+	.read = debugfs_show_timestamp_event,
+	.write = debugfs_store_timestamp_event,
+};
+
+static const struct coresight_ops_entry debugfs_timestamp_event_entry = {
+	.name = "timestamp_event",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_timestamp_event_ops,
+};
+
+static ssize_t debugfs_status_read(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	ssize_t ret;
+	uint32_t val;
+	unsigned long flags;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct etm_drvdata *drvdata = file->private_data;
+
+	if (!buf)
+		return -ENOMEM;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto out;
+
+	spin_lock_irqsave(&drvdata->spinlock, flags);
+
+	ETM_UNLOCK(drvdata);
+	val = etm_readl(drvdata, ETMCCR);
+	ret += sprintf(buf, "ETMCCR: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMCCER);
+	ret += sprintf(buf + ret, "ETMCCER: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMSCR);
+	ret += sprintf(buf + ret, "ETMSCR: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMIDR);
+	ret += sprintf(buf + ret, "ETMIDR: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMCR);
+	ret += sprintf(buf + ret, "ETMCR: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMTEEVR);
+	ret += sprintf(buf + ret, "Enable event: 0x%08x\n", val);
+	val = etm_readl(drvdata, ETMTSSCR);
+	ret += sprintf(buf + ret, "Enable start/stop: 0x%08x\n", val);
+	ret += sprintf(buf + ret,
+		       "Enable control: CR1 0x%08x CR2 0x%08x\n",
+		       etm_readl(drvdata, ETMTECR1),
+		       etm_readl(drvdata, ETMTECR2));
+
+	ETM_LOCK(drvdata);
+
+	spin_unlock_irqrestore(&drvdata->spinlock, flags);
+	clk_disable_unprepare(drvdata->clk);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+out:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations debugfs_status_ops = {
+	.open = simple_open,
+	.read = debugfs_status_read,
+};
+
+static const struct coresight_ops_entry debugfs_status_entry = {
+	.name = "status",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_status_ops,
+};
+
+static const struct coresight_ops_entry *etm_attr_grps[] = {
+	&debugfs_nr_addr_cmp_entry,
+	&debugfs_nr_cntr_entry,
+	&debugfs_nr_ctxid_cmp_entry,
+	&debugfs_reset_entry,
+	&debugfs_mode_entry,
+	&debugfs_trigger_events_entry,
+	&debugfs_enable_events_entry,
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
+			__etm_enable(etmdrvdata[cpu]);
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
+			__etm_disable(etmdrvdata[cpu]);
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
+static bool etm_arch_supported(uint8_t arch)
+{
+	switch (arch) {
+	case ETM_ARCH_V3_3:
+		break;
+	case ETM_ARCH_V3_5:
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
+	uint32_t etmidr;
+	uint32_t etmccr;
+	struct etm_drvdata *drvdata = info;
+
+	ETM_UNLOCK(drvdata);
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
+	etmccr = etm_readl(drvdata, ETMCCR);
+	drvdata->nr_addr_cmp = BMVAL(etmccr, 0, 3) * 2;
+	drvdata->nr_cntr = BMVAL(etmccr, 13, 15);
+	drvdata->nr_ext_inp = BMVAL(etmccr, 17, 19);
+	drvdata->nr_ext_out = BMVAL(etmccr, 20, 22);
+	drvdata->nr_ctxid_cmp = BMVAL(etmccr, 24, 25);
+
+	etm_set_pwrdwn(drvdata);
+	etm_clr_pwrup(drvdata);
+	ETM_LOCK(drvdata);
+}
+
+static void etm_init_default_data(struct etm_drvdata *drvdata)
+{
+	int i;
+
+	uint32_t flags = (1 << 0 | /* instruction execute*/
+			  3 << 3 | /* ARM instruction */
+			  0 << 5 | /* No data value comparison */
+			  0 << 7 | /* No exact mach */
+			  0 << 8 | /* Ignore context ID */
+			  0 << 10); /* Security ignored */
+
+	drvdata->ctrl = (BIT(12) | /* cycle accurate */
+			 BIT(28)); /* timestamp */
+	drvdata->trigger_event = 0x406F;
+	drvdata->enable_event = 0x6F;
+	drvdata->enable_ctrl1 = 0x1;
+	drvdata->fifofull_level	= 0x28;
+	if (drvdata->nr_addr_cmp >= 2) {
+		drvdata->addr_val[0] = (uint32_t) _stext;
+		drvdata->addr_val[1] = (uint32_t) _etext;
+		drvdata->addr_acctype[0] = flags;
+		drvdata->addr_acctype[1] = flags;
+		drvdata->addr_type[0] = ETM_ADDR_TYPE_RANGE;
+		drvdata->addr_type[1] = ETM_ADDR_TYPE_RANGE;
+	}
+	for (i = 0; i < drvdata->nr_cntr; i++) {
+		drvdata->cntr_event[i] = 0x406F;
+		drvdata->cntr_rld_event[i] = 0x406F;
+	}
+	drvdata->seq_12_event = 0x406F;
+	drvdata->seq_21_event = 0x406F;
+	drvdata->seq_23_event = 0x406F;
+	drvdata->seq_31_event = 0x406F;
+	drvdata->seq_32_event = 0x406F;
+	drvdata->seq_13_event = 0x406F;
+	drvdata->sync_freq = 0x100;
+	drvdata->timestamp_event = 0x406F;
+}
+
+static int etm_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct device *dev = &pdev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct etm_drvdata *drvdata;
+	struct resource *res;
+	static int count;
+	struct coresight_desc *desc;
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	if (pdev->dev.of_node) {
+		pdata = of_get_coresight_platform_data(dev, pdev->dev.of_node);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		pdev->dev.platform_data = pdata;
+		drvdata->use_cp14 = of_property_read_bool(pdev->dev.of_node,
+							  "arm,cp14");
+	}
+
+	drvdata->dev = &pdev->dev;
+	platform_set_drvdata(pdev, drvdata);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	drvdata->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!drvdata->base)
+		return -ENOMEM;
+
+	spin_lock_init(&drvdata->spinlock);
+
+	if (pdata && pdata->clk) {
+		drvdata->clk = pdata->clk;
+		ret = clk_prepare_enable(drvdata->clk);
+		if (ret)
+			return ret;
+	}
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
+	if (!count++)
+		register_hotcpu_notifier(&etm_cpu_notifier);
+
+	put_online_cpus();
+
+	if (etm_arch_supported(drvdata->arch) == false) {
+		clk_disable_unprepare(drvdata->clk);
+		return -EINVAL;
+	}
+	etm_init_default_data(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	desc->type = CORESIGHT_DEV_TYPE_SOURCE;
+	desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
+	desc->ops = &etm_cs_ops;
+	desc->pdata = pdev->dev.platform_data;
+	desc->dev = &pdev->dev;
+	desc->debugfs_ops = etm_attr_grps;
+	desc->owner = THIS_MODULE;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev)) {
+		ret = PTR_ERR(drvdata->csdev);
+		goto err;
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
+err:
+	if (drvdata->cpu == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+	return ret;
+}
+
+static int etm_remove(struct platform_device *pdev)
+{
+	struct etm_drvdata *drvdata = platform_get_drvdata(pdev);
+
+	coresight_unregister(drvdata->csdev);
+	if (drvdata->cpu == 0)
+		unregister_hotcpu_notifier(&etm_cpu_notifier);
+	return 0;
+}
+
+static struct of_device_id etm_match[] = {
+	{.compatible = "arm,coresight-etm"},
+	{}
+};
+
+static struct platform_driver etm_driver = {
+	.probe          = etm_probe,
+	.remove         = etm_remove,
+	.driver         = {
+		.name   = "coresight-etm",
+		.owner	= THIS_MODULE,
+		.of_match_table = etm_match,
+	},
+};
+
+int __init etm_init(void)
+{
+	return platform_driver_register(&etm_driver);
+}
+module_init(etm_init);
+
+void __exit etm_exit(void)
+{
+	platform_driver_unregister(&etm_driver);
+}
+module_exit(etm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Program Flow Trace driver");
-- 
1.9.1

