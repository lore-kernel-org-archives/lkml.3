Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3IFLFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:05:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33481 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab3IFLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:05:17 -0400
Date: Fri, 6 Sep 2013 12:04:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130906110423.GE30450@mudshark.cambridge.arm.com>
References: <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com>
 <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
 <20130904182113.GD5599@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1309041324530.26497@gentwo.org>
 <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
 <20130905130359.GA22351@mudshark.cambridge.arm.com>
 <00000140ee828138-3328099b-149e-433d-8262-0a481806ca85-000000@email.amazonses.com>
 <20130905172810.GB29219@mudshark.cambridge.arm.com>
 <00000140ef40d3fc-55c44dfd-7403-43f4-b1fb-d116c55be5a6-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ef40d3fc-55c44dfd-7403-43f4-b1fb-d116c55be5a6-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:52:19PM +0100, Christoph Lameter wrote:
> On Thu, 5 Sep 2013, Will Deacon wrote:
> 
> > > Ok can you take it from here and modify it? I have no build and test
> > > environment set up for ARM.
> >
> > Sure. Does that include the original arm/arm64 patches from your v3 series
> > as well as these two fixups?
> 
> I think so. Take whatever you can and I will make another pass after the
> merge and pick up anything that was missed.

Ok, I had a crack at putting something together on top of HEAD, but I still
see some errors due to pcpu array types (even with your patch in mainline).
I think some of your conversions to __this_cpu_read should use this_cpu_ptr
instead, but could you have a quick look at my fixup below please?

Will

--->8

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index e7e6eca..3d44660 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -344,13 +344,13 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 		/* Breakpoint */
 		ctrl_base = ARM_BASE_BCR;
 		val_base = ARM_BASE_BVR;
-		slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
+		slots = this_cpu_ptr(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		ctrl_base = ARM_BASE_WCR;
 		val_base = ARM_BASE_WVR;
-		slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
+		slots = this_cpu_ptr(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -396,12 +396,12 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
 		/* Breakpoint */
 		base = ARM_BASE_BCR;
-		slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
+		slots = this_cpu_ptr(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		base = ARM_BASE_WCR;
-		slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
+		slots = this_cpu_ptr(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -697,7 +697,7 @@ static void watchpoint_handler(unsigned long addr, unsigned int fsr,
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
+	slots = this_cpu_ptr(wp_on_reg);
 
 	for (i = 0; i < core_num_wrps; ++i) {
 		rcu_read_lock();
@@ -768,7 +768,7 @@ static void watchpoint_single_step_handler(unsigned long pc)
 	struct perf_event *wp, **slots;
 	struct arch_hw_breakpoint *info;
 
-	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
+	slots = this_cpu_ptr(wp_on_reg);
 
 	for (i = 0; i < core_num_wrps; ++i) {
 		rcu_read_lock();
@@ -802,7 +802,7 @@ static void breakpoint_handler(unsigned long unknown, struct pt_regs *regs)
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
+	slots = this_cpu_ptr(bp_on_reg);
 
 	/* The exception entry code places the amended lr in the PC. */
 	addr = regs->ARM_pc;
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 53dc018..ff516f6 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -184,14 +184,14 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 		/* Breakpoint */
 		ctrl_reg = AARCH64_DBG_REG_BCR;
 		val_reg = AARCH64_DBG_REG_BVR;
-		slots = __this_cpu_read(bp_on_reg);
+		slots = this_cpu_ptr(bp_on_reg);
 		max_slots = core_num_brps;
 		reg_enable = !debug_info->bps_disabled;
 	} else {
 		/* Watchpoint */
 		ctrl_reg = AARCH64_DBG_REG_WCR;
 		val_reg = AARCH64_DBG_REG_WVR;
-		slots = __this_cpu_read(wp_on_reg);
+		slots = this_cpu_ptr(wp_on_reg);
 		max_slots = core_num_wrps;
 		reg_enable = !debug_info->wps_disabled;
 	}
@@ -230,12 +230,12 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
 		/* Breakpoint */
 		base = AARCH64_DBG_REG_BCR;
-		slots = __this_cpu_read(bp_on_reg);
+		slots = this_cpu_ptr(bp_on_reg);
 		max_slots = core_num_brps;
 	} else {
 		/* Watchpoint */
 		base = AARCH64_DBG_REG_WCR;
-		slots = __this_cpu_read(wp_on_reg);
+		slots = this_cpu_ptr(wp_on_reg);
 		max_slots = core_num_wrps;
 	}
 
@@ -505,11 +505,11 @@ static void toggle_bp_registers(int reg, enum debug_el el, int enable)
 
 	switch (reg) {
 	case AARCH64_DBG_REG_BCR:
-		slots = __this_cpu_read(bp_on_reg);
+		slots = this_cpu_ptr(bp_on_reg);
 		max_slots = core_num_brps;
 		break;
 	case AARCH64_DBG_REG_WCR:
-		slots = __this_cpu_read(wp_on_reg);
+		slots = this_cpu_ptr(wp_on_reg);
 		max_slots = core_num_wrps;
 		break;
 	default:
@@ -546,7 +546,7 @@ static int breakpoint_handler(unsigned long unused, unsigned int esr,
 	struct debug_info *debug_info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__this_cpu_read(bp_on_reg);
+	slots = this_cpu_ptr(bp_on_reg);
 	addr = instruction_pointer(regs);
 	debug_info = &current->thread.debug;
 
@@ -623,7 +623,7 @@ static int watchpoint_handler(unsigned long addr, unsigned int esr,
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
-	slots = (struct perf_event **)__this_cpu_read(wp_on_reg);
+	slots = this_cpu_ptr(wp_on_reg);
 	debug_info = &current->thread.debug;
 
 	for (i = 0; i < core_num_wrps; ++i) {
