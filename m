Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaGXLyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:54:37 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:18211 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaGXLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:54:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQCAIDy0FOERCABjGdsb2JhbABZhDfQbgGBDBYQAQEBJz2EBAEFJ1IQUVcZiEK5VYZXF49LBxaEMAWKY6hdaQ
X-IPAS-Result: AlQCAIDy0FOERCABjGdsb2JhbABZhDfQbgGBDBYQAQEBJz2EBAEFJ1IQUVcZiEK5VYZXF49LBxaEMAWKY6hdaQ
X-IronPort-AV: E=Sophos;i="5.01,723,1400014800"; 
   d="scan'208";a="116773271"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/2] KVM: x86: set rflags.rf during fault injection
Date: Thu, 24 Jul 2014 14:51:24 +0300
Message-Id: <1406202684-5226-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406202684-5226-1-git-send-email-namit@cs.technion.ac.il>
References: <53CD080A.1000400@redhat.com>
 <1406202684-5226-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 does not automatically set rflags.rf during event injection. This patch
does partial job, setting rflags.rf upon fault injection.  It does not handle
the setting of RF upon interrupt injection on rep-string instruction.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1fd806c..b24c518 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -311,6 +311,31 @@ static int exception_class(int vector)
 	return EXCPT_BENIGN;
 }
 
+#define EXCPT_FAULT		0
+#define EXCPT_TRAP		1
+#define EXCPT_ABORT		2
+#define EXCPT_INTERRUPT		3
+
+static int exception_type(int vector)
+{
+	unsigned int mask;
+
+	if (WARN_ON(vector > 31 || vector == NMI_VECTOR))
+		return EXCPT_INTERRUPT;
+
+	mask = 1 << vector;
+
+	/* #DB is trap, as instruction watchpoints are handled elsewhere */
+	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
+		return EXCPT_TRAP;
+
+	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
+		return EXCPT_ABORT;
+
+	/* Reserved exceptions will result in fault */
+	return EXCPT_FAULT;
+}
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 		bool reinject)
@@ -5882,6 +5907,11 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 		trace_kvm_inj_exception(vcpu->arch.exception.nr,
 					vcpu->arch.exception.has_error_code,
 					vcpu->arch.exception.error_code);
+
+		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+					     X86_EFLAGS_RF);
+
 		kvm_x86_ops->queue_exception(vcpu, vcpu->arch.exception.nr,
 					  vcpu->arch.exception.has_error_code,
 					  vcpu->arch.exception.error_code,
-- 
1.9.1

