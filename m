Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3F0Nzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:55:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6804 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab3F0Nyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:54:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="32195045"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <catalin.marinas@arm.com>, <arnd@arndb.de>,
        <olof@lixom.net>, <linux@arm.linux.org.uk>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <marc.zyngier@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 5/5] xen/arm: account for stolen ticks
Date: Thu, 27 Jun 2013 14:54:32 +0100
Message-ID: <1372341272-12512-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306271446570.4782@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306271446570.4782@kaball.uk.xensource.com>
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

