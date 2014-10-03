Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaJCWyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:54:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbaJCWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Philipp Hahn <hahn@univention.de>
Subject: [PATCH 3.10 072/143] KVM: x86: handle idiv overflow at kvm_write_tsc
Date: Fri,  3 Oct 2014 14:34:27 -0700
Message-Id: <20141003213316.672243000@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 8915aa27d5efbb9185357175b0acf884325565f9 upstream.

Its possible that idivl overflows (due to large delta stored in usdiff,
valid scenario).

Create an exception handler to catch the overflow exception (division by zero
is protected by vcpu->arch.virtual_tsc_khz check), and interpret it accordingly
(delta is larger than USEC_PER_SEC).

Fixes https://bugzilla.redhat.com/show_bug.cgi?id=969644

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Philipp Hahn <hahn@univention.de>
Tested-by: Philipp Hahn <hahn@univention.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1196,20 +1196,37 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
+		int faulted = 0;
+
 		/* n.b - signed multiplication and division required */
 		usdiff = data - kvm->arch.last_tsc_write;
 #ifdef CONFIG_X86_64
 		usdiff = (usdiff * 1000) / vcpu->arch.virtual_tsc_khz;
 #else
 		/* do_div() only does unsigned */
-		asm("idivl %2; xor %%edx, %%edx"
-		: "=A"(usdiff)
-		: "A"(usdiff * 1000), "rm"(vcpu->arch.virtual_tsc_khz));
+		asm("1: idivl %[divisor]\n"
+		    "2: xor %%edx, %%edx\n"
+		    "   movl $0, %[faulted]\n"
+		    "3:\n"
+		    ".section .fixup,\"ax\"\n"
+		    "4: movl $1, %[faulted]\n"
+		    "   jmp  3b\n"
+		    ".previous\n"
+
+		_ASM_EXTABLE(1b, 4b)
+
+		: "=A"(usdiff), [faulted] "=r" (faulted)
+		: "A"(usdiff * 1000), [divisor] "rm"(vcpu->arch.virtual_tsc_khz));
+
 #endif
 		do_div(elapsed, 1000);
 		usdiff -= elapsed;
 		if (usdiff < 0)
 			usdiff = -usdiff;
+
+		/* idivl overflow => difference is larger than USEC_PER_SEC */
+		if (faulted)
+			usdiff = USEC_PER_SEC;
 	} else
 		usdiff = USEC_PER_SEC; /* disable TSC match window below */
 


