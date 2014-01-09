Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaAISd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:33:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34839 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbaAISdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:33:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,632,1384300800"; 
   d="scan'208";a="89253908"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 5/5] xen/arm: account for stolen ticks
Date: Thu, 9 Jan 2014 18:32:16 +0000
Message-ID: <1389292336-9292-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the runstate_memory_area with the hypervisor.
Use pv_time_ops.steal_clock to account for stolen ticks.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


---

Changes in v4:
- don't use paravirt_steal_rq_enabled: we do not support retrieving
stolen ticks for vcpus other than one we are running on.

Changes in v3:
- use BUG_ON and smp_processor_id.
---
 arch/arm/xen/enlighten.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8550123..fa8bdc0 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -14,7 +14,10 @@
 #include <xen/xen-ops.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <asm/arch_timer.h>
 #include <asm/system_misc.h>
+#include <asm/paravirt.h>
+#include <linux/jump_label.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/module.h>
@@ -154,6 +157,19 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
 
+unsigned long long xen_stolen_accounting(int cpu)
+{
+	struct vcpu_runstate_info state;
+
+	BUG_ON(cpu != smp_processor_id());
+
+	xen_get_runstate_snapshot(&state);
+
+	WARN_ON(state.state != RUNSTATE_running);
+
+	return state.time[RUNSTATE_runnable] + state.time[RUNSTATE_offline];
+}
+
 static void __init xen_percpu_init(void *unused)
 {
 	struct vcpu_register_vcpu_info info;
@@ -171,6 +187,8 @@ static void __init xen_percpu_init(void *unused)
 	BUG_ON(err);
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
+	xen_setup_runstate_info(cpu);
+
 	enable_percpu_irq(xen_events_irq, 0);
 	put_cpu();
 }
@@ -313,6 +331,9 @@ static int __init xen_init_events(void)
 
 	on_each_cpu(xen_percpu_init, NULL, 0);
 
+	pv_time_ops.steal_clock = xen_stolen_accounting;
+	static_key_slow_inc(&paravirt_steal_enabled);
+
 	return 0;
 }
 postcore_initcall(xen_init_events);
-- 
1.7.10.4

