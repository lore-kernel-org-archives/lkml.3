Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3DBW7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab3DBWul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 23/56] KVM: x86: Prevent starting PIT timers in the absence of irqchip support
Date: Tue,  2 Apr 2013 15:49:50 -0700
Message-Id: <20130402224714.579521362@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jan Kiszka <jan.kiszka@siemens.com>

commit 0924ab2cfa98b1ece26c033d696651fd62896c69 upstream.

User space may create the PIT and forgets about setting up the irqchips.
In that case, firing PIT IRQs will crash the host:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000128
IP: [<ffffffffa10f6280>] kvm_set_irq+0x30/0x170 [kvm]
...
Call Trace:
 [<ffffffffa11228c1>] pit_do_work+0x51/0xd0 [kvm]
 [<ffffffff81071431>] process_one_work+0x111/0x4d0
 [<ffffffff81071bb2>] worker_thread+0x152/0x340
 [<ffffffff81075c8e>] kthread+0x7e/0x90
 [<ffffffff815a4474>] kernel_thread_helper+0x4/0x10

Prevent this by checking the irqchip mode before starting a timer. We
can't deny creating the PIT if the irqchips aren't set up yet as
current user land expects this order to work.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/i8254.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -338,11 +338,15 @@ static enum hrtimer_restart pit_timer_fn
 		return HRTIMER_NORESTART;
 }
 
-static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
+static void create_pit_timer(struct kvm *kvm, u32 val, int is_period)
 {
+	struct kvm_kpit_state *ps = &kvm->arch.vpit->pit_state;
 	struct kvm_timer *pt = &ps->pit_timer;
 	s64 interval;
 
+	if (!irqchip_in_kernel(kvm))
+		return;
+
 	interval = muldiv64(val, NSEC_PER_SEC, KVM_PIT_FREQ);
 
 	pr_debug("create pit timer, interval is %llu nsec\n", interval);
@@ -394,13 +398,13 @@ static void pit_load_count(struct kvm *k
         /* FIXME: enhance mode 4 precision */
 	case 4:
 		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)) {
-			create_pit_timer(ps, val, 0);
+			create_pit_timer(kvm, val, 0);
 		}
 		break;
 	case 2:
 	case 3:
 		if (!(ps->flags & KVM_PIT_FLAGS_HPET_LEGACY)){
-			create_pit_timer(ps, val, 1);
+			create_pit_timer(kvm, val, 1);
 		}
 		break;
 	default:


