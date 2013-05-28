Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3E1Dzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758733Ab3E1DyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gleb Natapov" <gleb@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Tomas Papan" <tomas.papan@gmail.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.873072271@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [23/94] KVM: VMX: fix halt emulation while emulating invalid
 guest sate
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4882,6 +4882,12 @@ static int handle_invalid_guest_state(st
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

