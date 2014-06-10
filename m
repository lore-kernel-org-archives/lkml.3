Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbaFJUgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:36:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34889 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaFJTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 012/160] xen/spinlock: Don't enable them unconditionally.
Date: Tue, 10 Jun 2014 12:44:12 -0700
Message-Id: <1402429600-20477-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit e0fc17a936334c08b2729fff87168c03fdecf5b6 upstream.

The git commit a945928ea2709bc0e8e8165d33aed855a0110279
('xen: Do not enable spinlocks before jump_label_init() has executed')
was added to deal with the jump machinery. Earlier the code
that turned on the jump label was only called by Xen specific
functions. But now that it had been moved to the initcall machinery
it gets called on Xen, KVM, and baremetal - ouch!. And the detection
machinery to only call it on Xen wasn't remembered in the heat
of merge window excitement.

This means that the slowpath is enabled on baremetal while it should
not be.

Reported-by: Waiman Long <waiman.long@hp.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/xen/spinlock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0e36cde..37c6970 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -274,7 +274,7 @@ void __init xen_init_spinlocks(void)
 		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
 		return;
 	}
-
+	printk(KERN_DEBUG "xen: PV spinlocks enabled\n");
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
 }
@@ -290,6 +290,9 @@ static __init int xen_init_spinlocks_jump(void)
 	if (!xen_pvspin)
 		return 0;
 
+	if (!xen_domain())
+		return 0;
+
 	static_key_slow_inc(&paravirt_ticketlocks_enabled);
 	return 0;
 }
-- 
1.9.1

