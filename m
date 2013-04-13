Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3DMA2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:28:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62393 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3DMA1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:27:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,466,1363158000"; 
   d="scan'208";a="38050155"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCHv2 3/4] clocksource: arch_timer: Push the read/write wrappers deeper
Date: Fri, 12 Apr 2013 17:27:42 -0700
Message-Id: <1365812863-5367-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org>
References: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to introduce support to read and write the memory
mapped timer registers in the next patch, so push the cp15
read/write functions one level deeper. This simplifies the next
patch and makes it clearer what's going on.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/arch_timer.h    |  5 ++--
 arch/arm64/include/asm/arch_timer.h  |  4 ++--
 drivers/clocksource/arm_arch_timer.c | 44 ++++++++++++++++++++++++------------
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 35fea17..23d65f5 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -18,7 +18,8 @@ int arch_timer_sched_clock_init(void);
  * nicely work out which register we want, and chuck away the rest of
  * the code. At least it does so with a recent GCC (4.6.3).
  */
-static inline void arch_timer_reg_write(const int access, const int reg, u32 val)
+static inline void arch_timer_reg_write_cp15(const int access, const int reg,
+					  u32 val)
 {
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
 		switch (reg) {
@@ -45,7 +46,7 @@ static inline void arch_timer_reg_write(const int access, const int reg, u32 val
 	isb();
 }
 
-static inline u32 arch_timer_reg_read(const int access, const int reg)
+static inline u32 arch_timer_reg_read_cp15(const int access, const int reg)
 {
 	u32 val = 0;
 
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 5307737..95db1a9 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -26,7 +26,7 @@
 
 #include <clocksource/arm_arch_timer.h>
 
-static inline void arch_timer_reg_write(int access, int reg, u32 val)
+static inline void arch_timer_reg_write_cp15(int access, int reg, u32 val)
 {
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
 		switch (reg) {
@@ -57,7 +57,7 @@ static inline void arch_timer_reg_write(int access, int reg, u32 val)
 	isb();
 }
 
-static inline u32 arch_timer_reg_read(int access, int reg)
+static inline u32 arch_timer_reg_read_cp15(int access, int reg)
 {
 	u32 val;
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 545891b..4f1f002 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -43,14 +43,26 @@ static bool arch_timer_use_virtual = true;
  * Architected system timer support.
  */
 
+static inline void arch_timer_reg_write(int access, int reg, u32 val,
+					struct clock_event_device *clk)
+{
+	arch_timer_reg_write_cp15(access, reg, val);
+}
+
+static inline u32 arch_timer_reg_read(int access, int reg,
+				      struct clock_event_device *clk)
+{
+	return arch_timer_reg_read_cp15(access, reg);
+}
+
 static inline irqreturn_t timer_handler(const int access,
 					struct clock_event_device *evt)
 {
 	unsigned long ctrl;
-	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, evt);
 	if (ctrl & ARCH_TIMER_CTRL_IT_STAT) {
 		ctrl |= ARCH_TIMER_CTRL_IT_MASK;
-		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, evt);
 		evt->event_handler(evt);
 		return IRQ_HANDLED;
 	}
@@ -72,15 +84,16 @@ static irqreturn_t arch_timer_handler_phys(int irq, void *dev_id)
 	return timer_handler(ARCH_TIMER_PHYS_ACCESS, evt);
 }
 
-static inline void timer_set_mode(const int access, int mode)
+static inline void timer_set_mode(const int access, int mode,
+				  struct clock_event_device *clk)
 {
 	unsigned long ctrl;
 	switch (mode) {
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+		ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 		ctrl &= ~ARCH_TIMER_CTRL_ENABLE;
-		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 		break;
 	default:
 		break;
@@ -90,36 +103,37 @@ static inline void timer_set_mode(const int access, int mode)
 static void arch_timer_set_mode_virt(enum clock_event_mode mode,
 				     struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode);
+	timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode, clk);
 }
 
 static void arch_timer_set_mode_phys(enum clock_event_mode mode,
 				     struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode);
+	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode, clk);
 }
 
-static inline void set_next_event(const int access, unsigned long evt)
+static inline void set_next_event(const int access, unsigned long evt,
+				  struct clock_event_device *clk)
 {
 	unsigned long ctrl;
-	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
+	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
 	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
-	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt);
-	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt, clk);
+	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 }
 
 static int arch_timer_set_next_event_virt(unsigned long evt,
-					  struct clock_event_device *unused)
+					  struct clock_event_device *clk)
 {
-	set_next_event(ARCH_TIMER_VIRT_ACCESS, evt);
+	set_next_event(ARCH_TIMER_VIRT_ACCESS, evt, clk);
 	return 0;
 }
 
 static int arch_timer_set_next_event_phys(unsigned long evt,
-					  struct clock_event_device *unused)
+					  struct clock_event_device *clk)
 {
-	set_next_event(ARCH_TIMER_PHYS_ACCESS, evt);
+	set_next_event(ARCH_TIMER_PHYS_ACCESS, evt, clk);
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

