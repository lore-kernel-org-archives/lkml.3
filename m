Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974Ab3E1Rzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:55:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7888 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917Ab3E1Ry4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:54:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="26477160"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 4/4] xen/arm: account for stolen ticks
Date: Tue, 28 May 2013 18:54:32 +0100
Message-ID: <1369763672-12919-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the runstate_memory_area with the hypervisor.
Use pv_time_ops.steal_clock to account for stolen ticks.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Changes in v4:
- don't use paravirt_steal_rq_enabled: we do not support retrieving
stolen ticks for vcpus other than one we are running on.

Changes in v3:
- use BUG_ON and smp_processor_id.
---
 arch/arm/xen/enlighten.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 13609e0..49839d8 100644
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
@@ -152,6 +155,19 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
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
@@ -169,6 +185,8 @@ static void __init xen_percpu_init(void *unused)
 	BUG_ON(err);
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
+	xen_setup_runstate_info(cpu);
+
 	enable_percpu_irq(xen_events_irq, 0);
 }
 
@@ -300,6 +318,9 @@ static int __init xen_init_events(void)
 
 	on_each_cpu(xen_percpu_init, NULL, 0);
 
+	pv_time_ops.steal_clock = xen_stolen_accounting;
+	static_key_slow_inc(&paravirt_steal_enabled);
+
 	return 0;
 }
 postcore_initcall(xen_init_events);
-- 
1.7.2.5

