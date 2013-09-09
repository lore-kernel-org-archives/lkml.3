Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3IIPNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:13:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28877 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3IIPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:11:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] xen/spinlock: Fix locking path engaging too soon under PVHVM.
Date: Mon,  9 Sep 2013 11:11:32 -0400
Message-Id: <1378739496-17468-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
References: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xen_lock_spinning has a check for the kicker interrupts
and if it is not initialized it will spin normally (not enter
the slowpath).

But for PVHVM case we would initialize the kicker interrupt
before the CPU came online. This meant that if the booting
CPU used a spinlock and went in the slowpath - it would
enter the slowpath and block forever. The forever part because
during bootup: the spinlock would be taken _before_ the CPU
sets itself to be online (more on this further), and we enter
to poll on the event channel forever.

The bootup CPU (see commit fc78d343fa74514f6fd117b5ef4cd27e4ac30236
"xen/smp: initialize IPI vectors before marking CPU online"
for details) and the CPU that started the bootup consult
the cpu_online_mask to determine whether the booting CPU should
get an IPI. The booting CPU has to set itself in this mask via:

  set_cpu_online(smp_processor_id(), true);

However, if the spinlock is taken before this (and it is) and
it polls on an event channel - it will never be woken up as
the kernel will never send an IPI to an offline CPU.

Note that the PVHVM logic in sending IPIs is using the HVM
path which has numerous checks using the cpu_online_mask
and cpu_active_mask. See above mention git commit for details.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/enlighten.c | 1 -
 arch/x86/xen/smp.c       | 9 +++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2fc216d..fa6ade7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1692,7 +1692,6 @@ static int xen_hvm_cpu_notify(struct notifier_block *self, unsigned long action,
 	case CPU_UP_PREPARE:
 		xen_vcpu_setup(cpu);
 		if (xen_have_vector_callback) {
-			xen_init_lock_cpu(cpu);
 			if (xen_feature(XENFEAT_hvm_safe_pvclock))
 				xen_setup_timer(cpu);
 		}
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 9235842..c21b825 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -709,6 +709,15 @@ static int xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	WARN_ON(rc);
 	if (!rc)
 		rc =  native_cpu_up(cpu, tidle);
+
+	/*
+	 * We must initialize the slowpath CPU kicker _after_ the native
+	 * path has executed. If we initialized it before none of the
+	 * unlocker IPI kicks would reach the booting CPU as the booting
+	 * CPU had not set itself 'online' in cpu_online_mask. That mask
+	 * is checked when IPIs are sent (on HVM at least).
+	 */
+	xen_init_lock_cpu(cpu);
 	return rc;
 }
 
-- 
1.8.3.1

