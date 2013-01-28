Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3A1TU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:20:58 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47865 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3A1TUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:20:55 -0500
Subject: [PATCH] fix 32-bit compile warning from printk()
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 11:19:39 -0800
Message-Id: <20130128191939.7F67966B@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012819-7182-0000-0000-000004C20434
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My patch "Fix kvm's use of __pa() on percpu areas" introduced a
compile warning:

arch/x86/kernel/kvm.c: In function 'kvm_register_steal_time':
arch/x86/kernel/kvm.c:302:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]

According to: Documentation/printk-formats.txt

	If <type> is dependent on a config option for its size
	(e.g., phys_addr_t) ... use a format specifier of its
	largest possible type and explicitly cast to it.

So, we'll do just that.  We will consider it an unsigned long
long, and cast to it explicitly.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kernel/kvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/kvm.c~fix-32-bit-compile-warning arch/x86/kernel/kvm.c
--- linux-2.6.git/arch/x86/kernel/kvm.c~fix-32-bit-compile-warning	2013-01-28 11:16:39.786938232 -0800
+++ linux-2.6.git-dave/arch/x86/kernel/kvm.c	2013-01-28 11:16:39.790938273 -0800
@@ -298,8 +298,8 @@ static void kvm_register_steal_time(void
 	memset(st, 0, sizeof(*st));
 
 	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
-	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
-		cpu, slow_virt_to_phys(st));
+	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %llx\n",
+		cpu, (unsigned long long)slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
_

