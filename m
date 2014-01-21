Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaAUD1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 22:27:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaAUD1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 22:27:31 -0500
Message-ID: <1390274800.5429.14.camel@marge.simpson.net>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 04:26:40 +0100
In-Reply-To: <20140120215151.GN31570@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
	 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	 <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com>
	 <20140120082620.GB30183@twins.programming.kicks-ass.net>
	 <52DCE4CF.2060605@zytor.com>
	 <20140120091600.GW31570@twins.programming.kicks-ass.net>
	 <52DCEAF4.3040902@zytor.com> <20140120092931.GA3836@gmail.com>
	 <CAJvTdKmF0Bzo+=VRD=3dZKVZAxAQ=am33fFGR7XH4hYd2=9Mww@mail.gmail.com>
	 <20140120215151.GN31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/9bcH5EEDCDCX9N+czw0DGB/8MU8+zm+22PmG/yQMeI
 Cq8apL1HtWvV0LF0tsMYIS8ba3DW8N1a9/VKi4AfLD77HoiIAF
 3Q8uG6/4rqLfI1a/D4x950CgKl9DaXEvHoWrtSqa0cJ/bbgwd7
 6BFrT0IvHTaPojo2AYwrVrlt5S2sXu3OGFRKy07SBHKj/RSgI4
 FCCHwPLuIXlzpkhUd3A3o/3cBd9z0iXOxwCTpOFpmOUqOzLdfz
 R9f/YlmBzJR3d3dY2PI/UV7cWJXZc8iL7nmRo18BP6zRy+uLCO
 wTezo+T1vRrmlth+knvcopNcrTofsXM14CQYjiJnsSwRfeMr4T
 MKIBN/AuDOA8zAgHTaZfd2FO6rfe9LpTSsluOjdokhhIB8+cm4
 NCnVi/YjY9FGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 22:51 +0100, Peter Zijlstra wrote:

> I'm still waiting for someone to explain what's wrong with:
> 
> static inline void mwait_idle(void)
> {
> 	local_irq_enable();
> 	mwait_idle_with_hints(0, 0);
> }

How about just do that going forward, it work, and can always be fixed
if something turns up, and the below for stable once it hits mainline?

Q6600 box is happy camper in all trees.

From: Len Brown <len.brown@intel.com>

x86 idle: restore mwait_idle()

In Linux-3.9 we removed the mwait_idle() loop:
'x86 idle: remove mwait_idle() and "idle=mwait" cmdline param'
(69fb3676df3329a7142803bb3502fa59dc0db2e3)

The reasoning was that modern machines should be sufficiently
happy during the boot process using the default_idle() HALT loop,
until cpuidle loads and either acpi_idle or intel_idle
invoke the newer MWAIT-with-hints idle loop.

But two machines reported problems:
1. Certain Core2-era machines support MWAIT-C1 and HALT only.
   MWAIT-C1 is preferred for optimal power and performance.
   But if they support just C1, cpuidle never loads and
   so they use the boot-time default idle loop forever.

2. Some laptops will boot-hang if HALT is used,
   but will boot successfully if MWAIT is used.
   This appears to be a hidden assumption in BIOS SMI,
   that is presumably valid on the proprietary OS
   where the BIOS was validated.

   https://bugzilla.kernel.org/show_bug.cgi?id=60770

So here we effectively revert the patch above, restoring
the mwait_idle() loop.  However, we don't bother restoring
the idle=mwait cmdline parameter, since it appears to add
no value.

Maintainer notes:
For 3.9, simply revert 69fb3676df
for 3.10, patch -F3 applies, fuzz needed due to __cpuinit use in context
For 3.11, 3.12, 3.13, this patch applies cleanly

Mike: reinstate polling, and add clflush barriers.

Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ian Malone <ibmalone@gmail.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@vger.kernel.org> # 3.9, 3.10, 3.11, 3.12, 3.13
Signed-off-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95ab8b5..c5db2a43e730 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -398,6 +398,52 @@ static void amd_e400_idle(void)
 		default_idle();
 }
 
+/*
+ * Intel Core2 and older machines prefer MWAIT over HALT for C1.
+ * We can't rely on cpuidle installing MWAIT, because it will not load
+ * on systems that support only C1 -- so the boot default must be MWAIT.
+ *
+ * Some AMD machines are the opposite, they depend on using HALT.
+ *
+ * So for default C1, which is used during boot until cpuidle loads,
+ * use MWAIT-C1 on Intel HW that has it, else use HALT.
+ */
+static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
+{
+	if (c->x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+
+	if (!cpu_has(c, X86_FEATURE_MWAIT))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * MONITOR/MWAIT with no hints, used for default default C1 state.
+ * This invokes MWAIT with interrutps enabled and no flags,
+ * which is backwards compatible with the original MWAIT implementation.
+ */
+
+static void mwait_idle(void)
+{
+	if (!current_set_polling_and_test()) {
+		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+			mb();
+			clflush((void *)&current_thread_info()->flags);
+			mb();
+		}
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		if (!need_resched())
+			__sti_mwait(0, 0);
+		else
+			local_irq_enable();
+	} else
+		local_irq_enable();
+	__current_clr_polling();
+}
+
 void select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -411,6 +457,9 @@ void select_idle_routine(const struct cpuinfo_x86 *c)
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		x86_idle = amd_e400_idle;
+	} else if (prefer_mwait_c1_over_halt(c)) {
+		pr_info("using mwait in idle threads\n");
+		x86_idle = mwait_idle;
 	} else
 		x86_idle = default_idle;
 }
 

