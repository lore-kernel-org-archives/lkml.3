Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab3E1Vj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:39:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3E1VYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gleb Natapov <gleb@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 29/78] KVM: VMX: fix halt emulation while emulating invalid guest sate
Date: Tue, 28 May 2013 14:19:38 -0700
Message-Id: <1369776027-17859-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 8d76c49e9ffeee839bc0b7a3278a23f99101263e upstream.

The invalid guest state emulation loop does not check halt_request
which causes 100% cpu loop while guest is in halt and in invalid
state, but more serious issue is that this leaves halt_request set, so
random instruction emulated by vm86 #GP exit can be interpreted
as halt which causes guest hang. Fix both problems by handling
halt_request in emulation loop.

Reported-by: Tomas Papan <tomas.papan@gmail.com>
Tested-by: Tomas Papan <tomas.papan@gmail.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/vmx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9120ae1..1b29ec6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5059,6 +5059,12 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			return 0;
 		}
 
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
+			ret = kvm_emulate_halt(vcpu);
+			goto out;
+		}
+
 		if (signal_pending(current))
 			goto out;
 		if (need_resched())
-- 
1.8.1.2

