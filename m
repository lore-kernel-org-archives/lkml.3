Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448AbaBDVva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:51:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934366AbaBDVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        mtosatti@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.13 009/140] x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101
Date: Tue,  4 Feb 2014 13:09:56 -0800
Message-Id: <20140204211037.235397739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 77f01bdfa5e55dc19d3eb747181d2730a9bb3ca8 upstream.

When Hyper-V hypervisor leaves are present, KVM must relocate
its own leaves at 0x40000100, because Windows does not look for
Hyper-V leaves at indices other than 0x40000000.  In this case,
the KVM features are at 0x40000101, but the old code would always
look at 0x40000001.

Fix by using kvm_cpuid_base().  This also requires making the
function non-inline, since kvm_cpuid_base() is static.

Fixes: 1085ba7f552d84aa8ac0ae903fa8d0cc2ff9f79d
Cc: mtosatti@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_para.h |   11 ++++++-----
 arch/x86/kernel/kvm.c           |    5 +++++
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,13 +85,9 @@ static inline long kvm_hypercall4(unsign
 	return ret;
 }
 
-static inline unsigned int kvm_arch_para_features(void)
-{
-	return cpuid_eax(KVM_CPUID_FEATURES);
-}
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
+unsigned int kvm_arch_para_features(void);
 void __init kvm_guest_init(void);
 void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
@@ -115,6 +111,11 @@ static inline bool kvm_para_available(vo
 {
 	return 0;
 }
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
 
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -527,6 +527,11 @@ bool kvm_para_available(void)
 }
 EXPORT_SYMBOL_GPL(kvm_para_available);
 
+unsigned int kvm_arch_para_features(void)
+{
+	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
+}
+
 static uint32_t __init kvm_detect(void)
 {
 	return kvm_cpuid_base();


