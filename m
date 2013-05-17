Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3EQVu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3EQVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Papan <tomas.papan@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 01/33] KVM: VMX: fix halt emulation while emulating invalid guest sate
Date: Fri, 17 May 2013 14:49:45 -0700
Message-Id: <20130517214917.002275716@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3836,6 +3836,12 @@ static int handle_invalid_guest_state(st
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


