Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbaE2OJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:09:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59420 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933291AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/103] xen/spinlock: Don't enable them unconditionally.
Date: Thu, 29 May 2014 15:48:15 +0200
Message-Id: <696a8b6ad3ff961ab3530a9adaaa4cb160017231.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/xen/spinlock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index be6b86078957..ba81b546d714 100644
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
1.9.3

