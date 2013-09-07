Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3IGOI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:08:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58305 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3IGOI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:08:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] xen/spinlock: Don't setup xen spinlock IPI kicker if disabled.
Date: Sat,  7 Sep 2013 09:46:44 -0400
Message-Id: <1378561605-18998-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to setup this IPI kicker if we are never going
to use the paravirtualized ticketlock mechanism.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/spinlock.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 71db82c..e1bff87 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -105,6 +105,7 @@ static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
+static bool xen_pvspin __initdata = true;
 static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
@@ -223,6 +224,9 @@ void xen_init_lock_cpu(int cpu)
 	int irq;
 	char *name;
 
+	if (!xen_pvspin)
+		return;
+
 	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
@@ -259,13 +263,15 @@ void xen_uninit_lock_cpu(int cpu)
 	if (xen_hvm_domain())
 		return;
 
+	if (!xen_pvspin)
+		return;
+
 	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
 	per_cpu(lock_kicker_irq, cpu) = -1;
 	kfree(per_cpu(irq_name, cpu));
 	per_cpu(irq_name, cpu) = NULL;
 }
 
-static bool xen_pvspin __initdata = true;
 
 void __init xen_init_spinlocks(void)
 {
@@ -305,6 +311,9 @@ static int __init xen_spinlock_debugfs(void)
 	if (d_xen == NULL)
 		return -ENOMEM;
 
+	if (!xen_pvspin)
+		return 0;
+
 	d_spin_debug = debugfs_create_dir("spinlocks", d_xen);
 
 	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
-- 
1.7.7.6

