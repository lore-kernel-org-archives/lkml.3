Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3FATT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:19:26 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53568 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3FATTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:19:14 -0400
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
        <linux-kernel@vger.kernel.org>, <stephan.diestelhorst@amd.com>,
        <riel@redhat.com>, <drjones@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Sun, 02 Jun 2013 00:53:28 +0530
Message-Id: <20130601192327.5966.19201.sendpatchset@codeblue>
In-Reply-To: <20130601192125.5966.35563.sendpatchset@codeblue>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
Subject: [PATCH RFC V9 6/19]  xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060119-5816-0000-0000-0000083A23C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen/pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/xen/spinlock.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 860e190..3de6805 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -238,6 +238,8 @@ void xen_uninit_lock_cpu(int cpu)
 	per_cpu(lock_kicker_irq, cpu) = -1;
 }
 
+static bool xen_pvspin __initdata = true;
+
 void __init xen_init_spinlocks(void)
 {
 	/*
@@ -247,10 +249,22 @@ void __init xen_init_spinlocks(void)
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

