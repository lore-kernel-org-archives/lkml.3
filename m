Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3FLHnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:43:51 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35353 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3FLHns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:43:48 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-5c-51b826b1747a
Subject: [PATCH V3 1/1] kvm: Add a tracepoint write_tsc_offset
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: David Sharp <dhsharp@google.com>, yrl.pp-manager.tt@hitachi.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>
Date: Wed, 12 Jun 2013 16:43:44 +0900
Message-ID: <20130612074344.25553.97827.stgit@yunodevel>
In-Reply-To: <20130612074341.25553.56877.stgit@yunodevel>
References: <20130612074341.25553.56877.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tracepoint write_tsc_offset for tracing TSC offset change.
We want to merge ftrace's trace data of guest OSs and the host OS using
TSC for timestamp in chronological order. We need "TSC offset" values for
each guest when merge those because the TSC value on a guest is always the
host TSC plus guest's TSC offset. If we get the TSC offset values, we can
calculate the host TSC value for each guest events from the TSC offset and
the event TSC value. The host TSC values of the guest events are used when we
want to merge trace data of guests and the host in chronological order.
(Note: the trace_clock of both the host and the guest must be set x86-tsc in
this case)

This tracepoint also records vcpu_id which can be used to merge trace data for
SMP guests. A merge tool will read TSC offset for each vcpu, then the tool
converts guest TSC values to host TSC values for each vcpu.

TSC offset is stored in the VMCS by vmx_write_tsc_offset() or
vmx_adjust_tsc_offset(). KVM executes the former function when a guest boots.
The latter function is executed when kvm clock is updated. Only host can read
TSC offset value from VMCS, so a host needs to output TSC offset value
when TSC offset is changed.

Since the TSC offset is not often changed, it could be overwritten by other
frequent events while tracing. To avoid that, I recommend to use a special
instance for getting this event:

1. set a instance before booting a guest
 # cd /sys/kernel/debug/tracing/instances
 # mkdir tsc_offset
 # cd tsc_offset
 # echo x86-tsc > trace_clock
 # echo 1 > events/kvm/kvm_write_tsc_offset/enable

2. boot a guest

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/svm.c   |   10 +++++++++-
 arch/x86/kvm/trace.h |   21 +++++++++++++++++++++
 arch/x86/kvm/vmx.c   |    7 ++++++-
 arch/x86/kvm/x86.c   |    1 +
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a14a6ea..c0bc803 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1026,7 +1026,10 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 		g_tsc_offset = svm->vmcb->control.tsc_offset -
 			       svm->nested.hsave->control.tsc_offset;
 		svm->nested.hsave->control.tsc_offset = offset;
-	}
+	} else
+		trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+					   svm->vmcb->control.tsc_offset,
+					   offset);
 
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
 
@@ -1044,6 +1047,11 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool ho
 	svm->vmcb->control.tsc_offset += adjustment;
 	if (is_guest_mode(vcpu))
 		svm->nested.hsave->control.tsc_offset += adjustment;
+	else
+		trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+				     svm->vmcb->control.tsc_offset - adjustment,
+				     svm->vmcb->control.tsc_offset);
+
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index fe5e00e..6c82cf1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -815,6 +815,27 @@ TRACE_EVENT(kvm_track_tsc,
 		  __print_symbolic(__entry->host_clock, host_clocks))
 );
 
+TRACE_EVENT(kvm_write_tsc_offset,
+	TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
+		 __u64 next_tsc_offset),
+	TP_ARGS(vcpu_id, previous_tsc_offset, next_tsc_offset),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	vcpu_id				)
+		__field(	__u64,	previous_tsc_offset		)
+		__field(	__u64,	next_tsc_offset			)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
+		__entry->previous_tsc_offset	= previous_tsc_offset;
+		__entry->next_tsc_offset	= next_tsc_offset;
+	),
+
+	TP_printk("vcpu=%u prev=%llu next=%llu", __entry->vcpu_id,
+		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
+);
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _TRACE_KVM_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 25a791e..eb11856 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2096,6 +2096,8 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 			(nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETING) ?
 			 vmcs12->tsc_offset : 0));
 	} else {
+		trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+					   vmcs_read64(TSC_OFFSET), offset);
 		vmcs_write64(TSC_OFFSET, offset);
 	}
 }
@@ -2103,11 +2105,14 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool host)
 {
 	u64 offset = vmcs_read64(TSC_OFFSET);
+
 	vmcs_write64(TSC_OFFSET, offset + adjustment);
 	if (is_guest_mode(vcpu)) {
 		/* Even when running L2, the adjustment needs to apply to L1 */
 		to_vmx(vcpu)->nested.vmcs01_tsc_offset += adjustment;
-	}
+	} else
+		trace_kvm_write_tsc_offset(vcpu->vcpu_id, offset,
+					   offset + adjustment);
 }
 
 static u64 vmx_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a8b1a..c942a0c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7264,3 +7264,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);

