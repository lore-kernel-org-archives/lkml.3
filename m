Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbAOMxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:53:18 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:44716 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbbAOMxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:53:16 -0500
X-Greylist: delayed 999 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 07:53:15 EST
Subject: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly bug
 with guestos RFLAGS.IF=0
X-KeepSent: 9FB4191F:311C876C-48257DCE:003C223F;
 type=4; name=$KeepSent
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn>
From: "Li Kaihang" <li.kaihang@zte.com.cn>
Date: Thu, 15 Jan 2015 20:36:12 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP6|November 21, 2013) at
 2015-01-15 20:36:21
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn t0FCaLaI073928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fix a external interrupt injecting bug in linux 3.19-rc4.

GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
a processor hardware exception causing virtual machine crash.

Now, I show more details about this problem:

A general external interrupt processing for a running virtual machine is shown in the following:

Step 1:
     a ext intr gen a vm_exit --> vmx_complete_interrupts --> __vmx_complete_interrupts --> case INTR_TYPE_EXT_INR: kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);

Step 2:
     kvm_x86_ops->handle_external_intr(vcpu);

Step 3:
     get back to vcpu_enter_guest after a while cycle,then run inject_pending_event

Step 4:
     if (vcpu->arch.interrupt.pending) {
		kvm_x86_ops->set_irq(vcpu);
		return 0;
	}

Step 5:
     kvm_x86_ops->run(vcpu) --> vm_entry inject vector to guestos IDT

for the above steps, step 4 and 5 will be a processor hardware exception if step1 happen while guestos RFLAGS.IF = 0, that is to say, guestos interrupt is disabled.
So we should add a logic to judge in step 1 whether a external interrupt need to be pended then inject directly, in the process, we don't need to worry about
this external interrupt lost because the next Step 2 will handle and choose a best chance to inject it by virtual interrupt controller.


Signed-off-by: Li kaihang <li.kaihang@zte.com.cn>
---
 arch/x86/kvm/vmx.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d4c58d8..e8311ee 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7711,10 +7711,26 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
                break;
        case INTR_TYPE_SOFT_INTR:
                vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
-               /* fall through */
-       case INTR_TYPE_EXT_INTR:
+               /*
+               * As software and external interrupts may all get here,
+               * we should separate soft intr from ext intr code,and this
+               * will ensure that software interrupts handling process is not
+               * affected by solving external interrupt invalid injecting.
+               */
                kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
                break;
+       case INTR_TYPE_EXT_INTR:
+               /*
+               * GuestOS is running and handling some interrupt with
+               * RFLAGS.IF = 0 while a external interrupt coming,
+               * then can lead a vm exit getting here,in this case,
+               * we must avoid inject this external interrupt or it will
+               * generate a processor hardware exception causing vm crash.
+               */
+               if (kvm_x86_ops->interrupt_allowed(vcpu))
+                       kvm_queue_interrupt(vcpu, vector,
+                                       type == INTR_TYPE_SOFT_INTR);
+               break;
        default:
                break;
        }
--

--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
