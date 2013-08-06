Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3HFLtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:49:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44958 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3HFLtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:49:16 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <riel@redhat.com>,
        <drjones@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Tue, 06 Aug 2013 17:12:24 +0530
Message-Id: <20130806114224.20643.9099.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH  V12 6/14] xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080611-3620-0000-0000-000003D3D9BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks

From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/xen/spinlock.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index a458729..669a971 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -244,6 +244,8 @@ void xen_uninit_lock_cpu(int cpu)
 	per_cpu(irq_name, cpu) = NULL;
 }
 
+static bool xen_pvspin __initdata = true;
+
 void __init xen_init_spinlocks(void)
 {
 	/*
@@ -253,10 +255,22 @@ void __init xen_init_spinlocks(void)
 	if (xen_hvm_domain())
 		return;
 
+	if (!xen_pvspin) {
+		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
+		return;
+	}
+
 	pv_lock_ops.lock_spinning = xen_lock_spinning;
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
 
+static __init int xen_parse_nopvspin(char *arg)
+{
+	xen_pvspin = false;
+	return 0;
+}
+early_param("xen_nopvspin", xen_parse_nopvspin);
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct dentry *d_spin_debug;

