Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3FDIgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:36:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44599 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FDIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:36:22 -0400
X-AuditID: 85900ec0-d56cbb900000151e-28-51ada704c1f7
Subject: [PATCH V2 1/1] kvm/vmx: Add a tracepoint write_tsc_offset
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 04 Jun 2013 17:36:19 +0900
Message-ID: <20130604083619.22713.25360.stgit@yunodevel>
In-Reply-To: <20130604083616.22713.24922.stgit@yunodevel>
References: <20130604083616.22713.24922.stgit@yunodevel>
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
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/trace.h |   18 ++++++++++++++++++
 arch/x86/kvm/vmx.c   |    3 +++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index fe5e00e..9c22e39 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -815,6 +815,24 @@ TRACE_EVENT(kvm_track_tsc,
 		  __print_symbolic(__entry->host_clock, host_clocks))
 );
 
+TRACE_EVENT(kvm_write_tsc_offset,
+	TP_PROTO(__u64 previous_tsc_offset, __u64 next_tsc_offset),
+	TP_ARGS(previous_tsc_offset, next_tsc_offset),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	previous_tsc_offset		)
+		__field(	__u64,	next_tsc_offset			)
+	),
+
+	TP_fast_assign(
+		__entry->previous_tsc_offset	= previous_tsc_offset;
+		__entry->next_tsc_offset	= next_tsc_offset;
+	),
+
+	TP_printk("previous=%llu next=%llu",
+		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
+);
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _TRACE_KVM_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 25a791e..00f7dde 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2096,6 +2096,7 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 			(nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETING) ?
 			 vmcs12->tsc_offset : 0));
 	} else {
+		trace_kvm_write_tsc_offset(vmcs_read64(TSC_OFFSET), offset);
 		vmcs_write64(TSC_OFFSET, offset);
 	}
 }
@@ -2103,6 +2104,8 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool host)
 {
 	u64 offset = vmcs_read64(TSC_OFFSET);
+
+	trace_kvm_write_tsc_offset(offset, offset + adjustment);
 	vmcs_write64(TSC_OFFSET, offset + adjustment);
 	if (is_guest_mode(vcpu)) {
 		/* Even when running L2, the adjustment needs to apply to L1 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a8b1a..c942a0c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7264,3 +7264,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);

