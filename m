Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3H0NmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:42:03 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56328 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3H0Nl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:41:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com
Subject: [PATCH 3/3] KVM: x86: add comments where MMIO does not return to the emulator
Date: Tue, 27 Aug 2013 15:41:43 +0200
Message-Id: <1377610903-12356-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
References: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for single-step in the emulator (new in 3.12) does not work for
MMIO or PIO writes, because they are completed without returning to
the emulator.  This is not worse than what we had in 3.11; still, add
comments so that the issue is not forgotten.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 668f19a..3625798 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5122,9 +5122,10 @@ restart:
 		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
 	} else if (vcpu->arch.pio.count) {
-		if (!vcpu->arch.pio.in)
+		if (!vcpu->arch.pio.in) {
+			/* FIXME: return into emulator if single-stepping.  */
 			vcpu->arch.pio.count = 0;
-		else {
+		} else {
 			writeback = false;
 			vcpu->arch.complete_userspace_io = complete_emulated_pio;
 		}
@@ -6154,6 +6155,8 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
 	if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
+
+		/* FIXME: return into emulator if single-stepping.  */
 		if (vcpu->mmio_is_write)
 			return 1;
 		vcpu->mmio_read_completed = 1;
-- 
1.8.3.1

