Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3LCQl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:41:56 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59528 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3LCQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:41:51 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [RFC part3 PATCH 0/2] Using ACPI GTDT table to initialize arch timer
Date: Wed,  4 Dec 2013 00:41:29 +0800
Message-Id: <1386088891-2917-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last part of patch set for core of ARM64 ACPI, and is based
on the patch set part2 "Using ACPI MADT table to initialise SMP and GIC".

ACPI GTDT (Generic Timer Description Table) is used for ARM/ARM64 only,
and contains the information for arch timer initialisation.

This patch trys to convert the arch timer to ACPI using GTDT. 

After this patch set was posted, we already finished the SMP, GIC and
arch timer initialisation, which all are essential for ARM64 core system
running, then we will focus on converting the device drivers to ACPI.

Here is the GTDT ASL code I used:
---
 platforms/foundation-v8.acpi/gtdt.asl |   35 ++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/platforms/foundation-v8.acpi/gtdt.asl b/platforms/foundation-v8.acpi/gtdt.asl
index 18c821a..714d61c 100644
--- a/platforms/foundation-v8.acpi/gtdt.asl
+++ b/platforms/foundation-v8.acpi/gtdt.asl
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2013, Al Stone <al.stone@linaro.org>
+ *                     Hanjun Guo <hanjun.guo@linaro.org>
  * 
  * [GTDT] Generic Timer Description Table
  * Format: [ByteLength]  FieldName : HexFieldValue
@@ -21,22 +22,32 @@
 [0004]              Flags (decoded below) : 00000001
                            Memory Present : 1
 
-[0004]               Secure PL1 Interrupt : 00000000
-[0004]         SPL1 Flags (decoded below) : 00000000
-                             Trigger Mode : 0
+/* In Foundation model's dts file, the last cell of interrupts
+ * is 0xff01, it means its cpu mask is FF, and trigger type
+ * and flag is 1 = low-to-high edge triggered.
+ * 
+ * so in ACPI the Trigger Mode is 1 - Edge triggered, and 
+ * Polarity is 0 - Active high as ACPI spec describled.
+ *
+ * using direct mapping for hwirqs, it means that we using
+ * ID [16, 31] for PPI, not [0, 15] used in FDT.
+ */
+[0004]               Secure PL1 Interrupt : 0000001d
+[0004]         SPL1 Flags (decoded below) : 00000001
+                             Trigger Mode : 1
                                  Polarity : 0
 
-[0004]           Non-Secure PL1 Interrupt : 00000000
-[0004]        NSPL1 Flags (decoded below) : 00000000
-                             Trigger Mode : 0
+[0004]           Non-Secure PL1 Interrupt : 0000001e
+[0004]        NSPL1 Flags (decoded below) : 00000001
+                             Trigger Mode : 1
                                  Polarity : 0
 
-[0004]            Virtual Timer Interrupt : 00000000
-[0004]           VT Flags (decoded below) : 00000000
-                             Trigger Mode : 0
+[0004]            Virtual Timer Interrupt : 0000001b
+[0004]           VT Flags (decoded below) : 00000001
+                             Trigger Mode : 1
                                  Polarity : 0
 
-[0004]           Non-Secure PL2 Interrupt : 00000000
-[0004]        NSPL2 Flags (decoded below) : 00000000
-                             Trigger Mode : 0
+[0004]           Non-Secure PL2 Interrupt : 0000001a
+[0004]        NSPL2 Flags (decoded below) : 00000001
+                             Trigger Mode : 1
                                  Polarity : 0

Hanjun Guo (2):
  clocksource / arch_timer: Use ACPI GTDT table to initialize arch
    timer
  ARM64 / clocksource: Use arch_timer_acpi_init()

 arch/arm64/kernel/time.c             |    4 ++
 drivers/clocksource/arm_arch_timer.c |  129 ++++++++++++++++++++++++++++++----
 include/clocksource/arm_arch_timer.h |    7 +-
 3 files changed, 124 insertions(+), 16 deletions(-)

-- 
1.7.9.5

