Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3EAT2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:28:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54637 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab3EAT1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:27:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,590,1363132800"; 
   d="scan'208";a="22708352"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/3] xen/arm: account for stolen ticks
Date: Wed, 1 May 2013 20:27:40 +0100
Message-ID: <1367436460-10183-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the runstate_memory_area with the hypervisor.
Use arch_timer_stolen_ticks and xen_stolen_accounting to account for
stolen ticks.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index d30042e..8f040a0 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -14,6 +14,7 @@
 #include <xen/xen-ops.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <asm/arch_timer.h>
 #include <asm/system_misc.h>
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
@@ -172,6 +173,8 @@ static int __init xen_secondary_init(unsigned int cpu)
 		   later ones fail to. */
 		per_cpu(xen_vcpu, cpu) = vcpup;
 	}
+
+	xen_setup_runstate_info(cpu);
 	return 0;
 }
 
@@ -272,6 +275,7 @@ static int __init xen_guest_init(void)
 	if (!xen_initial_domain())
 		xenbus_probe(NULL);
 
+	arch_timer_stolen_ticks = xen_stolen_accounting;
 	pm_power_off = xen_power_off;
 	arm_pm_restart = xen_restart;
 
-- 
1.7.2.5

