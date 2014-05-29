Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbaE2FeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:34:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbaE2EfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Waiman Long <waiman.long@hp.com>, Steven Rostedt <rostedt@goodmis.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.14 025/140] xen/spinlock: Dont enable them unconditionally.
Date: Wed, 28 May 2014 21:32:44 -0700
Message-Id: <20140529043052.602094027@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/spinlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
@@ -290,6 +290,9 @@ static __init int xen_init_spinlocks_jum
 	if (!xen_pvspin)
 		return 0;
 
+	if (!xen_domain())
+		return 0;
+
 	static_key_slow_inc(&paravirt_ticketlocks_enabled);
 	return 0;
 }


