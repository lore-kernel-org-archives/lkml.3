Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaJBMAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:00:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41976 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:00:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jan.kiszka@siemens.com
Subject: [PATCH] kvm: do not handle APIC access page if in-kernel irqchip is not in use
Date: Thu,  2 Oct 2014 14:00:25 +0200
Message-Id: <1412251225-1686-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following OOPS:

   loaded kvm module (v3.17-rc1-168-gcec26bc)
   BUG: unable to handle kernel paging request at fffffffffffffffe
   IP: [<ffffffff81168449>] put_page+0x9/0x30
   PGD 1e15067 PUD 1e17067 PMD 0
   Oops: 0000 [#1] PREEMPT SMP
    [<ffffffffa063271d>] ? kvm_vcpu_reload_apic_access_page+0x5d/0x70 [kvm]
    [<ffffffffa013b6db>] vmx_vcpu_reset+0x21b/0x470 [kvm_intel]
    [<ffffffffa0658816>] ? kvm_pmu_reset+0x76/0xb0 [kvm]
    [<ffffffffa064032a>] kvm_vcpu_reset+0x15a/0x1b0 [kvm]
    [<ffffffffa06403ac>] kvm_arch_vcpu_setup+0x2c/0x50 [kvm]
    [<ffffffffa062e540>] kvm_vm_ioctl+0x200/0x780 [kvm]
    [<ffffffff81212170>] do_vfs_ioctl+0x2d0/0x4b0
    [<ffffffff8108bd99>] ? __mmdrop+0x69/0xb0
    [<ffffffff812123d1>] SyS_ioctl+0x81/0xa0
    [<ffffffff8112a6f6>] ? __audit_syscall_exit+0x1f6/0x2a0
    [<ffffffff817229e9>] system_call_fastpath+0x16/0x1b
   Code: c6 78 ce a3 81 4c 89 e7 e8 d9 80 ff ff 0f 0b 4c 89 e7 e8 8f f6 ff ff e9 fa fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 <48> f7 07 00 c0 00 00 55 48 89 e5 75 1e 8b 47 1c 85 c0 74 27 f0
   RIP  [<ffffffff81193045>] put_page+0x5/0x50

when not using the in-kernel irqchip ("-machine kernel_irqchip=off"
with QEMU).

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Fixes: 4256f43f9fab91e1c17b5846a240cf4b66a768a8
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6857257f3810..5430e4b0af29 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6030,6 +6030,9 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	struct page *page = NULL;
 
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
 	if (!kvm_x86_ops->set_apic_access_page_addr)
 		return;
 
-- 
1.8.3.1

