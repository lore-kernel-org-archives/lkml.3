Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaCDVNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:13:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaCDUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kashyap Chamarty <kchamart@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Anthoine Bourgeois <bourgeois@bertin.fr>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.13 085/172] kvm, vmx: Really fix lazy FPU on nested guest
Date: Tue,  4 Mar 2014 12:02:49 -0800
Message-Id: <20140304200302.451905856@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 1b385cbdd74aa803e966e01e5fe49490d6044e30 upstream.

Commit e504c9098ed6 (kvm, vmx: Fix lazy FPU on nested guest, 2013-11-13)
highlighted a real problem, but the fix was subtly wrong.

nested_read_cr0 is the CR0 as read by L2, but here we want to look at
the CR0 value reflecting L1's setup.  In other words, L2 might think
that TS=0 (so nested_read_cr0 has the bit clear); but if L1 is actually
running it with TS=1, we should inject the fault into L1.

The effective value of CR0 in L2 is contained in vmcs12->guest_cr0, use
it.

Fixes: e504c9098ed6acd9e1079c5e10e4910724ad429f
Reported-by: Kashyap Chamarty <kchamart@redhat.com>
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Kashyap Chamarty <kchamart@redhat.com>
Tested-by: Anthoine Bourgeois <bourgeois@bertin.fr>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6644,7 +6644,7 @@ static bool nested_vmx_exit_handled(stru
 		else if (is_page_fault(intr_info))
 			return enable_ept;
 		else if (is_no_device(intr_info) &&
-			 !(nested_read_cr0(vmcs12) & X86_CR0_TS))
+			 !(vmcs12->guest_cr0 & X86_CR0_TS))
 			return 0;
 		return vmcs12->exception_bitmap &
 				(1u << (intr_info & INTR_INFO_VECTOR_MASK));


