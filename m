Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3CJLqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3CJLqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:46:51 -0400
Date: Sun, 10 Mar 2013 13:46:46 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130310114646.GM11223@redhat.com>
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 07:48:33AM +0100, Paolo Bonzini wrote:
> After receiving an INIT signal (either via the local APIC, or through
> KVM_SET_MP_STATE), the bootstrap processor should reset immediately
> and start execution at 0xfffffff0.  Also, SIPIs have no effect on the
> bootstrap processor.  However, KVM currently does not differentiate
> between the BSP and APs.
> 
Userspace is capable of resetting vcpu by itself, so adding code to
handle KVM_SET_MP_STATE(INIT) looks unnecessary to me. I think the
simple patch below (not tested) should handle INIT for in-kernel irq chip
and userspace does not need special handling for cpu reset. It already
knows how to reset cpu on system_reset, so reseting only cpus should not
be different.


diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 02b51dd..6cb3c21 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -731,7 +731,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_INIT:
 		if (!trig_mode || level) {
 			result = 1;
-			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
+				KVM_MP_STATE_SIPI_RECEIVED :
+				KVM_MP_STATE_INIT_RECEIVED;
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		} else {
--
			Gleb.
