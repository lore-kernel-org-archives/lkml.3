Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaHTUmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:42:50 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54090 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaHTUmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:47 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 7/9] ARM: zynq: Synchronise zynq_cpu_die/kill
Date: Wed, 20 Aug 2014 13:41:53 -0700
Message-Id: <1408567315-28479-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid races and add synchronisation between the arch specific
kill and die routines.

The same synchronisation issue was fixed on IMX platform
by this commit:
"ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill"
(sha1: 2f3edfd7e27ad4206acbc2ae99c9df5f46353024)

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/common.h  |  2 ++
 arch/arm/mach-zynq/hotplug.c |  2 ++
 arch/arm/mach-zynq/platsmp.c |  6 ++++++
 arch/arm/mach-zynq/slcr.c    | 43 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 87945fa2a179..c0773e87e83c 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -24,6 +24,8 @@ extern int zynq_early_slcr_init(void);
 extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
 extern void zynq_slcr_cpu_start(int cpu);
+extern bool zynq_slcr_cpu_state_read(int cpu);
+extern void zynq_slcr_cpu_state_write(int cpu, bool die);
 extern u32 zynq_slcr_get_device_id(void);
 
 #ifdef CONFIG_SMP
diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
index 366f46c91365..fe44a05677e2 100644
--- a/arch/arm/mach-zynq/hotplug.c
+++ b/arch/arm/mach-zynq/hotplug.c
@@ -19,6 +19,8 @@
  */
 void zynq_platform_cpu_die(unsigned int cpu)
 {
+	zynq_slcr_cpu_state_write(cpu, true);
+
 	/*
 	 * there is no power-control hardware on this platform, so all
 	 * we can do is put the core into WFI; this is safe as the calling
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 616b99e07c60..f77f7ca4c45b 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -123,6 +123,12 @@ static void zynq_secondary_init(unsigned int cpu)
 #ifdef CONFIG_HOTPLUG_CPU
 static int zynq_cpu_kill(unsigned cpu)
 {
+	unsigned long timeout = jiffies + msecs_to_jiffies(50);
+
+	while (zynq_slcr_cpu_state_read(cpu))
+		if (time_after(jiffies, timeout))
+			return 0;
+
 	zynq_slcr_cpu_stop(cpu);
 	return 1;
 }
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index c43a2d16e223..d4cb50cf97c0 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -138,6 +138,8 @@ void zynq_slcr_cpu_start(int cpu)
 	zynq_slcr_write(reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 	reg &= ~(SLCR_A9_CPU_CLKSTOP << cpu);
 	zynq_slcr_write(reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
+
+	zynq_slcr_cpu_state_write(cpu, false);
 }
 
 /**
@@ -154,8 +156,47 @@ void zynq_slcr_cpu_stop(int cpu)
 }
 
 /**
- * zynq_slcr_init - Regular slcr driver init
+ * zynq_slcr_cpu_state - Read/write cpu state
+ * @cpu:	cpu number
  *
+ * SLCR_REBOOT_STATUS save upper 2 bits (31/30 cpu states for cpu0 and cpu1)
+ * 0 means cpu is running, 1 cpu is going to die.
+ *
+ * Return: true if cpu is running, false if cpu is going to die
+ */
+bool zynq_slcr_cpu_state_read(int cpu)
+{
+	u32 state;
+
+	state = readl(zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
+	state &= 1 << (31 - cpu);
+
+	return !state;
+}
+
+/**
+ * zynq_slcr_cpu_state - Read/write cpu state
+ * @cpu:	cpu number
+ * @die:	cpu state - true if cpu is going to die
+ *
+ * SLCR_REBOOT_STATUS save upper 2 bits (31/30 cpu states for cpu0 and cpu1)
+ * 0 means cpu is running, 1 cpu is going to die.
+ */
+void zynq_slcr_cpu_state_write(int cpu, bool die)
+{
+	u32 state, mask;
+
+	state = readl(zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
+	mask = 1 << (31 - cpu);
+	if (die)
+		state |= mask;
+	else
+		state &= ~mask;
+	writel(state, zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
+}
+
+/**
+ * zynq_slcr_init - Regular slcr driver init
  * Return:	0 on success, negative errno otherwise.
  *
  * Called early during boot from platform code to remap SLCR area.
-- 
2.0.1.1.gfbfc394

