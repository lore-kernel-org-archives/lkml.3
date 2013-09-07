Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3IGOI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:08:57 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52359 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3IGOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:08:54 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] xen/spinlock: Fix locking path engaging too soon under PVHVM.
Date: Sat,  7 Sep 2013 09:46:41 -0400
Message-Id: <1378561605-18998-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xen_lock_spinning has a check for the kicker interrupts
and if it is not initialised it will spin normally (not enter
the slowpath).

But for PVHVM case we would initialise the kicker interrupt
before the CPU came online. This meant that if the booting
CPU used a spinlock and went in the slowpath - it would
enter the slowpath and block forever. The forever part b/c
during bootup the interrupts are disabled - so the CPU would
never get an IPI kick and would stay stuck in the slowpath
logic forever.

Why would the booting CPU never get an IPI kick? B/c in both
PV and PVHVM we consult the cpu_online_mask to determine whether
the IPI should go to its CPU destination. Since the booting
CPU has not yet finished and set that flag, it meant that
if any spinlocks were taken before the booting CPU had gotten to:

  set_cpu_online(smp_processor_id(), true);

it (booting CPU) we would never get the unkicker IPI
(from xen_unlock_kick) and block forever.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    1 -
 arch/x86/xen/smp.c       |    9 +++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 193097e..fbc002c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1689,7 +1689,6 @@ static int xen_hvm_cpu_notify(struct notifier_block *self, unsigned long action,
 	case CPU_UP_PREPARE:
 		xen_vcpu_setup(cpu);
 		if (xen_have_vector_callback) {
-			xen_init_lock_cpu(cpu);
 			if (xen_feature(XENFEAT_hvm_safe_pvclock))
 				xen_setup_timer(cpu);
 		}
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 597655b..4db779d 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -703,6 +703,15 @@ static int xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
1.7.7.6

