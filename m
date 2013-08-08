Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966895Ab3HHXVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:21:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:21:11 -0400
Date: Thu, 8 Aug 2013 16:19:58 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-9f091fd2047dc4f9cc512e88f818786274fa646f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130806114224.20643.9099.sendpatchset@codeblue.in.ibm.com>
References: <20130806114224.20643.9099.sendpatchset@codeblue.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] xen, pvticketlocks:
  Add xen_nopvspin parameter to disable xen pv ticketlocks
Git-Commit-ID: 9f091fd2047dc4f9cc512e88f818786274fa646f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 08 Aug 2013 16:20:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f091fd2047dc4f9cc512e88f818786274fa646f
Gitweb:     http://git.kernel.org/tip/9f091fd2047dc4f9cc512e88f818786274fa646f
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Tue, 6 Aug 2013 17:12:24 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 8 Aug 2013 16:06:42 -0700

xen, pvticketlocks: Add xen_nopvspin parameter to disable xen pv ticketlocks

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/20130806114224.20643.9099.sendpatchset@codeblue.in.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/spinlock.c | 14 ++++++++++++++
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
