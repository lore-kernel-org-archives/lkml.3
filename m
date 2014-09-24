Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaIXIEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:04:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7440 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753854AbaIXH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:58:32 -0400
X-IronPort-AV: E=Sophos;i="5.04,587,1406563200"; 
   d="scan'208";a="36385404"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v8 5/8] kvm: Rename make_all_cpus_request() to kvm_make_all_cpus_request() and make it non-static.
Date: Wed, 24 Sep 2014 15:57:55 +0800
Message-ID: <1411545478-9848-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since different architectures need different handling, we will add some arch specific
code later. The code may need to make cpu requests outside kvm_main.c, so make it
non-static and rename it to kvm_make_all_cpus_request().

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c23236a..73de13c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -580,6 +580,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33712fb..0f8b6f6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -152,7 +152,7 @@ static void ack_flush(void *_completed)
 {
 }
 
-static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	int i, cpu, me;
 	cpumask_var_t cpus;
@@ -189,7 +189,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	long dirty_count = kvm->tlbs_dirty;
 
 	smp_mb();
-	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
+	if (kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
 		++kvm->stat.remote_tlb_flush;
 	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
@@ -197,17 +197,17 @@ EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 
 void kvm_reload_remote_mmus(struct kvm *kvm)
 {
-	make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
 void kvm_make_mclock_inprogress_request(struct kvm *kvm)
 {
-	make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
 }
 
 void kvm_make_scan_ioapic_request(struct kvm *kvm)
 {
-	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
1.8.3.1

