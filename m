Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3FXQuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:50:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27518 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab3FXQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:50:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,929,1363132800"; 
   d="scan'208";a="33083380"
Date: Mon, 24 Jun 2013 17:50:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Chen Gang <gang.chen@asianux.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [Suggestion] arch: arm64: xen: "ln -s" the paravirt.h from
 arm.
In-Reply-To: <alpine.DEB.2.02.1306241639260.4782@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1306241747360.4782@kaball.uk.xensource.com>
References: <51C53C06.7050205@asianux.com> <51C81115.4070803@asianux.com> <51C81A39.5060909@asianux.com> <alpine.DEB.2.02.1306241639260.4782@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Stefano Stabellini wrote:
> On Mon, 24 Jun 2013, Chen Gang wrote:
> > Hello Maintainers:
> > 
> > if 'CONFIG_XEN'
> > 
> >   CC      arch/arm64/xen/../../arm/xen/enlighten.o
> > arch/arm64/xen/../../arm/xen/enlighten.c:19:26: fatal error: asm/paravirt.h: No such file or directory
> > 
> > The related .config file for next-20130624 is in attachment.
> > 
> > 
> > If "ln -s ../../../arm/include/asm/paravirt.h paravirt.h", it can pass
> > compiling, but I do not know how to make a patch for it ("ln -s ..."),
> > Do we have another more suitable ways for it (or another fixing ways) ?
> > 
> > Welcome any suggestions or completions.
> 
> The problem is caused by:
> 
> commit 3a885582a366caf868b0782041c44854ff4c3568
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Wed May 29 10:56:34 2013 +0000
> 
>     xen/arm: account for stolen ticks
> 
> that is in my tree for linux-next (even though I have not received any
> replies from the ARM maintainers so I don't know when and if it is going
> to go upstream).
> 
> I think that the best thing to do would be to add a couple of ifdef
> CONFIG_PARAVIRT in arch/arm/xen/enlighten.c. I'll add them to my tree.

Actually now that we have XEN support under arm64, we can just introduce the
same pv_time_op struct and paravirt header that this patch

http://marc.info/?l=linux-arm-kernel&m=136992435301890&w=2

is introducing under arm.
Any opinions?

---

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 19c1cde..47bd26b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -207,6 +207,25 @@ config FORCE_MAX_ZONEORDER
 	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
 	default "11"
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	---help---
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	select PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
@@ -214,6 +233,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
 	depends on ARM64 && OF
+	select PARAVIRT
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
 
diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
new file mode 100644
index 0000000..54e895b
--- /dev/null
+++ b/arch/arm64/include/asm/paravirt.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_ARM64_PARAVIRT_H
+#define _ASM_ARM64_PARAVIRT_H
+
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
+
+struct pv_time_ops {
+	unsigned long long (*steal_clock)(int cpu);
+};
+extern struct pv_time_ops pv_time_ops;
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return pv_time_ops.steal_clock(cpu);
+}
+
+
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7b4b564..17613ad 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
new file mode 100644
index 0000000..53f371e
--- /dev/null
+++ b/arch/arm64/kernel/paravirt.c
@@ -0,0 +1,25 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2013 Citrix Systems
+ *
+ * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+ */
+
+#include <linux/export.h>
+#include <linux/jump_label.h>
+#include <linux/types.h>
+#include <asm/paravirt.h>
+
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
+
+struct pv_time_ops pv_time_ops;
+EXPORT_SYMBOL_GPL(pv_time_ops);
