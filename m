Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaKAXGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:06:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59995 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Petr Matousek" <pmatouse@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.301430909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 088/102] kvm: vmx: handle invvpid vm exit gracefully
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Matousek <pmatouse@redhat.com>

commit a642fc305053cc1c6e47e4f4df327895747ab485 upstream.

On systems with invvpid instruction support (corresponding bit in
IA32_VMX_EPT_VPID_CAP MSR is set) guest invocation of invvpid
causes vm exit, which is currently not handled and results in
propagation of unknown exit to userspace.

Fix this by installing an invvpid vm exit handler.

This is CVE-2014-3646.

Signed-off-by: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2:
 - Adjust filename
 - Drop inapplicable change to exit reason string array]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/vmx.h      | 2 ++
 arch/x86/kvm/vmx.c              | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -280,6 +280,7 @@ enum vmcs_field {
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
 #define EXIT_REASON_INVEPT              50
+#define EXIT_REASON_INVVPID             53
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5620,6 +5620,12 @@ static int handle_invept(struct kvm_vcpu
 	return 1;
 }
 
+static int handle_invvpid(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5662,6 +5668,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
+	[EXIT_REASON_INVVPID]                 = handle_invvpid,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5846,7 +5853,7 @@ static bool nested_vmx_exit_handled(stru
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
-	case EXIT_REASON_INVEPT:
+	case EXIT_REASON_INVEPT: case EXIT_REASON_INVVPID:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!

