Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaHUQKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbaHUQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:50 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 5/7] KVM: trace kvm_ple_window grow/shrink
Date: Thu, 21 Aug 2014 18:08:09 +0200
Message-Id: <1408637291-18533-6-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracepoint for dynamic PLE window, fired on every potential change.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/trace.h | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c   | 10 ++++++++--
 arch/x86/kvm/x86.c   |  1 +
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e850a7d..1742dfb 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -848,6 +848,36 @@ TRACE_EVENT(kvm_track_tsc,
 		  __print_symbolic(__entry->host_clock, host_clocks))
 );
 
+TRACE_EVENT(kvm_ple_window,
+	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
+	TP_ARGS(grow, vcpu_id, new, old),
+
+	TP_STRUCT__entry(
+		__field(                bool,      grow         )
+		__field(        unsigned int,   vcpu_id         )
+		__field(                 int,       new         )
+		__field(                 int,       old         )
+	),
+
+	TP_fast_assign(
+		__entry->grow           = grow;
+		__entry->vcpu_id        = vcpu_id;
+		__entry->new            = new;
+		__entry->old            = old;
+	),
+
+	TP_printk("vcpu %u: ple_window %d (%s %d)",
+	          __entry->vcpu_id,
+	          __entry->new,
+	          __entry->grow ? "grow" : "shrink",
+	          __entry->old)
+);
+
+#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
+	trace_kvm_ple_window(true, vcpu_id, new, old)
+#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
+	trace_kvm_ple_window(false, vcpu_id, new, old)
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _TRACE_KVM_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a2fa6ba..273cbd5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5728,16 +5728,22 @@ static int __shrink_ple_window(int val, int modifier, int minimum)
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int old = vmx->ple_window;
 
-	vmx->ple_window = __grow_ple_window(vmx->ple_window);
+	vmx->ple_window = __grow_ple_window(old);
+
+	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int old = vmx->ple_window;
 
-	vmx->ple_window = __shrink_ple_window(vmx->ple_window,
+	vmx->ple_window = __shrink_ple_window(old,
 	                                      ple_window_shrink, ple_window);
+
+	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5696ee7..814b20c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7648,3 +7648,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
-- 
2.1.0

