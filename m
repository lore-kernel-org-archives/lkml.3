Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3EHMLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:11:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12593 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3EHMLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:11:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,634,1363132800"; 
   d="scan'208";a="23987255"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <julien.grall@citrix.com>, <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/3] xen: rename xen_secondary_init and run it on every online cpu
Date: Wed, 8 May 2013 13:11:20 +0100
Message-ID: <1368015080-5182-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename xen_secondary_init to xen_percpu_init.
Run xen_percpu_init on the each online cpu, reuse the current on_each_cpu call.
Merge xen_percpu_enable_events into xen_percpu_init.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 519acf9..ee86bfa 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -152,11 +152,12 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
 
-static int __init xen_secondary_init(unsigned int cpu)
+static void __init xen_percpu_init(void *unused)
 {
 	struct vcpu_register_vcpu_info info;
 	struct vcpu_info *vcpup;
 	int err;
+	int cpu = get_cpu();
 
 	pr_info("Xen: initializing cpu%d\n", cpu);
 	vcpup = per_cpu_ptr(xen_vcpu_info, cpu);
@@ -169,7 +170,7 @@ static int __init xen_secondary_init(unsigned int cpu)
 		BUG();
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
-	return 0;
+	enable_percpu_irq(xen_events_irq, 0);
 }
 
 static void xen_restart(char str, const char *cmd)
@@ -205,7 +206,6 @@ static int __init xen_guest_init(void)
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
 	struct resource res;
-	int i;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
@@ -262,8 +262,6 @@ static int __init xen_guest_init(void)
 			                       sizeof(struct vcpu_info));
 	if (xen_vcpu_info == NULL)
 		return -ENOMEM;
-	for_each_online_cpu(i)
-		xen_secondary_init(i);
 
 	gnttab_init();
 	if (!xen_initial_domain())
@@ -288,11 +286,6 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static __init void xen_percpu_enable_events(void *unused)
-{
-	enable_percpu_irq(xen_events_irq, 0);
-}
-
 static int __init xen_init_events(void)
 {
 	if (!xen_domain() || xen_events_irq < 0)
@@ -306,7 +299,7 @@ static int __init xen_init_events(void)
 		return -EINVAL;
 	}
 
-	on_each_cpu(xen_percpu_enable_events, NULL, 0);
+	on_each_cpu(xen_percpu_init, NULL, 0);
 
 	return 0;
 }
-- 
1.7.2.5

