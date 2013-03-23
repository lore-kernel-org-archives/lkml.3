Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423005Ab3CWBZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488Ab3CWBZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455607"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, jeremy@goop.org
Subject: [PATCH 09/29] x86, xen: Support arch_spin_unlock_irq/flags
Date: Fri, 22 Mar 2013 18:25:03 -0700
Message-Id: <1364001923-10796-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add simple implementations of arch_spin_unlock_flags/irq to the Xen
paravirt spinlock code.

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/xen/spinlock.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index f7a080e..4e22520 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -353,6 +353,21 @@ static void xen_spin_unlock(struct arch_spinlock *lock)
 		xen_spin_unlock_slow(xl);
 }
 
+/* inline the Xen functions for irqs? */
+
+static void xen_spin_unlock_flags(struct arch_spinlock *lock,
+				  unsigned long flags)
+{
+	xen_spin_unlock(lock);
+	local_irq_restore(flags);
+}
+
+static void xen_spin_unlock_irq(struct arch_spinlock *lock)
+{
+	xen_spin_unlock(lock);
+	local_irq_enable();
+}
+
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
 	BUG();
@@ -395,6 +410,8 @@ void __init xen_init_spinlocks(void)
 	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
 	pv_lock_ops.spin_trylock = xen_spin_trylock;
 	pv_lock_ops.spin_unlock = xen_spin_unlock;
+	pv_lock_ops.spin_unlock_flags = xen_spin_unlock_flags;
+	pv_lock_ops.spin_unlock_irq = xen_spin_unlock_irq;
 }
 
 #ifdef CONFIG_XEN_DEBUG_FS
-- 
1.7.7.6

