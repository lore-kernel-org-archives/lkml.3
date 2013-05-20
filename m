Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3ETKxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab3ETKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gleb Natapov <gleb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 076/115] KVM: VMX: fix halt emulation while emulating invalid guest sate
Date: Mon, 20 May 2013 11:51:16 +0100
Message-Id: <1369047116-9378-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/vmx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 61593fd..eed06fc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4920,6 +4920,12 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (err != EMULATE_DONE)
 			return 0;
 
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

