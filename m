Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3EFOwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:52:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14561 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab3EFOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:51:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,622,1363132800"; 
   d="scan'208";a="23502642"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC v2 4/4] xen/arm: account for stolen ticks
Date: Mon, 6 May 2013 15:51:18 +0100
Message-ID: <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the runstate_memory_area with the hypervisor.
Use pv_time_ops.steal_clock to account for stolen ticks.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index ee86bfa..2a5cc82 100644
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
@@ -152,6 +155,20 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
 
+unsigned long long xen_stolen_accounting(int cpu)
+{
+	struct vcpu_runstate_info state;
+
+	if (cpu != get_cpu())
+		BUG();
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
@@ -170,6 +187,8 @@ static void __init xen_percpu_init(void *unused)
 		BUG();
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
+	xen_setup_runstate_info(cpu);
+
 	enable_percpu_irq(xen_events_irq, 0);
 }
 
@@ -301,6 +320,10 @@ static int __init xen_init_events(void)
 
 	on_each_cpu(xen_percpu_init, NULL, 0);
 
+	pv_time_ops.steal_clock = xen_stolen_accounting;
+	static_key_slow_inc(&paravirt_steal_enabled);
+	static_key_slow_inc(&paravirt_steal_rq_enabled);
+
 	return 0;
 }
 postcore_initcall(xen_init_events);
-- 
1.7.2.5

