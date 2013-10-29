Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3J2POK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:14:10 -0400
Received: from mail.tpi.com ([74.45.170.26]:35600 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111Ab3J2POH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:14:07 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
Date: Tue, 29 Oct 2013 09:13:54 -0600
Message-Id: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 specific kvm init creates a new conflicting
debugfs directory which causes modprobe issues
with kvm_intel and kvm_amd. For example,

sudo modprobe kvm_amd
modprobe: ERROR: could not insert 'kvm_amd': Bad address

The simplest fix is to just rename the directory. The following
KVM config options are set:

CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

There is likely a more elegant and complicated way to solve this
problem, but a simple rename for a debug feature seems best,
especially for an -rc7.

 arch/x86/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a0e2a8a..d17895a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -609,7 +609,7 @@ static struct dentry *d_kvm_debug;
 
 struct dentry *kvm_init_debugfs(void)
 {
-	d_kvm_debug = debugfs_create_dir("kvm", NULL);
+	d_kvm_debug = debugfs_create_dir("kvm-x86", NULL);
 	if (!d_kvm_debug)
 		printk(KERN_WARNING "Could not create 'kvm' debugfs directory\n");
 
-- 
1.7.9.5

